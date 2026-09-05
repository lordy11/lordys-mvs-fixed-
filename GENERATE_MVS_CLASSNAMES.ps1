$ErrorActionPreference = 'Stop'

$Root = Split-Path -Parent $MyInvocation.MyCommand.Path
$Config = Join-Path $Root 'pack\ModularVestSystem\config.cpp'
$Output = Join-Path $Root 'MVS_CLASSNAMES.txt'
$BaseOutput = Join-Path $Root 'MVS_CLASSNAME_BASES.txt'

if (!(Test-Path $Config)) {
    Write-Host "ERROR: Could not find $Config" -ForegroundColor Red
    exit 1
}

$text = Get-Content -Raw -Path $Config

# Build a map of every declared class -> direct parent.
# This lets us resolve inheritance chains such as:
# MVS_ChestRig_OD -> ModularChestRig_Base -> Clothing
$parentMap = @{}
$declarations = [regex]::Matches($text, '(?m)^\s*class\s+([A-Za-z0-9_]+)\s*(?::\s*([A-Za-z0-9_]+))?\s*(?:\{|;)')
foreach ($decl in $declarations) {
    $className = $decl.Groups[1].Value
    $parentName = $decl.Groups[2].Value
    if (-not $parentMap.ContainsKey($className)) {
        $parentMap[$className] = $parentName
    }
}

function Get-InheritanceChain([string]$ClassName) {
    $chain = New-Object System.Collections.Generic.List[string]
    $seen = @{}
    $current = $ClassName

    while ($parentMap.ContainsKey($current)) {
        $parent = [string]$parentMap[$current]
        if ([string]::IsNullOrWhiteSpace($parent)) { break }
        if ($seen.ContainsKey($parent)) { break }

        $chain.Add($parent)
        $seen[$parent] = $true
        $current = $parent
    }

    return ($chain -join ' -> ')
}

# Match item classes and capture the class name, optional parent, and body.
# Keep only public/spawnable classes (scope = 2).
$matches = [regex]::Matches($text, '(?ms)^\s*class\s+([A-Za-z0-9_]+)\s*(?::\s*([A-Za-z0-9_]+))?\s*\{(.*?)^\s*\};')

$items = @()
foreach ($m in $matches) {
    $name = $m.Groups[1].Value
    $parent = $m.Groups[2].Value
    $body = $m.Groups[3].Value

    if ($body -notmatch '(?m)^\s*scope\s*=\s*2\s*;') { continue }

    $display = ''
    $dm = [regex]::Match($body, '(?m)^\s*displayName\s*=\s*"([^"]*)"\s*;')
    if ($dm.Success) { $display = $dm.Groups[1].Value }

    # Prefer the declaration map when available.
    if ($parentMap.ContainsKey($name) -and -not [string]::IsNullOrWhiteSpace([string]$parentMap[$name])) {
        $parent = [string]$parentMap[$name]
    }

    $chain = Get-InheritanceChain $name

    $category = 'OTHER / MISC'
    $n = $name.ToLowerInvariant()
    $d = $display.ToLowerInvariant()

    if ($n -match 'countryflag|patch') { $category = 'PATCHES / COUNTRY FLAGS' }
    elseif ($n -match 'combat_vest_heavy|heavy.*vest' -or $d -match 'heavy.*vest|mvs heavy') { $category = 'HEAVY VESTS' }
    elseif ($n -match 'combat_vest|chestrig' -or $d -match 'chest.?rig|modular vest') { $category = 'VESTS / CHEST RIGS' }
    elseif ($n -match 'altyn|armoredhelmet|opscore|helmet' -or $d -match 'helmet') { $category = 'HELMETS' }
    elseif ($n -match 'assault_pack|slingpack|compact|pack_' -or $d -match 'pack') { $category = 'BACKPACKS' }
    elseif ($n -match 'pouch|molle' -or $d -match 'pouch|molle') { $category = 'POUCHES / MOLLE' }
    elseif ($n -match 'belt' -or $d -match 'belt') { $category = 'BELTS' }
    elseif ($n -match 'holster' -or $d -match 'holster') { $category = 'HOLSTERS' }
    elseif ($n -match 'sheath' -or $d -match 'sheath') { $category = 'SHEATHS' }
    elseif ($n -match 'canteen' -or $d -match 'canteen') { $category = 'CANTEENS' }
    elseif ($n -match 'respirator|gasmask|pmk' -or $d -match 'respirator|gas mask') { $category = 'MASKS / RESPIRATORS' }
    elseif ($n -match 'beard' -or $d -match 'beard') { $category = 'BEARDS' }
    elseif ($n -match 'cap_' -or $d -match 'patrol cap') { $category = 'CAPS / HEADWEAR' }
    elseif ($n -match 'pants|shirt|jacket|uniform|gloves|boots' -or $d -match 'pants|shirt|jacket|uniform|gloves|boots') { $category = 'CLOTHING / UNIFORMS' }
    elseif ($n -match 'armorrack|armor_rack' -or $d -match 'armor rack') { $category = 'ARMOR RACK / STORAGE' }

    $items += [pscustomobject]@{
        Category = $category
        ClassName = $name
        DisplayName = $display
        Parent = $parent
        InheritanceChain = $chain
    }
}

