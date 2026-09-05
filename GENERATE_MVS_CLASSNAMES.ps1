$ErrorActionPreference = 'Stop'

$Root = Split-Path -Parent $MyInvocation.MyCommand.Path
$Config = Join-Path $Root 'pack\ModularVestSystem\config.cpp'
$Output = Join-Path $Root 'MVS_CLASSNAMES.txt'

if (!(Test-Path $Config)) {
    Write-Host "ERROR: Could not find $Config" -ForegroundColor Red
    exit 1
}

$text = Get-Content -Raw -Path $Config

# Match top-level item classes and capture the class name, optional parent, and body.
# We then keep only public/spawnable classes (scope = 2).
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
    }
}

# Remove duplicates while preserving the exact classname found in config.cpp.
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
        if ([string]::IsNullOrWhiteSpace($item.DisplayName)) {
            $lines.Add($item.ClassName)
        } else {
            $lines.Add(('{0}  |  {1}' -f $item.ClassName, $item.DisplayName))
        }
    }
    $lines.Add('')
}

$lines | Set-Content -Path $Output -Encoding UTF8
Write-Host "Created: $Output" -ForegroundColor Green
Write-Host "Found $($items.Count) spawnable classnames (scope = 2)." -ForegroundColor Green
