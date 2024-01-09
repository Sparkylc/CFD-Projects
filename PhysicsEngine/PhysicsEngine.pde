
float[] cameraExtents;



void setup() {

  lastFrameTime = millis();
  size(1000, 1000);
  windowMove(10, 4);
  frameRate(240);

  rigidbodyList = new ArrayList<Rigidbody>();
  interactivityListener = new InteractivityListener();


  Rigidbody floor = RigidbodyGenerator.CreateBoxBody(100,
                                                   2f, 0.1f, 0.1f, true, true,
                                                   true, 0.05, new PVector(0, 0, 0),
                                                   new PVector(255, 255, 255));

  floor.SetInitialPosition(new PVector(0, 0));

  Rigidbody slantedFloor1 = RigidbodyGenerator.CreateBoxBody(30f,
                                                   1f, 0.1f, 0.1f, true, true,
                                                   true, 0.05, new PVector(0, 0, 0),
                                                   new PVector(255, 255, 255));
  slantedFloor1.SetInitialPosition(new PVector(-10, -10));

   Rigidbody slantedFloor2 = RigidbodyGenerator.CreateBoxBody(30f,
                                                   2f, 0.1f, 0.1f, true, true,
                                                   true, 0.05, new PVector(0, 0, 0),
                                                   new PVector(255, 255, 255));
  slantedFloor2.SetInitialPosition(new PVector(20, -20));
  slantedFloor1.Rotate(PI/6);
  slantedFloor2.Rotate(-PI/6);

    Rigidbody box = RigidbodyGenerator.CreateBoxBody(1f,
                                                     1f, 1f, 1f, false, true,
                                                     true, 0.05, new PVector(0, 0, 0),
                                                     new PVector(255, 255, 255));
    box.addForceToForceRegistry(new Gravity());
    box.addForceToForceRegistry(new Spring(box));



  Rigidbody rigidbodyJoint1 = RigidbodyGenerator.CreateBoxBody(1f,
                                                     1f, 1f, 1f, false, true,
                                                     true, 0.05, new PVector(0, 0, 0),
                                                     new PVector(255, 255, 255));
  Rigidbody anchorRigidbodyJoint = RigidbodyGenerator.CreateBoxBody(1f,
                                                     1f, 1f, 1f, false, true,
                                                     true, 0.05, new PVector(0, 0, 0),
                                                     new PVector(255, 255, 255));

    rigidbodyJoint1.SetInitialPosition(new PVector(0, -11));
    anchorRigidbodyJoint.SetInitialPosition(new PVector(0, -10));

    RigidJoint rigidjoint1 = new RigidJoint(rigidbodyJoint1, anchorRigidbodyJoint, new PVector(0.2, 0),
                                            new PVector(0, 0), 1, 1);
    RigidJoint rigidjoint2 = new RigidJoint(anchorRigidbodyJoint, rigidbodyJoint1, new PVector(0.2, 0),
                                            new PVector(0, 0), 1, 1);
rigidbodyJoint1.addForceToForceRegistry(new Gravity());
rigidbodyJoint1.addForceToForceRegistry(rigidjoint1);
anchorRigidbodyJoint.addForceToForceRegistry(new Gravity());
anchorRigidbodyJoint.addForceToForceRegistry(rigidjoint2);

  AddBodyToBodyEntityList(rigidbodyJoint1);
    AddBodyToBodyEntityList(anchorRigidbodyJoint);
  AddBodyToBodyEntityList(slantedFloor1);
  AddBodyToBodyEntityList(slantedFloor2);
  AddBodyToBodyEntityList(floor);
  AddBodyToBodyEntityList(box);
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



