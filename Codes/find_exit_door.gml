function find_exit_door()
{
    var _doors = []
    var _types = [
        o_Doors_all_big, o_Doors_all_small, o_villageDoorsExit,
        o_villageDoorsEnter, o_Doors_all_small_exit, o_Doors_all_big_exit,
        o_stairs_up, o_SpikeTavern2floor_stairsdown]

    for (var i = 0; i < array_length(_types); i++)
        instance_activate_object(_types[i])

    switch (room_get_name(room)) {
        case "r_villagehall01inside":
            with (o_Doors_all_small_exit)
            {
                if (position_tag == "r_Osbrookvillagehall")
                    _doors = [id]
            }
            break

        case "r_tavernmannshireinside1floor":
            with (o_Doors_all_small_exit)
                _doors = [id]
            break

        case "r_tavernmannshireinside2floor":
            with (o_mannshireavern4floorladderup)
                _doors = [id]
            break

        case "r_tavern_GoldenSpikeInn1floor":
            with (o_Doors_all_small)
                _doors = [id]
            break

        case "r_tavern_GoldenSpikeInn2floor":
            with (o_SpikeTavern2floor_stairsdown)
                _doors = [id]
            break

        case "r_tavernWillow1floor":
            with (o_Doors_all_small_exit)
            {
                if (position_tag == "Roadtavern02_01")
                    _doors = [id]
            }
            break

        case "r_BrynnCathedral1floor":
            with (o_Doors_all_big_exit)
                _doors = [id]
            break

        case "r_Brynn_NW":
        case "r_Brynn_NE":
        case "r_Brynn_SW":
        case "r_Brynn_SE":
            break

        default:
            // Find a out door in a house or a dungeon
            // Some doors are sub-class of o_villageDoorsEnter instead of o_villageDoorsExit
            // Some stairs are o_Doors_all_small_exit.
            // o_willowtavern02stairs is a down stair and is sub-class of o_villageDoorsEnter
            var door_types = [o_Doors_all_big, o_Doors_all_small, o_villageDoorsExit, o_villageDoorsEnter]
            for (var i = 0; i < array_length(door_types); i++) {
                var _object_type = door_types[i]

                var _min_distance = -1
                with (_object_type) {
                    var _dist = point_distance(o_player.x, o_player.y, x, y)
                    if (_min_distance == -1 || _dist < _min_distance) {
                        _min_distance = _dist
                        _doors = [id]
                    }
                }

                if (array_length(_doors) != 0) {
                    break
                }
            }
            break
    }

    // Find a out door in a dungeon
    if (array_length(_doors) == 0)
    {
        with (o_stairs_up)
            _doors = [id]
    }

    with (o_cullingController)
    {
        var list_size = ds_list_size(deactivatedInstancesList)
        for (var i = 0; i < list_size; i++) {
            var inst = ds_list_find_value(deactivatedInstancesList, i)
            if (instance_exists(inst))
                instance_deactivate_object(inst)
        }
    }

    return _doors
}
