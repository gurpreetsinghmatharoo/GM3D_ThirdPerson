var _targetting = obj_player.targetting;
var _posX, _posZ;
var _lookDistance = lookDistance;

// If not targetting, look at player
if (_targetting == undefined) {
    _posX = obj_player.x - lengthdir_x(playerLookAhead, -angleFinal);
    _posZ = obj_player.y - lengthdir_y(playerLookAhead, -angleFinal);
}
// Targetting, look at point halfway between player and targetted instance
else {
    _posX = (obj_player.x+_targetting.x)/2;
    _posZ = (obj_player.y+_targetting.y)/2;
    
    // Adjust distance, angle and height (locked)
    _lookDistance = max(7, point_distance(obj_player.x, obj_player.y, _targetting.x, _targetting.y)*0.64);
    angle = (-point_direction(obj_player.x, obj_player.y, _targetting.x, _targetting.y)) - 186;
    angleFinal += angle_difference(angle, angleFinal) * 0.1;
    
    height = 1.2;
    heightFinal = lerp(heightFinal, height, 0.1);
}

lookDistanceFinal = lerp(lookDistanceFinal, _lookDistance, 0.1);

// Lerp pointing position
posX = lerp(posX, _posX, 0.2);
posZ = lerp(posZ, _posZ, 0.2);

// Orbit camera around that position (custom function)
orbitCamera(cameraNode, new GM3D_Vec3(posX, 0, posZ), lookDistanceFinal, heightFinal, -angleFinal);

// Mouse lock
if (keyboard_check_pressed(vk_escape))
{
    window_mouse_set_locked(!window_mouse_get_locked());
}