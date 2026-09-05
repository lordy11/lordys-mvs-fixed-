param(
    [string]$JsonPath = (Join-Path $PSScriptRoot 'InventorySizes.json'),
    [string]$ConfigPath = (Join-Path $PSScriptRoot 'pack\ModularVestSystem\config.cpp')
)

$ErrorActionPreference = 'Stop'

if (-not (Test-Path $ConfigPath)) {
    throw "MVS config.cpp not found: $ConfigPath"
}

if (-not (Test-Path $JsonPath)) {
    $example = Join-Path $PSScriptRoot 'InventorySizes.example.json'
    if (Test-Path $example) {
        Copy-Item $example $JsonPath -Force
        Write-Host "Created InventorySizes.json from the example file."
    } else {
        throw "InventorySizes.json not found: $JsonPath"
    }
}

$settings = Get-Content -Raw -Path $JsonPath | ConvertFrom-Json
if (-not $settings.Enabled) {
    Write-Host 'Inventory size JSON is disabled. No changes applied.'
    exit 0
}

if (-not $settings.Rules) {
    Write-Host 'No inventory size rules found. No changes applied.'
    exit 0
}

$text = Get-Content -Raw -Path $ConfigPath

function Find-ClassBlock {
    param(
        [string]$Source,
        [string]$ClassName
    )

    $pattern = '(?m)^\s*class\s+' + [regex]::Escape($ClassName) + '\s*(?::\s*[A-Za-z0-9_]+)?\s*\{'
    $match = [regex]::Match($Source, $pattern)
    if (-not $match.Success) { return $null }

    $open = $Source.IndexOf('{', $match.Index)
    if ($open -lt 0) { return $null }

    $depth = 0
    $inString = $false
    $escape = $false

    for ($i = $open; $i -lt $Source.Length; $i++) {
        $ch = $Source[$i]

        if ($inString) {
            if ($escape) {
                $escape = $false
                continue
            }
            if ($ch -eq '\') {
                $escape = $true
                continue
            }
            if ($ch -eq '"') {
                $inString = $false
            }
            continue
        }

        if ($ch -eq '"') {
            $inString = $true
            continue
        }

        if ($ch -eq '{') { $depth++ }
        elseif ($ch -eq '}') {
            $depth--
            if ($depth -eq 0) {
                return [pscustomobject]@{
                    Start = $match.Index
                    OpenBrace = $open
                    CloseBrace = $i
                    BodyStart = $open + 1
                    BodyLength = $i - $open - 1
                }
            }
        }
    }

    return $null
}

function Set-DirectCargoSize {
    param(
        [string]$Source,
        [string]$ClassName,
        [int]$Width,
        [int]$Height
    )

    if ($Width -lt 1 -or $Height -lt 1) {
        throw "Invalid cargo size for $ClassName. Width and height must both be at least 1."
    }

    $block = Find-ClassBlock -Source $Source -ClassName $ClassName
    if (-not $block) {
        Write-Warning "Class not found: $ClassName"
        return $Source
    }

    $body = $Source.Substring($block.BodyStart, $block.BodyLength)

    # Search only at the direct class level, not inside nested DamageSystem/ClothingTypes classes.
    $depth = 0
    $inString = $false
    $escape = $false
    $statementStart = 0
    $cargoStart = -1
    $cargoEnd = -1
    $itemSizeEnd = -1

    for ($i = 0; $i -lt $body.Length; $i++) {
        $ch = $body[$i]

        if ($inString) {
            if ($escape) { $escape = $false; continue }
            if ($ch -eq '\') { $escape = $true; continue }
            if ($ch -eq '"') { $inString = $false }
            continue
        }

        if ($ch -eq '"') { $inString = $true; continue }
        if ($ch -eq '{') { $depth++; continue }
        if ($ch -eq '}') { $depth--; continue }

        if ($depth -eq 0 -and $ch -eq ';') {
            $statement = $body.Substring($statementStart, $i - $statementStart + 1)
            if ($statement -match '(?m)^\s*itemsCargoSize\s*\[\]\s*=') {
                $cargoStart = $statementStart
                $cargoEnd = $i + 1
                break
            }
            if ($statement -match '(?m)^\s*itemSize\s*\[\]\s*=') {
                $itemSizeEnd = $i + 1
            }
            $statementStart = $i + 1
        }
    }

    $newline = "`r`n"
    if ($body -notmatch "`r`n") { $newline = "`n" }
    $replacement = "`t`titemsCargoSize[] = {$Width,$Height};"

    if ($cargoStart -ge 0) {
        $before = $body.Substring(0, $cargoStart)
        $after = $body.Substring($cargoEnd)
        $old = $body.Substring($cargoStart, $cargoEnd - $cargoStart)
        $indentMatch = [regex]::Match($old, '(?m)^([ \t]*)itemsCargoSize')
        if ($indentMatch.Success) {
            $replacement = $indentMatch.Groups[1].Value + "itemsCargoSize[] = {$Width,$Height};"
        }
        $newBody = $before + $replacement + $after
    }
    elseif ($itemSizeEnd -ge 0) {
        $before = $body.Substring(0, $itemSizeEnd)
        $after = $body.Substring($itemSizeEnd)
        $newBody = $before + $newline + $replacement + $after
    }
    else {
        $newBody = $newline + $replacement + $body
    }

    Write-Host ("  {0} -> {1}x{2}" -f $ClassName, $Width, $Height)
    return $Source.Substring(0, $block.BodyStart) + $newBody + $Source.Substring($block.CloseBrace)
}

Write-Host 'Applying MVS inventory cargo sizes from JSON...'
foreach ($rule in $settings.Rules) {
    if (-not $rule.ClassName) {
        Write-Warning 'Skipped rule with an empty ClassName.'
        continue
    }

    $text = Set-DirectCargoSize -Source $text -ClassName ([string]$rule.ClassName) -Width ([int]$rule.CargoWidth) -Height ([int]$rule.CargoHeight)
}

Set-Content -Path $ConfigPath -Value $text -Encoding UTF8
Write-Host 'Inventory cargo sizes applied to pack\ModularVestSystem\config.cpp'
