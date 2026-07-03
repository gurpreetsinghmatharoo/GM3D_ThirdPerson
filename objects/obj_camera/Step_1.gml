// Only if not targetting
if (!obj_player.targetting) {
    // Turn angle
    angle += window_mouse_get_delta_x() * 0.1;
    angleFinal += angle_difference(angle, angleFinal) * 0.1;
    
    // Change height
    height += window_mouse_get_delta_y() * 0.01;
    height = clamp(height, 0.1, 6);
    heightFinal = lerp(heightFinal, height, 0.1);
}
