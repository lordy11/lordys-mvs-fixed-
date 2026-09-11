modded class MissionServer
{
    override void OnInit()
    {
        super.OnInit();
        FMVSArmorManager.Load();
        FMVSInventorySizeManager.EnsureFile();
        GetGame().GetCallQueue(CALL_CATEGORY_SYSTEM).CallLater(FMVSArmorManager.Load, 60000, true);
    }
};
