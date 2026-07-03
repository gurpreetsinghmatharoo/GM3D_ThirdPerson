// Add light
lightNode = obj_scene.scene.createNode("light");
light = new GM3D_LightComponent();
lightNode.addComponent(light);

light.setType(GM3D_ELightType.Directional);
light.setColor(c_white);

alignNode(lightNode, new GM3D_Vec3(random_range(-1, 1), random_range(-1, 1), random_range(-1, 1)));

// Add environment
envNode = obj_scene.scene.createNode("env");
env = new GM3D_EnvironmentVolumeComponent();
envNode.addComponent(env);

env.setSize(20000, 20000, 20000);
env.setAmbientColor(c_gray);