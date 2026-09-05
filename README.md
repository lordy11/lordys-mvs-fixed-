# Lordy's MVS Fixed

This repository contains the fixed Modular Vest System source plus the JSON-configurable armour companion. They are built as **one DayZ mod** containing two PBOs.

## Final mod layout

`pack\output\@MVS\`

- `addons\ModularVestSystem.pbo`
- `addons\FreezesMVSArmor.pbo`
- `keys\` (put the public `.bikey` here if you sign the PBOs)
- `mod.cpp`
- `meta.cpp`

Both PBOs belong in the same `@MVS` folder. Do not load `FreezesMVSArmor` as a separate mod.

## One-click build

Run:

`pack\BUILD_ALL_MVS.bat`

It packs:

1. `pack\ModularVestSystem` with prefix `ModularVestSystem`
2. `pack\FreezesMVSArmor` with prefix `FreezesMVSArmor`

Both outputs go directly to:

`pack\output\@MVS\addons`

If DayZ Tools is not installed in the standard Steam location, set the `DAYZ_TOOLS` environment variable to the DayZ Tools folder before running the build script.

## JSON armour settings

On first dedicated-server start, `FreezesMVSArmor.pbo` creates:

`<server profile>\FreezesMVS\ArmorSettings.json`

Edit that file to control how much matching MVS helmets and vests reduce incoming damage. The server reloads it automatically every 60 seconds.

See `ARMOR_JSON_SETUP.md` for the settings format and testing notes.
