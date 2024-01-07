
float[] cameraExtents;



void setup() {

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
  //TIMING UTILITIES
}


//TIMING UTILITIES

double totalStepTime;
double subStepTime;
int bodyCount;

void draw() {


  background(16, 18, 19);
  //Applies the camera transform
  interactivityListener.applyTransform();
  //Draws the rigidbodies
  render.draw();

  Step(0.01, 64);

  interactivityListener.resetTransform();

    //TIMING UTILITIES
  if(millis() - systemTime>= 200) {
    totalStepTime = ((totalWorldStepTime/1000) / totalSampleCount);
    subStepTime = ((subWorldStepTime/1000) / subSampleCount);
    bodyCount = rigidbodyList.size();

    //updates the counter and resets values
    totalWorldStepTime = 0;
    subWorldStepTime = 0;
    totalSampleCount = 0;
    subSampleCount = 0;
    systemTime = millis();
    }
  
  text("Total Step Time: " + totalStepTime + "\u03BCs", 10, 20);
  text("Sub Step Time: " + subStepTime + "\u03BCs", 10, 40);
  text("Body Count: " + bodyCount, 10, 60);
}
