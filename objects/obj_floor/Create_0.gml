// Instanced ground
model = loadScene("models/ground.glb");
//root = model.spawnInto(obj_scene.scene, undefined);

assignShaders(model, true);

var _spread = 20;
var _size = 53.5;
for (var _x = -_spread; _x < _spread; _x++)
{
    for (var _y = -_spread; _y < _spread; _y++)
    {
        var _root = model.spawnInto(obj_scene.scene, undefined);
        _root.setLocalPosition(new GM3D_Vec3(_x*_size, 0, _y*_size));
    }
}

// Sky
model1 = loadScene("models/sky.glb");
root1 = model1.spawnInto(obj_scene.scene, undefined);
root1.setLocalScale(new GM3D_Vec3(500, 500, 500))