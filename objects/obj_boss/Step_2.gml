// Walk state
if (state==0)
{
    speed = move_speed;
    var _dist = infinity;
    var _dir = random_direction;
    if (instance_exists(obj_player)) _dist = distance_to_object(obj_player); 
    if (_dist < 40) {
        _dir = point_direction(x, y, obj_player.x, obj_player.y);
    }
    else {
    	_dir = random_direction;
        if (random(100)<2) random_direction += random(90);
    }
    direction += angle_difference(_dir, direction) * 0.1;
}



// Rotate
root.setLocalPosition(new Vec3(x, 0, y));
alignNode(root, new Vec3(lengthdir_x(1, direction), 0, lengthdir_y(1, direction)));

