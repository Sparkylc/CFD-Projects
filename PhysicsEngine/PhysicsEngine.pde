
float[] cameraExtents;



void setup() {

  lastFrameTime = millis();
  size(1000, 1000);
  windowMove(10, 4);
  frameRate(240);

  rigidbodyList = new ArrayList<Rigidbody>();
  interactivityListener = new InteractivityListener();


  Rigidbody floor = RigidbodyGenerator.CreateBoxBody(100,
                                                   2f, 1f, 1f, true, true,
                                                   true, 0.25, new PVector(0, 0, 0),
                                                   new PVector(255, 255, 255));
  floor.SetInitialPosition(new PVector(0, 0));

  Rigidbody slantedFloor1 = RigidbodyGenerator.CreateBoxBody(30f,
                                                   1f, 1f, 1f, true, true,
                                                   true, 0.25, new PVector(0, 0, 0),
                                                   new PVector(255, 255, 255));
  slantedFloor1.SetInitialPosition(new PVector(-10, -10));

   Rigidbody slantedFloor2 = RigidbodyGenerator.CreateBoxBody(30f,
                                                   2f, 1f, 1f, true, true,
                                                   true, 0.25, new PVector(0, 0, 0),
                                                   new PVector(255, 255, 255));
  slantedFloor2.SetInitialPosition(new PVector(20, -20));
  
  slantedFloor1.Rotate(PI/6);
  slantedFloor2.Rotate(-PI/6);

  AddBodyToBodyEntityList(slantedFloor1);
  AddBodyToBodyEntityList(slantedFloor2);
  AddBodyToBodyEntityList(floor);
}




void draw() {
    int currentFrameTime = millis();

  interactivityListener.applyTransform();

  render.draw();

  
  dt = (currentFrameTime - lastFrameTime) / 1000f;
  Step(dt, 20);

  interactivityListener.resetTransform();
  displayTimings();

  lastFrameTime = currentFrameTime;
}



