// Copyright (C)
// See LICENSE file for extended copyright information.
// This file is part of the repository from .

using System;
using System.IO;

using ModShardLauncher;
using ModShardLauncher.Mods;

namespace AutoPathfinder;
public class AutoPathfinder : Mod
{
    public override string Author => "Altair Wei";
    public override string Name => "Auto Pathfinder";
    public override string Description => "Allows to have the player automatically travel to a quest destination or a location marked on the map.";
    public override string Version => "1.0.0.0";
    public override string TargetVersion => "0.8.2.10";

    public override void PatchMod()
    {
        Msl.AddFunction(ModFiles.GetCode("scr_move_player_to.gml"), "gml_GlobalScript_scr_move_player_to");
        Msl.AddFunction(ModFiles.GetCode("auto_move_to_transition.gml"), "auto_move_to_transition");

        Msl.LoadGML("gml_Object_o_player_KeyPress_114") // F3
            .MatchAll()
            .InsertBelow(ModFiles, "execute_pathfinder.gml")
            .Save();

        // DELETE ME!
        Msl.LoadGML("gml_Object_o_floor_target_Mouse_53")
            .MatchFrom("                            scr_player_move(path_get_x(path, 1), path_get_y(path, 1))")
            .ReplaceBy(@"                        {
                            scr_player_move(path_get_x(path, 1), path_get_y(path, 1))
                            scr_actionsLogUpdate(""Target:\u00A0"" + object_get_name(target_id.object_index))
                        }")
            .Save();

        Msl.LoadGML("gml_GlobalScript_scr_stop_player")
            .MatchFrom("                next_step = 1")
            .InsertBelow("                global.pathfinder_dest = noone")
            .Save();

        // Trigger Alarm 2 when o_player was created in a new room
        Msl.LoadGML("gml_Object_o_player_Create_0")
            .MatchAll()
            .InsertBelow("alarm[2] = 30") // After 30 steps
            .Save();
        Msl.LoadGML("gml_Object_o_player_Alarm_2")
            .MatchAll()
            .InsertBelow(ModFiles, "transition_handler.gml")
            .Save();

        Localization.ActionLogsPatching();
    }

    private static void ExportTable(string table)
    {
        DirectoryInfo dir = new("ModSources/AutoPathfinder/tmp");
        if (!dir.Exists) dir.Create();
        List<string>? lines = ModLoader.GetTable(table);
        if (lines != null)
        {
            File.WriteAllLines(
                Path.Join(dir.FullName, Path.DirectorySeparatorChar.ToString(), table + ".tsv"),
                lines.Select(x => string.Join('\t', x.Split(';')))
            );
        }
    }
}
