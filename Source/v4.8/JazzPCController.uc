/**
 * EXPERIMENTAL / NOT YET COMPILED IN DECEMBER 2010 UDK.
 * Drives the original MoveZone and LookZone Kismet branches through
 * SeqEvent_MobileLook outputs. No editor map rewiring is required.
 *
 * WASD: movement, Q/E: test rotation, hold F9: original firing path.
 * MouseX/Y are an optional (build-dependent) relative-aim input.
 */
class JazzPCController extends MobilePC
    DependsOn(MobileInputZone);

var bool bNorth, bSouth, bWest, bEast;
var bool bAimCW, bAimCCW, bTrigger;
var bool bSentMove, bSentLook;
var SeqEvent_MobileLook MoveNode, LookNode;
var float NextNodeSearch;
var int AimYaw;
var float PCMouseSensitivity;
var int JazzTickCount;
var bool bJazzMovementDebug;
var float JazzNextMoveLog;
var float JazzMovementStrength;

// v4.8: desktop mouse events are observed from the 2010 mobile input layer.
// No Windows hooks, AutoHotkey, or modifications to JazzMiniGame.mobile.
var bool bJazzMouseEnabled;
var bool bJazzMouseDebug;
var bool bJazzMouseHookInstalled;
var bool bJazzMouseHeld;
var bool bJazzMousePositionKnown;
var bool bJazzMouseAimFromTouch;
var int JazzMouseHandle;
var int JazzMouseEventCount;
var int JazzMouseDownCount;
var int JazzMouseUpCount;
var vector2D JazzMouseScreenPos;
var float JazzAimCenterX;
var float JazzAimCenterY;
var float JazzAimTouchStrength;
var float JazzLastMouseEventTime;

/** No persistent ini rewriting: bindings are installed only on this controller. */
event InitInputSystem()
{
    local name BindKey;
    Super.InitInputSystem();
    if (PlayerInput == None)
        return;

    BindKey = 'W';
    PlayerInput.SetBind(BindKey, "JazzNorthOn | OnRelease JazzNorthOff");
    BindKey = 'S';
    PlayerInput.SetBind(BindKey, "JazzSouthOn | OnRelease JazzSouthOff");
    BindKey = 'A';
    PlayerInput.SetBind(BindKey, "JazzWestOn | OnRelease JazzWestOff");
    BindKey = 'D';
    PlayerInput.SetBind(BindKey, "JazzEastOn | OnRelease JazzEastOff");
    BindKey = 'Q';
    PlayerInput.SetBind(BindKey, "JazzAimCCWOn | OnRelease JazzAimCCWOff");
    BindKey = 'E';
    PlayerInput.SetBind(BindKey, "JazzAimCWOn | OnRelease JazzAimCWOff");
    BindKey = 'F9';
    PlayerInput.SetBind(BindKey, "JazzTriggerOn | OnRelease JazzTriggerOff");
    BindKey = 'MouseX';
    PlayerInput.SetBind(BindKey, "Axis aMouseX Speed=1.0");
    BindKey = 'MouseY';
    PlayerInput.SetBind(BindKey, "Axis aMouseY Speed=1.0");

    InstallJazzMouseHook();
    `log("JazzPC: input bindings installed");
}

exec function JazzNorthOn()
{
    bNorth = true;
    `log("JazzPC MOVE: JazzNorthOn accepted; bNorth=true");
}
exec function JazzNorthOff()
{
    bNorth = false;
    `log("JazzPC MOVE: JazzNorthOff accepted; bNorth=false");
}
exec function JazzSouthOn()   { bSouth = true; }
exec function JazzSouthOff()  { bSouth = false; }
exec function JazzWestOn()    { bWest = true; }
exec function JazzWestOff()   { bWest = false; }
exec function JazzEastOn()    { bEast = true; }
exec function JazzEastOff()   { bEast = false; }
exec function JazzAimCWOn()   { bAimCW = true; }
exec function JazzAimCWOff()  { bAimCW = false; }
exec function JazzAimCCWOn()  { bAimCCW = true; }
exec function JazzAimCCWOff() { bAimCCW = false; }
exec function JazzTriggerOn() { bTrigger = true; }
exec function JazzTriggerOff(){ bTrigger = false; }

/** 2010 MobilePlayerInput exposes a low-level touch event delegate.
 * -simmobile converts mouse press / drag / release into touch-like events.
 * We OBSERVE these events rather than synthesizing keyboard presses.
 * Note: on some runtimes this delegate may not see fake mouse touches.
 */
function InstallJazzMouseHook()
{
    local MobilePlayerInput MobileInput;
    MobileInput = MobilePlayerInput(PlayerInput);
    if (MobileInput == None)
        return;
    MobileInput.OnInputTouch = JazzOnPCInputTouch;
    bJazzMouseHookInstalled = true;
    `log("JazzPC MOUSE: OnInputTouch handler registered");
}

