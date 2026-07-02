model = loadScene("gltf/character.glb");
//node = obj_scene.scene.createNode("player")
root = model.spawnInto(obj_scene.scene, undefined);
anim = findAnimComponent(root);
anim.setEnabled(true);
//mesh = root.getMeshComponent();
//show_debug_message($"anim {model.animationCount}")

currentAnim = ""
playAnim = function(_animName)
{
    var _newAnim = findAnimIndex(model, _animName);
    
    if (_newAnim == currentAnim) return;
    
    currentAnim = _newAnim;
    anim.setTime(0.0);
    anim.setSpeed(1);
    anim.play(currentAnim, true);
}
playAnim("idle")