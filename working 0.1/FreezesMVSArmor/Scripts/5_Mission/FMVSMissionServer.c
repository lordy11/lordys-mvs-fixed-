modded class MissionServer
{
    override void OnInit()
    {
        super.OnInit();
        FMVSArmorManager.Load();
        GetGame().GetCallQueue(CALL_CATEGORY_SYSTEM).CallLater(FMVSArmorManager.Load, 60000, true);
    }
};
