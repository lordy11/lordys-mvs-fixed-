# Lordy's MVS Fixed

This repository contains one complete DayZ mod, **@MVS**, built from two PBO source folders.

## Required PBOs

Pack both folders separately with DayZ Tools Addon Builder:

| Build order | Source folder | Prefix | Output PBO |
|---|---|---|---|
| 1 | `pack\ModularVestSystem` | `ModularVestSystem` | `ModularVestSystem.pbo` |
| 2 | `pack\FreezesMVSArmor` | `FreezesMVSArmor` | `FreezesMVSArmor.pbo` |

For each build:

- Destination: `pack\@MVS\Addons`
- Direct-copy list: `pack\AddonBuilder_Include.txt`
- Enable **Binarize** and **Clear temporary folder**
- Leave **Project path** empty/default
- Use the exact prefix shown in the table

The finished mod must contain:

```text
@MVS/
├── Addons/
│   ├── ModularVestSystem.pbo
│   └── FreezesMVSArmor.pbo
├── mod.cpp
└── meta.cpp
```

The ready-made mod shell is in `pack\@MVS`. Load the same `@MVS` folder on the server and every client.

On first dedicated-server start, `FreezesMVSArmor.pbo` creates:

`<server profile>\FreezesMVS\ArmorSettings.json`

See `ARMOR_JSON_SETUP.md` for the armour settings and test requirements.
