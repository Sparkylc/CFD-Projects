float framesPerSecond = 240;
float metersPerPixel = 1;





PVector initialMousePosition = new PVector();
PVector finalMousePosition = new PVector();
PVector centerOfMass = new PVector();
PVector offset;


//mouse booleans for mouse interactions
boolean mousePressed = false;
boolean mouseReleased = false;

float panX = 0;
float panY = 0;
float lockedPanX = 0;
float lockedPanY = 0;
float zoom = 1;
float oldZoom = 1;
float zoomFactor = 1.1;
float scale  = 1;

int lockCount = 0;
//declares a user interface object
UserInterface userInterfaceController;;
ControlP5 userInterface;

float gravitationalScalingCoefficient = 25;
//initializes the timestep size and the simulation object
float dt = 0.001;
Simulation simulation = new Simulation();

String activeTab = "controlTab";