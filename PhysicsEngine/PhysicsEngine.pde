
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
    box.addForceToForceRegistry(new Spring(box, new PVector(0,0), new PVector(-10, -20)));



    Rigidbody rigidbodyA = RigidbodyGenerator.CreateBoxBody(1f,
                                                                 1f, 1f, 1f, false, true,
                                                                 true, 0.05, new PVector(0, 0, 0),
                                                                 new PVector(255, 255, 255));
    Rigidbody rigidbodyB = RigidbodyGenerator.CreateBoxBody(1f,
                                                                      1f, 1f, 1f, false, true,
                                                                      true, 0.05, new PVector(0, 0, 0),
                                                                      new PVector(255, 255, 255));

    rigidbodyA.SetInitialPosition(new PVector(0, -11));
    rigidbodyB.SetInitialPosition(new PVector(0, -10));


    Rod rigidRodA = new Rod(rigidbodyA, rigidbodyB, new PVector(1, 0),
                                            new PVector(0, 0));
    Rod rigidRodB = new Rod(rigidbodyB, rigidbodyA, new PVector(0, 0),
                                            new PVector(1, 0));


    rigidbodyA.addForceToForceRegistry(new Gravity());
    rigidbodyA.addForceToForceRegistry(rigidRodA);
    rigidbodyB.addForceToForceRegistry(new Gravity());
    rigidbodyB.addForceToForceRegistry(rigidRodB);

    AddBodyToBodyEntityList(rigidbodyA);
    AddBodyToBodyEntityList(rigidbodyB);
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