$items = $items | Sort-Object ClassName -Unique

$order = @(
    'VESTS / CHEST RIGS',
    'HEAVY VESTS',
    'HELMETS',
    'BACKPACKS',
    'BELTS',
    'POUCHES / MOLLE',
    'HOLSTERS',
    'SHEATHS',
    'CANTEENS',
    'MASKS / RESPIRATORS',
    'CAPS / HEADWEAR',
    'CLOTHING / UNIFORMS',
    'BEARDS',
    'PATCHES / COUNTRY FLAGS',
    'ARMOR RACK / STORAGE',
    'OTHER / MISC'
)

$lines = New-Object System.Collections.Generic.List[string]
$lines.Add('MODULAR VEST SYSTEM - COMPLETE SPAWNABLE CLASSNAME LIST')
$lines.Add('Generated directly from: pack\ModularVestSystem\config.cpp')
$lines.Add('Only classes with scope = 2 are included.')
$lines.Add('Each entry includes the direct base class and full inheritance chain where available.')
$lines.Add(('Generated: ' + (Get-Date -Format 'yyyy-MM-dd HH:mm:ss')))
$lines.Add('')
$lines.Add(('TOTAL SPAWNABLE CLASSNAMES: ' + $items.Count))
$lines.Add('')

foreach ($category in $order) {
    $group = @($items | Where-Object Category -eq $category | Sort-Object ClassName)
    if ($group.Count -eq 0) { continue }

    $lines.Add('======================================================================')
    $lines.Add($category)
    $lines.Add(('COUNT: ' + $group.Count))
    $lines.Add('======================================================================')
    foreach ($item in $group) {
        $displayText = if ([string]::IsNullOrWhiteSpace($item.DisplayName)) { '(no displayName)' } else { $item.DisplayName }
        $baseText = if ([string]::IsNullOrWhiteSpace($item.Parent)) { '(no parent declared)' } else { $item.Parent }
        $chainText = if ([string]::IsNullOrWhiteSpace($item.InheritanceChain)) { $baseText } else { $item.InheritanceChain }
        $lines.Add(('CLASSNAME : {0}' -f $item.ClassName))
        $lines.Add(('NAME      : {0}' -f $displayText))
        $lines.Add(('BASE      : {0}' -f $baseText))
        $lines.Add(('CHAIN     : {0} -> {1}' -f $item.ClassName, $chainText))
        $lines.Add('')
    }
    $lines.Add('')
}

$lines | Set-Content -Path $Output -Encoding UTF8

$baseLines = New-Object System.Collections.Generic.List[string]
$baseLines.Add('MVS CLASSNAME -> BASE CLASS MAP')
$baseLines.Add('Generated from pack\ModularVestSystem\config.cpp')
$baseLines.Add('')
foreach ($item in ($items | Sort-Object Category, ClassName)) {
    $baseText = if ([string]::IsNullOrWhiteSpace($item.Parent)) { '(no parent declared)' } else { $item.Parent }
    $chainText = if ([string]::IsNullOrWhiteSpace($item.InheritanceChain)) { $baseText } else { $item.InheritanceChain }
    $baseLines.Add(('{0} | BASE: {1} | CHAIN: {0} -> {2}' -f $item.ClassName, $baseText, $chainText))
}
$baseLines | Set-Content -Path $BaseOutput -Encoding UTF8

Write-Host "Created: $Output" -ForegroundColor Green
Write-Host "Created: $BaseOutput" -ForegroundColor Green
Write-Host "Found $($items.Count) spawnable classnames (scope = 2)." -ForegroundColor Green
