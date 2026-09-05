# Freezes MVS JSON Armour

Pack these two source folders separately with DayZ Tools Addon Builder:

1. `pack/ModularVestSystem` -> `ModularVestSystem.pbo`
2. `pack/FreezesMVSArmor` -> `FreezesMVSArmor.pbo`

Put both PBOs in the same client/server mod. On first dedicated-server start the companion PBO creates:

`<server profiles>/FreezesMVS/ArmorSettings.json`

Damage values are the percentage stopped after normal DayZ/MVS armour calculation. `0` stops nothing; `50` halves remaining damage; `100` rejects matching damage. Values outside 0–100 are clamped.

Rules may name a concrete class or an MVS base class. Restarting is not required after editing: the server reloads the JSON every 60 seconds. Only MVS-prefixed items in the Headgear or Vest slots are affected.

Protection is scoped by hit zone: helmets protect head/brain/face; vests protect torso. Explosion protection is disabled by default. Static compilation cannot prove damage behaviour—test health, blood, shock, bleeding, item damage and compatibility on an isolated LAN server before production.
