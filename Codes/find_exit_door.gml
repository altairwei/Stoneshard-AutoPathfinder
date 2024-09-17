function find_exit_door()
{
    var _door = noone

    switch (room_get_name(room)) {
        case "r_tavern_GoldenSpikeInn1floor":
            _door = instance_find(o_Doors_all_small, 0)
            break

        case "r_tavern_GoldenSpikeInn2floor":
            _door = instance_find(o_SpikeTavern2floor_stairsdown, 0)
            break

        case "r_tavernWillow1floor":
            with (o_Doors_all_small_exit)
            {
                if (position_tag == "Roadtavern02_01")
                    _door = id
            }
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
                        _door = id
                    }
                }

                if (_door != noone) {
                    break
                }
            }
            break
    }

    // Find a out door in a dungeon
    if (_door == noone)
    {
        with (o_stairs_up)
            _door = id
    }

    return _door
}