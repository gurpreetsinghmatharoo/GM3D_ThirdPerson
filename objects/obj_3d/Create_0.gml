x = x;
y = y;
z = 0;

model = loadScene(model_path);
root = model.spawnInto(obj_scene.scene, undefined);
if (instanced) assignShaders(model, true);