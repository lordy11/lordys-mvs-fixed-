class FMVSInventorySizeManager
{
    static const string DIRECTORY = "$profile:FreezesMVS";
    static const string FILE_PATH = "$profile:FreezesMVS/InventorySizes.json";

    static void EnsureFile()
    {
        if (!GetGame() || !GetGame().IsServer())
            return;

        MakeDirectory(DIRECTORY);
        if (FileExist(FILE_PATH))
            return;

        FMVSInventorySizeSettings settings = new FMVSInventorySizeSettings();
        string errorMessage;
        if (!JsonFileLoader<FMVSInventorySizeSettings>.SaveFile(FILE_PATH, settings, errorMessage))
            ErrorEx("[FreezesMVSArmor] Could not create inventory settings: " + errorMessage);
        else
            Print("[FreezesMVSArmor] Created " + FILE_PATH);
    }
};
