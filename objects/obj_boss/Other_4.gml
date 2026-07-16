model = loadScene("newpack/Models/GLB format/animal-giraffe.glb")
root = model.spawnInto(obj_scene.scene, undefined);
anim = root.getAnimationComponent();
anim.setEnabled(true);

root.setLocalScale(new Vec3(image_xscale, image_xscale, image_xscale))

currentAnim = "";
currentAnimName = "";
playAnim = function(_animName, _speed=1)
{
    if (currentAnimName == _animName) return;
    currentAnimName = _animName;
    
    var _newAnim = model.getAnimation(_animName);// findAnimIndex(model, _animName);
    
    currentAnim = _newAnim;
    anim.setTime(0.0);
    anim.setSpeed(_speed);
    anim.play(currentAnim, true);
}
playAnim("walk", 0.3);

shadow = loadShadow(3.3);