/** Exactly four parameters in the actual December 2010 source.
 * Newer UE3 builds use an additional TouchpadIndex: do not use that here. */
function JazzOnPCInputTouch(int Handle, MobileInputZone.EZoneTouchEvent Type,
                             vector2D TouchLocation, float DeviceTimestamp)
{
    ++JazzMouseEventCount;
    JazzLastMouseEventTime = WorldInfo.TimeSeconds;
    if (!bJazzMouseEnabled)
        return;

    // Ignore a second simulated touch while the first mouse button is held.
    if (Type == ZoneEvent_Touch)
    {
        if (!bJazzMouseHeld)
        {
            bJazzMouseHeld = true;
            JazzMouseHandle = Handle;
            ++JazzMouseDownCount;
        }
    }
    else if (Handle != JazzMouseHandle)
    {
        return;
    }

    JazzMouseScreenPos = TouchLocation;
    bJazzMousePositionKnown = true;
    bJazzMouseAimFromTouch = true;

    if (Type == ZoneEvent_UnTouch || Type == ZoneEvent_Cancelled)
    {
        bJazzMouseHeld = false;
        ++JazzMouseUpCount;
    }

    if (bJazzMouseDebug && (Type == ZoneEvent_Touch || Type == ZoneEvent_UnTouch || Type == ZoneEvent_Cancelled))
        `log("JazzPC MOUSE: touch=" $ int(Type) $ " handle=" $ Handle $ " screen=" $ TouchLocation $ " held=" $ bJazzMouseHeld);
}

/** Mouse cursor is evaluated relative to a configurable camera center.
 * This is an approximation for the original overhead camera; proper
 * pawn screen-space projection can be added later if required. */
function vector GetJazzMouseAim()
{
    local vector Aim;
    local vector2D ViewSize;
    local LocalPlayer LP;
    local float CenterX, CenterY;

    LP = LocalPlayer(Player);
    if (LP != None && LP.ViewportClient != None)
        LP.ViewportClient.GetViewportSize(ViewSize);
    if (ViewSize.X < 2.0 || ViewSize.Y < 2.0)
        return vect(0,0,0);

    CenterX = ViewSize.X * JazzAimCenterX;
    CenterY = ViewSize.Y * JazzAimCenterY;
    // Screen up maps to positive world X, right maps to positive world Y.
    Aim.X = CenterY - JazzMouseScreenPos.Y;
    Aim.Y = JazzMouseScreenPos.X - CenterX;
    Aim.Z = 0.0;
    if (VSizeSq(Aim) < 64.0)
        return vect(0,0,0);
    return Normal(Aim);
}

exec function JazzMouseModeOn()
{
    bJazzMouseEnabled = true;
    if (!bJazzMouseHookInstalled)
        InstallJazzMouseHook();
    `log("JazzPC MOUSE: native touch-driven firing enabled");
}
exec function JazzMouseModeOff()
{
    bJazzMouseEnabled = false;
    bJazzMouseHeld = false;
    `log("JazzPC MOUSE: native touch-driven firing disabled; original input stays active");
}
exec function JazzMouseDebugOn()  { bJazzMouseDebug = true; `log("JazzPC MOUSE: debug enabled"); }
exec function JazzMouseDebugOff() { bJazzMouseDebug = false; `log("JazzPC MOUSE: debug disabled"); }
exec function JazzMouseStatus()
{
    `log("JazzPC MOUSE: enabled=" $ bJazzMouseEnabled $ " hook=" $ bJazzMouseHookInstalled $ " held=" $ bJazzMouseHeld $ " validPos=" $ bJazzMousePositionKnown);
    `log("JazzPC MOUSE: events=" $ JazzMouseEventCount $ " downs=" $ JazzMouseDownCount $ " ups=" $ JazzMouseUpCount $ " lastPos=" $ JazzMouseScreenPos $ " lastEventTime=" $ JazzLastMouseEventTime);
    `log("JazzPC MOUSE: lookNode=" $ LookNode $ " keyboardTrigger=" $ bTrigger);
}
exec function JazzSetAimCenter(float X, float Y)
{
    JazzAimCenterX = FClamp(X, 0.05, 0.95);
    JazzAimCenterY = FClamp(Y, 0.05, 0.95);
    `log("JazzPC MOUSE: aim center=" $ JazzAimCenterX $ "," $ JazzAimCenterY);
}

/** Console-only sanity check that the custom PlayerController is loaded. */
exec function JazzPCPing()
{
    ClientMessage("JazzPC controller is active");
    `log("JazzPC: ping received");
}

