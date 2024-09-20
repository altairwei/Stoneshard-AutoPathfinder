function redeactivate_instances()
{
    var _object_idx = argument0

    // Deactivate instances that were previously inactive
    with (o_cullingController)
    {
        var list_size = ds_list_size(deactivatedInstancesList)
        for (var i = 0; i < list_size; i++) {
            var inst = ds_list_find_value(deactivatedInstancesList, i)
            if (instance_exists(inst) && inst.object_index == _object_idx)
                instance_deactivate_object(inst)
        }
    }
}