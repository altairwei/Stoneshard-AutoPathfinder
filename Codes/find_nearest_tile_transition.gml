function find_nearest_tile_transition()
{
    var _point_x = argument0
    var _point_y = argument1

    var _tile_transition = noone
    var _min_distance = -1

    instance_activate_object(o_tile_transition)

    with (o_tile_transition)
    {
        var _dist = point_distance(_point_x, _point_y, x, y)
        if (_min_distance == -1 || _dist < _min_distance) {
            _min_distance = _dist
            _tile_transition = id
        }
    }

    if (_min_distance > max(room_height, room_width) / 4)
        _tile_transition = noone

    // Deactivate instances that were previously inactive
    with (o_cullingController)
    {
        var list_size = ds_list_size(deactivatedInstancesList)
        for (var i = 0; i < list_size; i++) {
            var inst = ds_list_find_value(deactivatedInstancesList, i)
            if (instance_exists(inst) && inst.object_index == o_tile_transition && inst != _tile_transition)
                instance_deactivate_object(inst)
        }
    }

    return _tile_transition
}
