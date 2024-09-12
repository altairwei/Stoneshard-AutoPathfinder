function scr_move_player_to()
{
    var _targetX = argument0
    var _targetY = argument1
    var _target_id = noone
    var _path = noone

    if (!is_undefined(argument2))
    {
        _target_id = argument2
        _path = scr_get_path_mp(_target_id)
    }

    if global.skill_activate
        return;
    if scr_is_cutscene()
        return;
    if instance_exists(o_open_book)
        return;
    if (!is_allow_actions())
        return;

    var _is_rest = false
    with (o_Meditative_Attitude)
        _is_rest = is_activate
    scr_rest_disable(o_player)
    if _is_rest
        return;

    if (instance_exists(o_player) && (!o_floor_target.alarm[2]))
    {
        // Calculate grid coordinate
        var _targetGridX = _targetX div 26
        var _targetGridY = _targetY div 26

        o_floor_target.alarm[2] = 2

        with (o_player)
        {
            context_target_id = noone
            if path
            {
                scr_stop_player()
                return;
            }
        }

        var preditor = false
        var trap = collision_point(_targetX, _targetY, o_trap, 0, 0)
        if trap
        {
            if (trap.image_alpha > 0.5)
            {
                if (trap.image_speed > 0)
                    preditor = true
            }
        }
        if (!preditor)
        {
            if ((!instance_exists(o_container_parent)) && (!scr_unitTurnGetTime()))
            {
                if trap
                    trap = (trap.image_alpha > 0 && (!trap.is_disarm))
                if (_target_id == noone && !trap)
                {
                    var _freeCellCoordsArray = scr_mpgridFindNearestFreeCell(o_controller.grid, _targetGridX, _targetGridY)
                    if (_freeCellCoordsArray[0] != noone && _freeCellCoordsArray[1] != noone)
                        scr_player_move((_freeCellCoordsArray[0] * 26), (_freeCellCoordsArray[1] * 26))
                }
                else if instance_exists(_target_id)
                {
                    if (!scr_can_interract_posgrid(_target_id, _target_id.in_grid))
                    {
                        if (_path > Path20)
                        {
                            scr_actionsLogUpdate("Target:\u00A0" + object_get_name(_target_id.object_index))
                            // Move to the end point ot path
                            with (o_player)
                                context_target_id = _target_id
                            scr_player_move(path_get_x(_path, 1), path_get_y(_path, 1))
                        }
                    }
                }
            }
        }
    }

}