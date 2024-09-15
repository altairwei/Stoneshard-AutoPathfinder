function calculate_closest_tile_transition()
{
    var _target_x = argument0
    var _target_y = argument1

    var m = (_target_y - o_player.y) / (_target_x - o_player.x)
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
        var dist = point_distance(pt[0], pt[1], _target_x, _target_y)
        if (min_dist == -1 || dist < min_dist) {
            min_dist = dist
            closest_point = pt
        }
    }

    return closest_point
}
