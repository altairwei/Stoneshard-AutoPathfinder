var _closest_x = undefined
var _closest_y = undefined
var _min_distance = -1

var _userMarksListSize = ds_list_size(global.globalmapUserMarksList)
for (_i = 0; _i < _userMarksListSize; _i += 4)
{
    _mark = asset_get_index(ds_list_find_value(global.globalmapUserMarksList, _i))
    var _index = ds_list_find_value(global.globalmapUserMarksList, (_i + 1))
    var _x = ds_list_find_value(global.globalmapUserMarksList, (_i + 2))
    var _y = ds_list_find_value(global.globalmapUserMarksList, (_i + 3))
    var _gridX = _x div 52
    var _gridY = _y div 52
    var _offsetX = _x - _gridX * 52
    var _offsetY = _y - _gridY * 52

    if (_mark == s_glmap_mark_user_Flag)
    {
        // Calculate distance
        var _distance = point_distance(_gridX, _gridY, global.playerGridX, global.playerGridY);

        // Find the closest mark
        if (_min_distance == -1 || _distance < _min_distance) {
            _min_distance = _distance
            _closest_x = _gridX
            _closest_y = _gridY
        }
    }
}

if (!is_undefined(_closest_x) && !is_undefined(_closest_y))
{
    if (scr_globaltile_get("isOpen", _closest_x, _closest_y))
        scr_actionsLog("planTravelTo", [scr_id_get_name(o_player), scr_glmap_getTitle(_closest_x, _closest_y)])
    else
        scr_actionsLog("planTravelToUnknown", [scr_id_get_name(o_player), string(_closest_x), string(_closest_y)])

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
        with (o_floor_target)
        {
            i_id = _door
            path = scr_get_path_mp(i_id)
            event_perform(ev_mouse, ev_global_left_press)
        }
    }
}
else
{
    scr_actionsLog("whereToGo", [scr_id_get_name(o_player)])
}



