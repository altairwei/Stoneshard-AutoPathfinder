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
        Msl.LoadGML("gml_Object_o_player_KeyPress_114") // F3
            .MatchAll()
            .InsertBelow(ModFiles, "execute_pathfinder.gml")
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
