//light = createDirLight(obj_scene.scene, "light", new GM3D_Vec3(0.5, 0.5, 0.5), c_white);

//env = createEnvVolume(obj_scene.scene, "env", new GM3D_Vec3(20000, 20000, 20000), c_blue);

lightNode = obj_scene.scene.createNode("light");
light = new GM3D_LightComponent();
lightNode.addComponent(light);

light.setType(GM3D_ELightType.Directional);
light.setColor(c_white);

alignNode(lightNode, new GM3D_Vec3(random_range(-1, 1), random_range(-1, 1), random_range(-1, 1)));

envNode = obj_scene.scene.createNode("env");
env = new GM3D_EnvironmentVolumeComponent();
envNode.addComponent(env);

env.setSize(20000, 20000, 20000);
env.setAmbientColor(c_gray);