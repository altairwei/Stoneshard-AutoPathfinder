if (variable_global_exists("pathfinder_dest") && global.pathfinder_dest != noone)
{
    scr_actionsLogUpdate("transition_handler")
    auto_move_to_transition(global.pathfinder_dest[0], global.pathfinder_dest[1])
}