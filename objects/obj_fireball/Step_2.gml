root.setLocalPosition(new Vec3(x, z, y));

if (instance_exists(obj_player) && distance_to_object(obj_player) > 100)
{
    instance_destroy();
}