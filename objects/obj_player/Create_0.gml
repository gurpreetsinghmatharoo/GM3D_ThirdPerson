z = 0;

moveSpeed = 0.12;
dashSpeed = 0.6;
dashTime = 0.3;
dashDir = 0;
dashRot = 0;

inputLen = 0;
inputDir = 0;
inputLenFinal = 0;
faceAngle = 0;

state = STATE.NORMAL;
stateTime = 0;
setState = function(_state, _anim=undefined)
{
    if (state==_state)return;
    state=_state;
    stateTime = 0;
    if (_anim!=undefined)
    {
        playAnim(_anim);
        anim.setSpeed(1.0);
    }
}

enum STATE {
    NORMAL,
    ROLL,
    ATTACK,
    HURT
}

shadow = undefined;

// Targetting
targetRange = 40;
targetting = undefined;

// Shoot
inputShoot = false;

// Hurt
hurtTime = 0;