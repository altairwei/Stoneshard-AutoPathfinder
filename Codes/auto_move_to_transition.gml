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
        // Convert map markers coordinates to room coordinates
        var _local_x = (_gridX - global.playerGridX + _offsetX / 52) * room_width
        var _local_y = (_gridY - global.playerGridY + _offsetY / 52) * room_height

        var m = (_local_y - o_player.y) / (_local_x - o_player.x)
        var b = o_player.y - m * o_player.x

        var points = []
        var x_top = (13 - b) / m
        if (x_top >= 13 && x_top <= (room_width - 13)) {
            array_push(points, [x_top, 13])
        }

        var x_bottom = (room_height - 13 - b) / m
        if (x_bottom >= 13 && x_bottom <= (room_width - 13)) {
            array_push(points, [x_bottom, room_height - 13])
        }

        var y_left = m * 13 + b
        if (y_left >= 13 && y_left <= (room_height - 13)) {
            array_push(points, [13, y_left])
        }

        var y_right = m * (room_width - 13) + b
        if (y_right >= 13 && y_right <= (room_height - 13)) {
            array_push(points, [room_width - 13, y_right])
        }

        var min_dist = -1
        var closest_point = undefined

        for (var i = 0; i < array_length(points); i++) {
            var pt = points[i];
            var dist = point_distance(pt[0], pt[1], _local_x, _local_y)
            if (min_dist == -1 || dist < min_dist) {
                min_dist = dist
                closest_point = pt
            }
        }

        if (is_undefined(closest_point))
            return

        var _closest_gridX = closest_point[0] div 26
        var _closest_gridY = closest_point[1] div 26

        scr_actionsLogUpdate("Found_closest_point:(" + string(_closest_gridX) + "," + string(_closest_gridY) + ")")

        // Activate certain o_tile_transition instances
        instance_activate_region((_closest_gridX - 2) * 26, (_closest_gridY - 2) * 26, (_closest_gridX + 2) * 26, (_closest_gridY + 2) * 26, true)

        var _door = noone
        with (o_tile_transition)
        {
            //scr_actionsLogUpdate("Active_tile:(" + string(grid_x) + "," + string(grid_y) + ")")
            if (grid_x == _closest_gridX && grid_y == _closest_gridY)
                _door = id
        }

        if (_door != noone)
        {
            with (o_floor_target)
            {
                i_id = _door
                path = scr_get_path_mp(i_id)
                event_perform(ev_mouse, ev_global_left_press)
            }
        }
    }
}