/** Re-find sequence nodes after delayed initialization / level change. */
function FindJazzNodes()
{
    local Sequence Root;
    local array<SequenceObject> Objects;
    local int i;
    local SeqEvent_MobileLook M;

    Root = WorldInfo.GetGameSequence();
    if (Root == None)
        return;

    Root.FindSeqObjectsByClass(class'SeqEvent_MobileLook', true, Objects);
    for (i = 0; i < Objects.Length; ++i)
    {
        M = SeqEvent_MobileLook(Objects[i]);
        if (M == None)
            continue;
        if (M.TargetZoneName ~= "MoveZone")
            MoveNode = M;
        else if (M.TargetZoneName ~= "LookZone")
            LookNode = M;
    }
    if (MoveNode != None && LookNode != None)
        `log("JazzPC: found both mobile Kismet look events");
    else
        `log("JazzPC: awaiting map Kismet look events");
}

/** Drive the EXACT Kismet branch that was used by the mobile touch zone. */
function PulseMobileLook(SeqEvent_MobileLook Node, vector Direction)
{
    local rotator DirRotation;
    if (Node == None)
        return;

    Direction.Z = 0.0;
    Direction = Normal(Direction);
    DirRotation = Rotator(Direction);

    Node.Yaw = float(DirRotation.Yaw);
    // Jazz's original touchscreen MoveZone reports strength in the hundreds.
    // Only scale MoveZone; leave LookZone (aiming/shooting) at the old 1.0.
    if (Node == MoveNode)
        Node.StickStrength = JazzMovementStrength;
    else
        Node.StickStrength = 1.0;
    Node.RotationVector = Direction;
    Node.PopulateLinkedVariableValues();
    Node.ForceActivateOutput(0); // Input Active
}

/** Release path is essential because Jazz's original Kismet has stop logic. */
function ReleaseMobileLook(SeqEvent_MobileLook Node)
{
    if (Node == None)
        return;

    Node.StickStrength = 0.0;
    Node.RotationVector = vect(0,0,0);
    Node.PopulateLinkedVariableValues();
    Node.ForceActivateOutput(1); // Input Inactive
}

/** Kismet tick bridge. The mouse axes MAY be intercepted by -simmobile;
 * Q/E offer a dependable diagnostic path if no mouse delta arrives. */
event PlayerTick(float DeltaTime)
{
    local vector Move, Aim;
    local rotator R;
    local float MouseDX, MouseDY;
    local vector CursorAim;

    if (PlayerInput != None)
    {
        MouseDX = PlayerInput.aMouseX;
        MouseDY = PlayerInput.aMouseY;
    }

    Super.PlayerTick(DeltaTime);
    ++JazzTickCount;
    if (!bJazzMouseHookInstalled && PlayerInput != None && (JazzTickCount % 140 == 1))
        InstallJazzMouseHook();
    if (bJazzMovementDebug && WorldInfo.TimeSeconds >= JazzNextMoveLog)
    {
        `log("JazzPC MOVE: tick=" $ JazzTickCount $ " north=" $ bNorth $ " south=" $ bSouth $ " west=" $ bWest $ " east=" $ bEast $ " moveNode=" $ MoveNode $ " pawn=" $ Pawn);
        if (MoveNode != None)
            `log("JazzPC MOVE: MoveNode output strength=" $ MoveNode.StickStrength $ " vector=" $ MoveNode.RotationVector);
        JazzNextMoveLog = WorldInfo.TimeSeconds + 2.0;
    }

    if ((MoveNode == None || LookNode == None) && WorldInfo.TimeSeconds > NextNodeSearch)
    {
        FindJazzNodes();
        NextNodeSearch = WorldInfo.TimeSeconds + 2.0;
    }

    if (bNorth) Move.X += 1.0;
    if (bSouth) Move.X -= 1.0;
    if (bEast)  Move.Y += 1.0;
    if (bWest)  Move.Y -= 1.0;

    if (VSizeSq(Move) > 0.01)
    {
        PulseMobileLook(MoveNode, Move);
        bSentMove = true;
    }
    else if (bSentMove)
    {
        ReleaseMobileLook(MoveNode);
        bSentMove = false;
    }

    // Unreal rotation units: 65536 ~= a full turn.
    AimYaw += int(MouseDX * PCMouseSensitivity);
    // Existing Q/E and MouseX axis controls remain available.
    // MouseY is sampled for diagnostics; overhead aiming uses yaw only.
    if (bAimCW)  AimYaw += int(12000.0 * DeltaTime);
    if (bAimCCW) AimYaw -= int(12000.0 * DeltaTime);

    R.Pitch = 0;
    R.Roll = 0;
    R.Yaw = AimYaw;
    Aim = Vector(R);
    Aim.Z = 0.0;

    // When the simulated mouse is held, prefer cursor-to-center aim over
    // relative mouse delta. No projectile spawning is duplicated here.
    if (bJazzMouseEnabled && bJazzMouseHeld && bJazzMousePositionKnown)
    {
        CursorAim = GetJazzMouseAim();
        if (VSizeSq(CursorAim) > 0.1)
            Aim = CursorAim;
    }

    if (bTrigger || (bJazzMouseEnabled && bJazzMouseHeld))
    {
        PulseMobileLook(LookNode, Aim);
        bSentLook = true;
    }
    else if (bSentLook)
    {
        ReleaseMobileLook(LookNode);
        bSentLook = false;
    }
}

