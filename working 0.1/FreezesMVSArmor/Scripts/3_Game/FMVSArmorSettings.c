class FMVSArmorRule
{
    string ClassName;
    float DamageBlockedPercent;

    void FMVSArmorRule(string className = "", float blockedPercent = 0)
    {
        ClassName = className;
        DamageBlockedPercent = blockedPercent;
    }
};

class FMVSArmorSettings
{
    int ConfigVersion;
    bool Enabled;
    float DefaultHelmetDamageBlockedPercent;
    float DefaultVestDamageBlockedPercent;
    bool ProtectAgainstFirearms;
    bool ProtectAgainstMelee;
    bool ProtectAgainstInfected;
    bool ProtectAgainstExplosions;
    bool ProtectAgainstOtherDamage;
    bool DebugLogging;
    ref array<ref FMVSArmorRule> HelmetOverrides;
    ref array<ref FMVSArmorRule> VestOverrides;

    void FMVSArmorSettings()
    {
        ConfigVersion = 2;
        Enabled = true;
        DefaultHelmetDamageBlockedPercent = 50;
        DefaultVestDamageBlockedPercent = 50;
        ProtectAgainstFirearms = true;
        ProtectAgainstMelee = true;
        ProtectAgainstInfected = true;
        ProtectAgainstExplosions = false;
        ProtectAgainstOtherDamage = false;
        DebugLogging = false;
        HelmetOverrides = new array<ref FMVSArmorRule>;
        VestOverrides = new array<ref FMVSArmorRule>;

        // Verified helmet base classes from ModularVestSystem/config.cpp.
        HelmetOverrides.Insert(new FMVSArmorRule("MVS_Helmet_Base", 50));
        HelmetOverrides.Insert(new FMVSArmorRule("MVS_Helmet_2_Base", 50));
        HelmetOverrides.Insert(new FMVSArmorRule("MVS_6B47Helmet_Base", 55));
        HelmetOverrides.Insert(new FMVSArmorRule("MVS_OpsCore_Base", 60));
        HelmetOverrides.Insert(new FMVSArmorRule("MVS_ArmoredHelmet_Base", 65));
        HelmetOverrides.Insert(new FMVSArmorRule("MVS_Altyn_Helmet_Base", 70));

        // Verified vest/chest-rig base classes from ModularVestSystem/config.cpp.
        VestOverrides.Insert(new FMVSArmorRule("ModularChestRig_Base", 35));
        VestOverrides.Insert(new FMVSArmorRule("ModularVestSystem_Base", 50));
        VestOverrides.Insert(new FMVSArmorRule("ModularVestSystem_Heavy", 65));

        // To override one exact item, add that concrete classname as another rule.
        // Exact classname rules take priority over matching base-class rules.
    }
};
