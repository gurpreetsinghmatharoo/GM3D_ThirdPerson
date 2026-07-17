event_inherited();

direction = 0;
image_xscale = 5;

move_speed = 0.05;
state = 0;
random_direction = 0;
dir_wiggle = 0;
range = 40;

shadow = undefined;

// Model
anim = root.getAnimationComponent();
anim.setEnabled(true);

setScale = function()
{
    root.setLocalScale(new Vec3(image_xscale, image_xscale, image_xscale))
}

currentAnim = "";
currentAnimName = "";
playAnim = function(_animName, _speed=1)
{
    if (currentAnimName == _animName) return;
    currentAnimName = _animName;
    
    var _newAnim = model.getAnimation(_animName);
    
    currentAnim = _newAnim;
    anim.setTime(0.0);
    anim.setSpeed(_speed);
    anim.play(currentAnim, true);
}
playAnim("walk", 0.3);