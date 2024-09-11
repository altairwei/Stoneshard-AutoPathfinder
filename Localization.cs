
using ModShardLauncher;
using ModShardLauncher.Mods;

namespace AutoPathfinder;

public class Localization
{
    public static void ActionLogsPatching()
    {
        List<string> logList = new List<string>();
        string id = "planTravelTo";
        string text_en = @"~w~$~/~ plans to go to ~lg~$~/~.";
        string text_zh = @"~w~$~/~计划前往~lg~$~/~。";
        logList.Add($"{id};{text_en};{text_en};{text_zh};" + string.Concat(Enumerable.Repeat($"{text_en};", 9)));

        id = "planTravelToUnknown";
        text_en = @"~w~$~/~ plans to travel to an unknown area located at map coordinates ~lg~($, $)~/~.";
        text_zh = @"~w~$~/~计划前往一个位于地图坐标~lg~（$，$）~/~的未知区域。";
        logList.Add($"{id};{text_en};{text_en};{text_zh};" + string.Concat(Enumerable.Repeat($"{text_en};", 9)));

        id = "whereToGo";
        text_en = @"~w~$~/~ doesn't know where to go.";
        text_zh = @"~w~$~/~不知道要往哪去。";
        logList.Add($"{id};{text_en};{text_en};{text_zh};" + string.Concat(Enumerable.Repeat($"{text_en};", 9)));

        string logtextend = ";" + string.Concat(Enumerable.Repeat("text_end;", 12));

        List<string> log_table = ModLoader.GetTable("gml_GlobalScript_table_log_text");
        log_table.InsertRange(log_table.IndexOf(logtextend), logList);
        ModLoader.SetTable(log_table, "gml_GlobalScript_table_log_text");
    }
}