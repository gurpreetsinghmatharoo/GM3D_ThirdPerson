// Walk state
if (state==0)
{
    speed = move_speed;
    var _dist = infinity;
    var _dir = random_direction;
    if (instance_exists(obj_player)) _dist = distance_to_object(obj_player); 
    if (_dist < range) {
        _dir = point_direction(x, y, obj_player.x, obj_player.y) + dir_wiggle;
        dir_wiggle += random_range(-10, 10);
        dir_wiggle = clamp(dir_wiggle, -25, 25);
    }
    else {
    	_dir = random_direction;
        if (random(100)<2) random_direction += random(90);
    }
    direction += angle_difference(_dir, direction) * 0.02;
}



// Rotate
root.setLocalPosition(new Vec3(x, 0, y));
alignNode(root, new Vec3(lengthdir_x(1, direction), 0, lengthdir_y(1, direction)));


// Shadow
updateShadow(shadow);