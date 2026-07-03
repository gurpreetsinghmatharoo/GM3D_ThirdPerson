scene = GM3D_Scene.createEmpty();

renderer = new GM3D_Renderer();

assets = [];

model_fireball = loadScene("models/fireball.glb");
assignShaders(model_fireball, true);