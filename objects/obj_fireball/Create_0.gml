z = 0.4;

spd = 0.3;

root = obj_scene.model_fireball.spawnInto(obj_scene.scene, undefined);

init = true;

var s = 0.1;
root.setLocalScale(new Vec3(s, s, s))
root.setLocalPosition(new Vec3(x, z, y));