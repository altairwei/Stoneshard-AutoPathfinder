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
        // 可能把人导入海里。
        var _door = find_nearest_tile_transition(closest_point[0], closest_point[1])

        if (_door == noone)
            _door = find_exit_door()

        if (_door != noone)
        {
            var _path = scr_get_path_mp(_door)
            if (_path > Path20)
                scr_move_player_to(_door.x, _door.y, _door, _path)
            else
                scr_actionsLog("doorInaccessible", [scr_id_get_name(o_player)])

            // with (o_floor_target)
            // {
            //     i_id = _door
            //     path = scr_get_path_mp(i_id)
            //     event_perform(ev_mouse, ev_global_left_press)
            // }
        }
        else
        {
            scr_actionsLog("doorNotExist", [scr_id_get_name(o_player)])
        }
    }
}