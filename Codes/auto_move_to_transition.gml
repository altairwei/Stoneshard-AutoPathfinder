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
    }
    else
    {
        // Activate certain o_tile_transition instances
        instance_activate_region(room_width - 26, o_player.y - 26 * 5, room_width, o_player.y + 26 * 5, true)

        var _door = noone
        with (o_tile_transition)
        {
            if (grid_y == o_player.grid_y && grid_x >= o_player.grid_x)
                _door = id
        }

        if (_door != noone)
        {
            scr_actionsLogUpdate("Mimic_mouse_click")
            with (o_floor_target)
            {
                i_id = _door
                path = scr_get_path_mp(i_id)
                event_perform(ev_mouse, ev_global_left_press)
            }
        }
    }
}