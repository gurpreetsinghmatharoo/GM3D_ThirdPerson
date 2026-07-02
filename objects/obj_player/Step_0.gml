var _angle = obj_camera.angleFinal;

var _moveAngle = -(_angle + inputDir) - 90;
var _moveX = lengthdir_x(inputLenFinal*moveSpeed, _moveAngle);
var _moveY = lengthdir_y(inputLenFinal*moveSpeed, _moveAngle);

x += _moveX;
y += _moveY;

alignNode(root, new GM3D_Vec3(lengthdir_x(1, _moveAngle), 0, lengthdir_y(1, _moveAngle)));
root.setLocalPosition(new GM3D_Vec3(x, 0, y));