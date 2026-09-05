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

## Base-class rules

Rules can target either a concrete classname or a base class.

A base-class rule automatically applies to every child classname that inherits from that base. For example:

- `MVS_ArmoredHelmet_Base` covers all armored-helmet colour variants.
- `MVS_Altyn_Helmet_Base` covers all Altyn helmet variants.
- `ModularVestSystem_Heavy` covers all heavy-vest variants inheriting from that class.
- `ModularChestRig_Base` covers all chest-rig variants inheriting from that class.

If both a base-class rule and an exact classname rule match the same item, the exact classname rule wins. This lets you set one value for a whole family and then give one colour/model a different value.

Example:

```json
"HelmetOverrides": [
  {
    "ClassName": "MVS_ArmoredHelmet_Base",
    "DamageBlockedPercent": 65.0
  },
  {
    "ClassName": "MVS_ArmoredHelmet_Black",
    "DamageBlockedPercent": 80.0
  }
]
```

In that example all armored helmets block 65% extra matching damage, except `MVS_ArmoredHelmet_Black`, which blocks 80%.

The server reloads the JSON every 60 seconds, so restarting is not required after normal value edits.

Only MVS armour items in the Headgear or Vest slots are affected. Protection is scoped by hit zone: helmets protect head/brain/face; vests protect torso. Explosion protection is disabled by default.

Always test health, blood, shock, bleeding, armour-item damage and compatibility with your other combat mods on a test server before using new values on the live server.
