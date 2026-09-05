class FMVSArmorManager
{
    static const string DIRECTORY = "$profile:FreezesMVS";
    static const string FILE_PATH = "$profile:FreezesMVS/ArmorSettings.json";
    protected static ref FMVSArmorSettings s_Settings;

    static void Load()
    {
        if (!GetGame() || !GetGame().IsServer())
            return;

        MakeDirectory(DIRECTORY);
        FMVSArmorSettings loaded = new FMVSArmorSettings();
        string errorMessage;

        if (!FileExist(FILE_PATH))
        {
            s_Settings = loaded;
            if (!JsonFileLoader<FMVSArmorSettings>.SaveFile(FILE_PATH, s_Settings, errorMessage))
                ErrorEx("[FreezesMVSArmor] Could not create settings: " + errorMessage);
            else
                Print("[FreezesMVSArmor] Created " + FILE_PATH);
            return;
        }

        if (!JsonFileLoader<FMVSArmorSettings>.LoadFile(FILE_PATH, loaded, errorMessage))
        {
            s_Settings = new FMVSArmorSettings();
            ErrorEx("[FreezesMVSArmor] Invalid settings; defaults active: " + errorMessage);
            return;
        }

        Validate(loaded);
        s_Settings = loaded;
        Print("[FreezesMVSArmor] Loaded " + FILE_PATH);
    }

    protected static void Validate(FMVSArmorSettings value)
    {
        value.DefaultHelmetDamageBlockedPercent = ClampPercent(value.DefaultHelmetDamageBlockedPercent);
        value.DefaultVestDamageBlockedPercent = ClampPercent(value.DefaultVestDamageBlockedPercent);
        if (!value.HelmetOverrides)
            value.HelmetOverrides = new array<ref FMVSArmorRule>;
        if (!value.VestOverrides)
            value.VestOverrides = new array<ref FMVSArmorRule>;

        foreach (FMVSArmorRule helmetRule : value.HelmetOverrides)
            if (helmetRule)
                helmetRule.DamageBlockedPercent = ClampPercent(helmetRule.DamageBlockedPercent);
        foreach (FMVSArmorRule vestRule : value.VestOverrides)
            if (vestRule)
                vestRule.DamageBlockedPercent = ClampPercent(vestRule.DamageBlockedPercent);
    }

    protected static float ClampPercent(float value)
    {
        return Math.Clamp(value, 0.0, 100.0);
    }

    protected static bool DamageTypeEnabled(int damageType, EntityAI source)
    {
        if (source && source.IsInherited(DayZInfected))
            return s_Settings.ProtectAgainstInfected;
        if (damageType == DamageType.FIRE_ARM)
            return s_Settings.ProtectAgainstFirearms;
        if (damageType == DamageType.CLOSE_COMBAT)
            return s_Settings.ProtectAgainstMelee;
        if (damageType == DamageType.EXPLOSION)
            return s_Settings.ProtectAgainstExplosions;
        return s_Settings.ProtectAgainstOtherDamage;
    }

    protected static float RulePercent(EntityAI item, array<ref FMVSArmorRule> rules, float fallback)
    {
        if (!item || item.GetType().IndexOf("MVS_") != 0)
            return 0;

        foreach (FMVSArmorRule rule : rules)
        {
            if (rule && rule.ClassName != "" && item.IsKindOf(rule.ClassName))
                return ClampPercent(rule.DamageBlockedPercent);
        }
        return ClampPercent(fallback);
    }

    static float GetBlockedPercent(PlayerBase player, int damageType, EntityAI source, string damageZone)
    {
        if (!s_Settings)
            Load();
        if (!s_Settings || !s_Settings.Enabled || !DamageTypeEnabled(damageType, source))
            return 0;

        string zone = damageZone;
        zone.ToLower();
        EntityAI armour;

        if (zone.IndexOf("head") >= 0 || zone.IndexOf("brain") >= 0 || zone.IndexOf("face") >= 0)
        {
            armour = player.FindAttachmentBySlotName("Headgear");
            return RulePercent(armour, s_Settings.HelmetOverrides, s_Settings.DefaultHelmetDamageBlockedPercent);
        }

        if (zone.IndexOf("torso") >= 0 || (damageType == DamageType.EXPLOSION && zone == ""))
        {
            armour = player.FindAttachmentBySlotName("Vest");
            return RulePercent(armour, s_Settings.VestOverrides, s_Settings.DefaultVestDamageBlockedPercent);
        }
        return 0;
    }

    static bool DebugEnabled()
    {
        return s_Settings && s_Settings.DebugLogging;
    }
};
