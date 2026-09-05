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
        ConfigVersion = 1;
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
        HelmetOverrides.Insert(new FMVSArmorRule("MVS_Altyn_Helmet_Base", 70));
        VestOverrides.Insert(new FMVSArmorRule("ModularVestSystem_Heavy", 65));
    }
};
