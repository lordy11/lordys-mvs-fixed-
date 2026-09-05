class CfgPatches
{
    class FreezesMVSArmor
    {
        units[]={};
        weapons[]={};
        requiredVersion=0.1;
        requiredAddons[]={"DZ_Data","DZ_Scripts","ModularVestSystem"};
    };
};

class CfgMods
{
    class FreezesMVSArmor
    {
        dir="FreezesMVSArmor";
        name="Freezes MVS JSON Armour";
        author="lordy11";
        type="mod";
        dependencies[]={"Game","World","Mission"};
        class defs
        {
            class gameScriptModule
            {
                value="";
                files[]={"FreezesMVSArmor/Scripts/3_Game"};
            };
            class worldScriptModule
            {
                value="";
                files[]={"FreezesMVSArmor/Scripts/4_World"};
            };
            class missionScriptModule
            {
                value="";
                files[]={"FreezesMVSArmor/Scripts/5_Mission"};
            };
        };
    };
};
