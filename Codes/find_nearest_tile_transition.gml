function find_nearest_tile_transition()
{
    var _point_x = argument0
    var _point_y = argument1

    // Array to store instances and their distances
    var instances_with_distance = []

    // Activate all o_tile_transition instances
    instance_activate_object(o_tile_transition)

    // Iterate over all o_tile_transition instances and calculate the distance
    with (o_tile_transition)
    {
        var _dist = point_distance(_point_x, _point_y, x, y)
        array_push(instances_with_distance, [id, _dist])
    }

    // Implement bubble sort to sort the array manually by distance
    var n = array_length(instances_with_distance)
    var temp

    for (var i = 0; i < n - 1; i++) {
        for (var j = 0; j < n - 1 - i; j++) {
            if (instances_with_distance[j][1] > instances_with_distance[j + 1][1]) {
                // Swap the two elements
                temp = instances_with_distance[j]
                instances_with_distance[j] = instances_with_distance[j + 1]
                instances_with_distance[j + 1] = temp
            }
        }
    }

    // Extract the sorted instance IDs
    var sorted_instance_ids = []

    for (var i = 0; i < array_length(instances_with_distance); i++) {
        array_push(sorted_instance_ids, instances_with_distance[i][0])
    }

    // Deactivate instances that were previously inactive
    redeactivate_instances(o_tile_transition)

    // Return the sorted instance ID list
    return sorted_instance_ids
}
