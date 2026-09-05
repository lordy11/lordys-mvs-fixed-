MODULAR VEST SYSTEM - COMPLETE DAYZ TOOLS PACK
================================================

THIS IS ONE MOD WITH TWO REQUIRED PBOS
  Final mod folder: pack\@MVS
  Both PBOs go in: pack\@MVS\Addons

BUILD 1 - BASE MVS ASSETS AND SCRIPTS
  Source:      pack\ModularVestSystem
  Destination: pack\@MVS\Addons
  Prefix:      ModularVestSystem
  Output:      ModularVestSystem.pbo

BUILD 2 - JSON ARMOUR COMPANION
  Source:      pack\FreezesMVSArmor
  Destination: pack\@MVS\Addons
  Prefix:      FreezesMVSArmor
  Output:      FreezesMVSArmor.pbo

USE THESE SETTINGS FOR BOTH BUILDS
  Direct copy: pack\AddonBuilder_Include.txt
  Binarize:    enabled
  Clear temp:  enabled
  Project:     leave empty/default

FINAL REQUIRED LAYOUT
  pack\@MVS\mod.cpp
  pack\@MVS\meta.cpp
  pack\@MVS\Addons\ModularVestSystem.pbo
  pack\@MVS\Addons\FreezesMVSArmor.pbo

Do not pack pack\@MVS itself into a PBO. It is the finished mod folder.
Load @MVS on the server and every client. Do not load either PBO as a separate
mod, and do not omit FreezesMVSArmor.pbo if JSON armour settings are required.

The base source contains all 1,817 asset paths referenced by config.cpp.
Do not mix P3Ds from the older mvs-rework pack because those models differ and
may contain altered embedded material paths.

FIRST SERVER START
  The server creates:
  <server profile>\FreezesMVS\ArmorSettings.json

FINAL VERIFICATION
  1. Confirm both PBO files exist in @MVS\Addons.
  2. Start a dedicated test server with the same @MVS on server and client.
  3. Check the script log for [FreezesMVSArmor] Created or Loaded.
  4. Confirm the JSON exists in the actual -profiles directory.
  5. Spawn several MVS colour variants and check their textures.
  6. Test helmet/vest Health, Blood and Shock damage before production use.
