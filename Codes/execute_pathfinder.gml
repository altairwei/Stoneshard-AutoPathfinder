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
            _closest_x = _x
            _closest_y = _y
        }
    }
}

if (!is_undefined(_closest_x) && !is_undefined(_closest_y))
{
    var _gridX = _closest_x div 52
    var _gridY = _closest_y div 52

    if (scr_globaltile_get("isOpen", _gridX, _gridY))
        scr_actionsLog("planTravelTo", [scr_id_get_name(o_player), scr_glmap_getTitle(_gridX, _gridY)])
    else
        scr_actionsLog("planTravelToUnknown", [scr_id_get_name(o_player), string(_gridX), string(_gridY)])

    global.pathfinder_dest = [_closest_x, _closest_y]
    auto_move_to_transition(_closest_x, _closest_y)
}
else
{
    var _diaryTask = ds_map_find_value(global.journalDataMap, "diaryTask")
    var _diaryQuest = ds_map_find_value(global.journalDataMap, "diaryQuest")
    var _diaryMap = noone
    if (_diaryTask != noone)
        _diaryMap = (_diaryQuest ? ds_map_find_value(global.questsDataMap, _diaryTask) : scr_contract_get_map(_diaryTask))

    if (_diaryMap == noone)
    {
        scr_actionsLog("whereToGo", [scr_id_get_name(o_player)])
        exit
    }

    var _targetCoordsArray = scr_journalTaskGetCoords(_diaryMap, _diaryQuest)

    if (_targetCoordsArray[0] == global.playerGridX && _targetCoordsArray[1] == global.playerGridY)
    {
        scr_actionsLog("whereToGo", [scr_id_get_name(o_player)])
        exit
    }

    var _target_x = _targetCoordsArray[0] * 52 + 26
    var _target_y = _targetCoordsArray[1] * 52 + 26

    if (scr_globaltile_get("isOpen", _targetCoordsArray[0], _targetCoordsArray[1]))
        scr_actionsLog("planTravelTo", [scr_id_get_name(o_player), scr_glmap_getTitle(_targetCoordsArray[0], _targetCoordsArray[1])])
    else
        scr_actionsLog("planTravelToUnknown", [scr_id_get_name(o_player), string(_targetCoordsArray[0]), string(_targetCoordsArray[1])])

    global.pathfinder_dest = [_target_x, _target_y]
    auto_move_to_transition(_target_x, _target_y)
}



