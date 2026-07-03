var _left = keyboard_check(ord("A"));
var _right = keyboard_check(ord("D"));
var _up = keyboard_check(ord("W"));
var _down = keyboard_check(ord("S"));
var _target = mouse_check_button(mb_right);
inputShoot = mouse_check_button_pressed(mb_left);

inputLen = _left || _right || _up || _down;
if (inputLen) inputDir = point_direction(0, 0, _left - _right, _down - _up);

inputLenFinal = lerp(inputLenFinal, inputLen, 0.15);

targetting = undefined;
if (_target)
{
    var _inst = instance_nearest(x, y, obj_target);
    if (instance_exists(_inst) && distance_to_object(_inst) < targetRange)
    {
        targetting = _inst;
    }
}