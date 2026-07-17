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
    
    // Set animation
    if (abs(_moveX) + abs(_moveY) > 0.02)
    {
        playAnim(_run ? "sprint" : "walk")
        faceAngle += angle_difference(_moveAngle, faceAngle) * 0.3;
    }
    else
    {
        playAnim("idle")
    }
    
    // Rotate to face moving direction
    alignNode(root, new GM3D_Vec3(lengthdir_x(1, faceAngle), 0, lengthdir_y(1, faceAngle)));
    
    // Shoot
    if (inputShoot)
    {
        // If targetting, shoot toward target, otherwise shoot toward facing angle
        var _dir = targetting==undefined ? faceAngle : point_direction(x, y, targetting.x, targetting.y);
        instance_create_layer(x, y, layer, obj_fireball, {
            direction: _dir
        })
        setState(STATE.ATTACK, "attack-melee-right")
        anim.setSpeed(2.0)
    }
    
    // Roll
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
else if (state==STATE.ATTACK) // Fireball attack
{
    if (targetting!=undefined)
    {
        var _dir = point_direction(x, y, targetting.x, targetting.y);
        alignNode(root, new GM3D_Vec3(lengthdir_x(1, _dir), 0, lengthdir_y(1, _dir)));
    }
    
    if (stateTime > 0.2)
    {
        setState(STATE.NORMAL);
    }
}
else if (state==STATE.HURT) // Hurt
{
    var _moveX = lengthdir_x(moveSpeed/2, faceAngle-180);
    var _moveY = lengthdir_y(moveSpeed/2, faceAngle-180);
    
    x += _moveX;
    y += _moveY;
    
    if (stateTime > 0.66)
    {
        setState(STATE.NORMAL);
        hurtTime = 1;
    }
}

// Get hurt
if (state!=STATE.HURT && hurtTime <= 0)
{
    var _inst = instance_nearest(x, y, obj_target);
    if (instance_exists(_inst) && distance_to_object(_inst) < _inst.radius)
    {
        setState(STATE.HURT, "die");
        anim.setSpeed(0.5);
        var _dir = point_direction(x, y, _inst.x, _inst.y);
        faceAngle = _dir;
        alignNode(root, new GM3D_Vec3(lengthdir_x(1, _dir), 0, lengthdir_y(1, _dir)));
    }
}

if (hurtTime >= 0) hurtTime -= DELTA_SECONDS;

// Move player model (I know Y is up but I'm using the XY in room editor as XZ at runtime so it's swapped 😭)
root.setLocalPosition(new GM3D_Vec3(x, z, y));

// Move shadow
updateShadow(shadow);