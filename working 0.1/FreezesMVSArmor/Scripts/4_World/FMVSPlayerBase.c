modded class PlayerBase
{
    protected bool m_FMVSApplyingScaledDamage;

    override bool EEOnDamageCalculated(TotalDamageResult damageResult, int damageType, EntityAI source, int component, string dmgZone, string ammo, vector modelPos, float speedCoef)
    {
        if (!super.EEOnDamageCalculated(damageResult, damageType, source, component, dmgZone, ammo, modelPos, speedCoef))
            return false;
        if (!GetGame() || !GetGame().IsServer() || m_FMVSApplyingScaledDamage)
            return true;

        float blockedPercent = FMVSArmorManager.GetBlockedPercent(this, damageType, source, dmgZone);
        if (blockedPercent <= 0)
            return true;

        float damageMultiplier = 1.0 - (blockedPercent / 100.0);
        if (FMVSArmorManager.DebugEnabled())
            Print(string.Format("[FreezesMVSArmor] %1 zone=%2 blockedPercent=%3 ammo=%4", GetType(), dmgZone, blockedPercent, ammo));

        if (damageMultiplier <= 0)
            return false;

        m_FMVSApplyingScaledDamage = true;
        ProcessDirectDamage(damageType, source, dmgZone, ammo, modelPos, damageMultiplier);
        m_FMVSApplyingScaledDamage = false;
        return false;
    }
};
