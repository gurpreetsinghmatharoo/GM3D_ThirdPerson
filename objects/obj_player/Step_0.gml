var _angle = obj_camera.angleFinal;

var _moveAngle = -(_angle + inputDir) - 90;
var _moveX = lengthdir_x(inputLenFinal*moveSpeed, _moveAngle);
var _moveY = lengthdir_y(inputLenFinal*moveSpeed, _moveAngle);

x += _moveX;
y += _moveY;

if (abs(_moveX) + abs(_moveY) > 0.02)
{
    playAnim("walk")
    faceAngle += angle_difference(_moveAngle, faceAngle) * 0.3;
}
else
{
    playAnim("idle")
}

alignNode(root, new GM3D_Vec3(lengthdir_x(1, faceAngle), 0, lengthdir_y(1, faceAngle)));
root.setLocalPosition(new GM3D_Vec3(x, 0, y));

//model.applyAnimation(model.getAnimation(0), DELTA_SECONDS);