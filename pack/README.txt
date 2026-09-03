MODULAR VEST SYSTEM - DAYZ TOOLS PACK
=====================================

PACK THIS FOLDER
  pack\ModularVestSystem

ADDON BUILDER SETTINGS
  Source:      pack\ModularVestSystem
  Destination: pack\output\@MVS\Addons
  Prefix:      ModularVestSystem
  Direct copy: pack\AddonBuilder_Include.txt
  Binarize:    enabled
  Clear temp:  enabled
  Project:     leave empty/default

EXPECTED OUTPUT
  pack\output\@MVS\Addons\ModularVestSystem.pbo

Copy pack\Mod_Files\mod.cpp and meta.cpp into pack\output\@MVS.
Load @MVS on the server and every client.

This pack uses the clean original P3Ds from this repository. Do not mix P3Ds from
the older mvs-rework pack because those models differ and may contain altered
embedded material paths.
