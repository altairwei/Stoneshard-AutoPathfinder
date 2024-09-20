function auto_move_to_transition()
{
    // Convert coordinates of the map marker
    var _x = argument0
    var _y = argument1

    // Map grid coordinates
    var _gridX = _x div 52
    var _gridY = _y div 52

    // Offset on the target map grid
    var _offsetX = _x - _gridX * 52
    var _offsetY = _y - _gridY * 52

    // Check if the player is in destination grid.
    if (global.playerGridX == _gridX && global.playerGridY == _gridY)
    {
        // Follow the relative positions marked on the map to the corresponding point in the current room
        scr_move_player_to(_offsetX / 52 * room_width, _offsetY / 52 * room_height)
        stop_auto_move()
    }
    else
    {
        // Convert map markers coordinates to room coordinates
        var _local_x = (_gridX - global.playerGridX + _offsetX / 52) * room_width
        var _local_y = (_gridY - global.playerGridY + _offsetY / 52) * room_height

        // Find nearest map door
        var closest_point = calculate_closest_point(_local_x, _local_y)

        if (is_undefined(closest_point))
            return

        var _closest_gridX = closest_point[0] div 26
        var _closest_gridY = closest_point[1] div 26

        // Search for o_tile_transition
        var _door_array = find_nearest_tile_transition(closest_point[0], closest_point[1])

        if (array_length(_door_array) == 0)
            _door_array = find_exit_door()

        if (array_length(_door_array) != 0)
        {
            var _path = noone
            var _door = noone
            for (var i = 0; i < array_length(_door_array); i++)
            {
                var _door_check = _door_array[i]

                // Active instance first, then we can calculate the path to it
                var _is_inactive = false
                with (o_cullingController)
                    _is_inactive = ds_list_find_index(deactivatedInstancesList, _door_check) != -1

                instance_activate_object(_door_check)

                // Check if the door is accessible
                var _path_check = scr_get_path_mp(_door_check)
                if (_path_check > Path20)
                {
                    _path = _path_check
                    _door = _door_check
                    break
                }
                else
                {
                    // Deactivate the instance that is inaccessible
                    if (_is_inactive)
                    {
                        instance_deactivate_object(_door_check)
                    }
                }
            }

            if (_path != noone && _door != noone)
                scr_move_player_to(_door.x, _door.y, _door, _path)
            else
                scr_actionsLog("doorInaccessible", [scr_id_get_name(o_player)])
        }
        else
        {
            scr_actionsLog("doorNotExist", [scr_id_get_name(o_player)])
        }
    }
}