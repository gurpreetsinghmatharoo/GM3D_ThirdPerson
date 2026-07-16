model = loadScene("gltf/character.glb");
root = model.spawnInto(obj_scene.scene, undefined);

// Enable animation component
anim = root.getAnimationComponent();
anim.setEnabled(true);

// Animation changing function
currentAnim = "";
currentAnimName = "";
playAnim = function(_animName)
{
    if (currentAnimName == _animName) return;
    currentAnimName = _animName;
    
    var _newAnim = model.getAnimation(_animName); //findAnimIndex(model, _animName);
    
    currentAnim = _newAnim;
    anim.setTime(0.0);
    anim.setSpeed(1);
    anim.play(currentAnim, true);
}
playAnim("idle")

// Create shadow
shadow = loadShadow(0.2);