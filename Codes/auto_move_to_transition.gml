function auto_move_to_transition()
{
    // Check if the player is in destination grid.

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