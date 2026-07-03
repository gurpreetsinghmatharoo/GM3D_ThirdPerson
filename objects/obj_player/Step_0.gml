stateTime += DELTA_SECONDS;

if (state==STATE.NORMAL) // Idle/walk
{
    var _angle = obj_camera.angleFinal;

    var _moveAngle = -(_angle + inputDir) - 90;
    var _run = keyboard_check(vk_shift);
    var _speed = moveSpeed * (1+_run*0.4);
    var _moveX = lengthdir_x(inputLenFinal*_speed, _moveAngle);
    var _moveY = lengthdir_y(inputLenFinal*_speed, _moveAngle);
    var _moving = abs(_moveX) + abs(_moveY) > 0.05;
    
    x += _moveX;
    y += _moveY;
    
    if (abs(_moveX) + abs(_moveY) > 0.02)
    {
        playAnim(_run ? "sprint" : "walk")
        faceAngle += angle_difference(_moveAngle, faceAngle) * 0.3;
    }
    else
    {
        playAnim("idle")
    }
    
    alignNode(root, new GM3D_Vec3(lengthdir_x(1, faceAngle), 0, lengthdir_y(1, faceAngle)));
    
    if (keyboard_check_pressed(vk_space))
    {
        setState(STATE.ROLL, "Pick-up");
        dashDir = faceAngle;
    }
}
else if (state==STATE.ROLL) // Roll
{
    var _angle = obj_camera.angleFinal;
    var _time = stateTime/dashTime;
    var _peak = (0.5 - abs(_time-0.5))*2;
    var _speed = dashSpeed * (_peak*_peak);
    show_debug_message(_speed)

    //var _moveAngle = -(_angle + dashDir) - 90;
    var _moveX = lengthdir_x(_speed, dashDir);
    var _moveY = lengthdir_y(_speed, dashDir);
    
    x += _moveX;
    y += _moveY;
    
    alignNode(root, new GM3D_Vec3(lengthdir_x(1, faceAngle), -5 * _peak, lengthdir_y(1, faceAngle)));
    z = (1-_time)*(_peak*_peak) * 0.4;
    
    if (stateTime>dashTime)
    {
        setState(STATE.NORMAL);
        z = 0;
    }
}

root.setLocalPosition(new GM3D_Vec3(x, z, y));

//model.applyAnimation(model.getAnimation(0), DELTA_SECONDS);