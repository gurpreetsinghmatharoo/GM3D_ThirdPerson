var _posX = obj_player.x - lengthdir_x(playerLookAhead, -angleFinal);
var _posZ = obj_player.y - lengthdir_y(playerLookAhead, -angleFinal);

orbitCamera(cameraNode, new GM3D_Vec3(_posX, 0, _posZ), lookDistance, heightFinal, -angleFinal);

if (keyboard_check_pressed(vk_escape))
{
    window_mouse_set_locked(!window_mouse_get_locked());
}