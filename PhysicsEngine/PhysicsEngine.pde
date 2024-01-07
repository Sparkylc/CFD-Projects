
float[] cameraExtents;


int lastFrameTime;

void setup() {

  lastFrameTime = millis();
  size(1000, 1000);
  windowMove(10, 4);
  frameRate(240);

  rigidbodyList = new ArrayList<Rigidbody>();
  interactivityListener = new InteractivityListener();


  Rigidbody floor = RigidbodyGenerator.CreateBoxBody(width/2f,
                                                   3f, 1f, 1f, true, true,
                                                   true, 0.25, new PVector(0, 0, 0),
                                                   new PVector(255, 255, 255));
  floor.SetInitialPosition(new PVector(0, -10));

  Rigidbody slantedFloor1 = RigidbodyGenerator.CreateBoxBody(50f,
                                                   3f, 1f, 1f, true, true,
                                                   true, 0.25, new PVector(0, 0, 0),
                                                   new PVector(255, 255, 255));
  slantedFloor1.SetInitialPosition(new PVector(-20, -50));

   Rigidbody slantedFloor2 = RigidbodyGenerator.CreateBoxBody(50f,
                                                   3f, 1f, 1f, true, true,
                                                   true, 0.25, new PVector(0, 0, 0),
                                                   new PVector(255, 255, 255));
  slantedFloor2.SetInitialPosition(new PVector(20, -70));
  
  slantedFloor1.Rotate(PI/6);
  slantedFloor2.Rotate(-PI/6);

  AddBodyToBodyEntityList(slantedFloor1);
  AddBodyToBodyEntityList(slantedFloor2);
  AddBodyToBodyEntityList(floor);
}




void draw() {

  int currentFrameTime = millis();
  background(16, 18, 19);
  interactivityListener.applyTransform();
  
  render.draw();
  float dt = (currentFrameTime - lastFrameTime) / 1000f;
  Step(dt, 20);

  interactivityListener.resetTransform();
  displayTimings();
/*------------------------------------Timing Utilities--------------------------------------------*/
 lastFrameTime = currentFrameTime;
}



