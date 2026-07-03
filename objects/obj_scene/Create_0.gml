scene = GM3D_Scene.createEmpty();

renderer = new GM3D_Renderer();

assets = []; // Needed for loadScene()

model_fireball = loadScene("models/fireball.glb");
assignShaders(model_fireball, true); // This means the fireball will use the instanced shader now