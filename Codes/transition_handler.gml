if (is_allow_actions() && auto_move && variable_global_exists("pathfinder_dest") && global.pathfinder_dest != noone)
{
    auto_move = false
    auto_move_to_transition(global.pathfinder_dest[0], global.pathfinder_dest[1])
}