angle = 90;             // Target angle
angleFinal = 0;         // Current angle (lerped)
height = 2.5;           // Target height
heightFinal = 0;        // Current height (lerped)
playerLookAhead = 2;    // How much farther from the player should the camera point
lookDistance = 5;       // Distance from player target point
lookDistanceFinal = lookDistance;   // Lerped

window_mouse_set_locked(true);

// Position to follow (XZ is ground. Y is up)
posX = 0;
posZ = 0;