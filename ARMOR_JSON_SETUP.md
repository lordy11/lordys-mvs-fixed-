# Freezes MVS JSON Armour

`FreezesMVSArmor` is the JSON armour component of **Lordy's MVS Fixed**. It is not a separate DayZ mod.

The final `@MVS` mod contains two PBOs in the same `addons` folder:

1. `ModularVestSystem.pbo`
2. `FreezesMVSArmor.pbo`

Use `pack/BUILD_ALL_MVS.bat` to build both into:

`pack/output/@MVS/addons`

On first dedicated-server start the armour PBO creates:

`<server profiles>/FreezesMVS/ArmorSettings.json`

Damage values are the percentage stopped in addition to the normal DayZ/MVS armour calculation. `0` stops nothing extra; `50` applies half of the matching damage; `100` rejects matching damage. Values outside 0–100 are clamped.

Rules may name a concrete class or an MVS base class. Restarting is not required after editing: the server reloads the JSON every 60 seconds. Only matching MVS-prefixed items in the Headgear or Vest slots are affected.

Protection is scoped by hit zone: helmets protect head/brain/face; vests protect torso. Explosion protection is disabled by default.

Always test health, blood, shock, bleeding, armour-item damage and compatibility with your other combat mods on a test server before using new values on the live server.
