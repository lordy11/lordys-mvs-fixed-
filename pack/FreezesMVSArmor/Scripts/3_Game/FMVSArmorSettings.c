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

        // Base-class rules automatically cover every child classname.
        HelmetOverrides.Insert(new FMVSArmorRule("MVS_Altyn_Helmet_Base", 70));
        HelmetOverrides.Insert(new FMVSArmorRule("MVS_ArmoredHelmet_Base", 65));
        VestOverrides.Insert(new FMVSArmorRule("ModularVestSystem_Heavy", 65));
        VestOverrides.Insert(new FMVSArmorRule("ModularChestRig_Base", 50));

        // To override one exact item, add that concrete classname as another rule.
        // Exact classname rules take priority over matching base-class rules.
    }
};