/** Tune keyboard-driven movement while playing, without re-compiling. */
exec function JazzSetMoveStrength(float NewStrength)
{
    JazzMovementStrength = FClamp(NewStrength, 0.0, 500.0);
    `log("JazzPC MOVE: JazzMovementStrength=" $ JazzMovementStrength);
}

/** Read-only diagnostics. Log lines are written to MobileGame\Logs\Launch.log. */
exec function JazzMoveStatus()
{
    `log("JazzPC MOVE: movementStrength=" $ JazzMovementStrength $ " status tick=" $ JazzTickCount $ " north=" $ bNorth $ " south=" $ bSouth $ " west=" $ bWest $ " east=" $ bEast);
    `log("JazzPC MOVE: controller=" $ Self $ " possessedPawn=" $ Pawn $ " moveNode=" $ MoveNode $ " lookNode=" $ LookNode);
    if (MoveNode != None)
        `log("JazzPC MOVE: Kismet zone=" $ MoveNode.TargetZoneName $ " strength=" $ MoveNode.StickStrength $ " vector=" $ MoveNode.RotationVector);
}

exec function JazzMoveDebugOn()
{
    bJazzMovementDebug = true;
    JazzNextMoveLog = 0;
    `log("JazzPC MOVE: periodic diagnostics enabled");
}

exec function JazzMoveDebugOff()
{
    bJazzMovementDebug = false;
    `log("JazzPC MOVE: periodic diagnostics disabled");
}

/** Find placed Jazz pawns without changing anything. */
exec function JazzListPawns()
{
    local MobilePawn TestPawn;
    local int Count;
    foreach WorldInfo.AllActors(class'MobilePawn', TestPawn)
    {
        ++Count;
        `log("JazzPC MOVE: pawn name=" $ TestPawn.Name $ " actor=" $ TestPawn $ " location=" $ TestPawn.Location $ " velocity=" $ TestPawn.Velocity $ " physics=" $ TestPawn.Physics);
    }
    `log("JazzPC MOVE: MobilePawn count=" $ Count);
}

/** One manual pulse through the existing MoveZone Kismet event. */
exec function JazzMovePulse()
{
    if (MoveNode == None)
        FindJazzNodes();
    if (MoveNode == None)
    {
        `log("JazzPC MOVE: pulse failed: MoveZone event not found");
        return;
    }
    PulseMobileLook(MoveNode, vect(1,0,0));
    `log("JazzPC MOVE: single Kismet pulse sent; strength=" $ MoveNode.StickStrength);
}

/** One controlled, one-time diagnostic displacement of the Jazz actor.
 * Does not install a new movement system or save any map changes.
 * It targets the placed MobilePawn_1 shown in the user's Kismet graph. */
exec function JazzMoveStep()
{
    local MobilePawn TestPawn;
    local vector BeforePos;
    local bool bMoved;

    foreach WorldInfo.AllActors(class'MobilePawn', TestPawn)
    {
        if (string(TestPawn.Name) ~= "MobilePawn_1")
        {
            BeforePos = TestPawn.Location;
            bMoved = TestPawn.SetLocation(BeforePos + vect(48,0,0));
            `log("JazzPC MOVE: step target=" $ TestPawn $ " success=" $ bMoved $ " before=" $ BeforePos $ " after=" $ TestPawn.Location);
            return;
        }
    }
    `log("JazzPC MOVE: step skipped; MobilePawn_1 not found");
}

defaultproperties
{
    PCMouseSensitivity=35.0
    JazzMovementStrength=120.0
    bJazzMouseEnabled=true
    JazzAimCenterX=0.5
    JazzAimCenterY=0.5
}