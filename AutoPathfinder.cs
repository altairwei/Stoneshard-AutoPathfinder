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
    public override string Author => "Altair Wei & Pong";
    public override string Name => "Auto Pathfinder";
    public override string Description => "Allows to have the player automatically travel to a quest destination or a location marked on the map.";
    public override string Version => "v1.1.2";
    public override string TargetVersion => "0.8.2.10";

    public override void PatchMod()
    {
        Msl.AddFunction(ModFiles.GetCode("redeactivate_instances.gml"), "redeactivate_instances");
        Msl.AddFunction(ModFiles.GetCode("stop_auto_move.gml"), "stop_auto_move");
        Msl.AddFunction(ModFiles.GetCode("scr_move_player_to.gml"), "scr_move_player_to");
        Msl.AddFunction(ModFiles.GetCode("calculate_closest_point.gml"), "calculate_closest_point");
        Msl.AddFunction(ModFiles.GetCode("find_nearest_tile_transition.gml"), "find_nearest_tile_transition");
        Msl.AddFunction(ModFiles.GetCode("find_exit_door.gml"), "find_exit_door");
        Msl.AddFunction(ModFiles.GetCode("auto_move_to_transition.gml"), "auto_move_to_transition");

        Msl.AddMenu(
            "Auto Pathfinder",
            new UIComponent(
                name: "Map Marker", associatedGlobal: "map_mark_type", UIComponentType.ComboBox,
                new string[] {  "Flag", "Grave", "Sword", "Crown", "Bow", "Diamond",
                                "Arrow", "Food", "Tower", "Cross", "Chest", "Skull"}),
            new UIComponent(
                name: "If multiple marks exist, go to the nearest", associatedGlobal: "go_to_nearest_mark",
                UIComponentType.CheckBox, 0)
        );

        Msl.LoadGML("gml_Object_o_player_KeyPress_114") // F3
            .MatchAll()
            .InsertBelow(ModFiles, "execute_pathfinder.gml")
            .Save();

        // DELETE ME!
        // Msl.LoadGML("gml_Object_o_floor_target_Mouse_53")
        //     .MatchFrom("                            scr_player_move(path_get_x(path, 1), path_get_y(path, 1))")
        //     .ReplaceBy(@"                        {
        //                     scr_player_move(path_get_x(path, 1), path_get_y(path, 1))
        //                     scr_actionsLogUpdate(""Target:\u00A0~lg~"" + object_get_name(target_id.object_index) + ""~/~\u00A0in\u00A0~y~"" + room_get_name(room) + ""~/~"")
        //                 }")
        //     .Save();

        Msl.LoadGML("gml_Object_o_player_Create_0")
            .MatchAll()
            .InsertBelow("auto_move = true\ntile_transition = false")
            .Save();

        Msl.LoadGML("gml_Object_o_player_Other_17")
            .MatchAll()
            .InsertAbove("tile_transition = true")
            .MatchAll()
            .InsertBelow("tile_transition = false")
            .Save();

        Msl.LoadGML("gml_GlobalScript_scr_stop_player")
            .MatchFrom("                path = -1")
            .InsertBelow(@"
            if (!tile_transition)
                stop_auto_move()")
            .Save();

        Msl.LoadAssemblyAsString("gml_Object_o_player_Step_0")
             .Apply(InsertCode)
             .Save();

        Msl.LoadGML("gml_Object_o_globalmapMarkUserContext_Other_25")
            .MatchFrom("var _mark = scr_globalmapMarkCreate")
            .InsertAbove(@"
            var _mark_type = ""Flag""
            if (variable_global_exists(""map_mark_type"") && is_string(global.map_mark_type) && global.map_mark_type != ""0"")
                _mark_type = global.map_mark_type
            var _target_sprite = asset_get_index(""s_glmap_mark_user_"" + _mark_type)
            if (!global.go_to_nearest_mark && other.markSpriteIndex == _target_sprite)
            {
                with (o_globalmapMarkUser)
                {
                    if (sprite_index == _target_sprite)
                        instance_destroy()
                }
            }")
            .Save();

        //InsertStopAutoMove();

        Localization.ActionLogsPatching();
    }

    private static IEnumerable<string> InsertCode(IEnumerable<string> input)
    {
        foreach (string item in input)
        {
            
            if (item.Contains(":[end]"))
            {
                
                yield return @"
call.i gml_Script_scr_is_cutscene(argc=0)
conv.v.b
not.b
bf [1016]

:[1012]
call.i gml_Script_is_allow_actions(argc=0)
conv.v.b
bf [1016]

:[1013]
push.v self.auto_move
conv.v.b
bf [1016]

:[1014]
push.s ""pathfinder_dest""
conv.s.v
call.i variable_global_exists(argc=1)
conv.v.b
bf [1016]

:[1015]
pushglb.v global.pathfinder_dest
pushi.e -4
cmp.i.v NEQ
b [1017]

:[1016]
push.e 0

:[1017]
bf [end]

:[1018]
pushi.e 0
pop.v.b self.auto_move
pushi.e -5
pushi.e 1
push.v [array]global.pathfinder_dest
pushi.e -5
pushi.e 0
push.v [array]global.pathfinder_dest
call.i gml_Script_auto_move_to_transition(argc=2)
popz.v
";
            }

            
            yield return item;
        }
    }


    private static void InsertStopAutoMove()
    {
        List<(string, string, string)> tupleList = new List<(string, string, string)>
        {
            ("gml_GlobalScript_scr_invisible_teleport", "    scr_stop_player()", "    stop_auto_move()"),
            ("gml_GlobalScript_scr_penalty_enemy_attack", "                                            scr_stop_player()", "                                            stop_auto_move()"),
            ("gml_GlobalScript_scr_simple_damage", "            scr_stop_player()", "            stop_auto_move()"),
            ("gml_GlobalScript_scr_stateAttack", "                scr_stop_player()", "                stop_auto_move()"),
            ("gml_Object_o_ambush_trigger_Step_0", "            scr_stop_player(1)", "            stop_auto_move()"),
            ("gml_Object_o_Attitude_Other_12", "scr_stop_player()", "stop_auto_move()"),
            ("gml_Object_o_close_panel_Create_0", "scr_stop_player()", "stop_auto_move()"),
            ("gml_Object_o_container_parent_Create_0", "scr_stop_player()", "stop_auto_move()"),
            // NOTE: cause a BUG?
            ("gml_Object_o_contract_dialog_Create_0", "scr_stop_player()", "stop_auto_move()"),
            ("gml_Object_o_cutscene_start_trigger_Other_10", "            scr_stop_player(1)", "            stop_auto_move()"),
            ("gml_Object_o_cutscene_teleporter_Alarm_0", "        scr_stop_player()", "        stop_auto_move()"),
            ("gml_Object_o_db_nause_Other_10", "    scr_stop_player()", "    stop_auto_move()"),
            ("gml_Object_o_delayed_move_grid_cutscene_Destroy_0", "    scr_stop_player()", "    stop_auto_move()"),
            ("gml_Object_o_enemy_Other_11", "        scr_stop_player()", "        stop_auto_move()"),
            ("gml_Object_o_environmentPhraseTrigger_Other_10", "scr_stop_player()", "stop_auto_move()"),
            ("gml_Object_o_exploreMenu_Create_0", "scr_stop_player()", "stop_auto_move()"),
            ("gml_Object_o_floor_target_Mouse_53", "            scr_stop_player()", "            stop_auto_move()"),
            ("gml_Object_o_globalmap_Create_0", "scr_stop_player()", "stop_auto_move()"),
            ("gml_Object_o_inv_consum_medicine_tab_Other_24", "scr_stop_player()", "stop_auto_move()"),
            ("gml_Object_o_inv_switch_Other_10", "                    scr_stop_player()", "                    stop_auto_move()"),
            ("gml_Object_o_journal_Other_11", "scr_stop_player()", "stop_auto_move()"),
            ("gml_Object_o_open_map_Create_0", "scr_stop_player()", "stop_auto_move()"),
            // NOTE: o_player_Other_17 will stop auto moving when enter a new map.
            //("gml_Object_o_player_Other_17", "                scr_stop_player()", "                stop_auto_move()"),
            // NOTE: relate to keyborad movement?
            //("gml_Object_o_player_Step_0", "            scr_stop_player(true)", "            stop_auto_move()"),
            ("gml_Object_o_skill_Other_12", "scr_stop_player()", "stop_auto_move()"),
            ("gml_Object_o_skill_stone_armor_Other_13", "scr_stop_player()", "stop_auto_move()"),
            ("gml_Object_o_skill_trap_search_Other_13", "        scr_stop_player()", "        stop_auto_move()"),
            ("gml_Object_o_teleport_Alarm_0", "        scr_stop_player()", "        stop_auto_move()"),
            ("gml_Object_o_vampire_guard_Other_17", "    scr_stop_player()", "    stop_auto_move()")
        };

        foreach (var (script, matchline, insertion) in tupleList)
        {
            Msl.LoadGML(script)
                .MatchFrom(matchline)
                .InsertBelow(insertion)
                .Save();
        }

        Msl.LoadGML("gml_GlobalScript_scr_stateTheat")
            .MatchFrom("            scr_stop_player()")
            .ReplaceBy(@"        {
            scr_stop_player()
            stop_auto_move()
        }")
            .Save();

        Msl.LoadGML("gml_Object_o_floor_target_Mouse_54")
            .MatchFrom("            scr_stop_player()")
            .ReplaceBy(@"        {
            scr_stop_player()
            stop_auto_move()
        }")
            .Save();

        Msl.LoadGML("gml_Object_o_floor_target_Other_11")
            .MatchFrom("                                    scr_stop_player()")
            .ReplaceBy(@"                                {
                                    scr_stop_player()
                                    stop_auto_move()
                                }")
            .Save();

        Msl.LoadGML("gml_Object_o_loot_Mouse_7")
            .MatchFrom("                    scr_stop_player()")
            .ReplaceBy(@"                {
                    scr_stop_player()
                    stop_auto_move()
                }")
            .Save();

        Msl.LoadGML("gml_Object_o_poison_platetrap_Other_13")
            .MatchFrom("            scr_stop_player()")
            .ReplaceBy(@"        {
            scr_stop_player()
            stop_auto_move()
        }")
            .Save();
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
