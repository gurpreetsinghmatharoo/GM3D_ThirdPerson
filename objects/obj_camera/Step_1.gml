angle += window_mouse_get_delta_x() * 0.1;
height += window_mouse_get_delta_y() * 0.01;
height = clamp(height, 0.1, 6);

angleFinal += angle_difference(angle, angleFinal) * 0.1;
heightFinal = lerp(heightFinal, height, 0.1);