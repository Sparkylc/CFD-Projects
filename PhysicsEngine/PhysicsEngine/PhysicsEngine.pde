
float[] cameraExtents;



void setup() {

  size(1000, 1000);
  frameRate(240);

  rigidbodyArrayList = new ArrayList<Rigidbody>();
  interactivityListener = new InteractivityListener();


  Rigidbody floor = RigidbodyGenerator.CreateBoxBody(width/2,
                                                   3, new PVector(0, -10), 1f, 1f, true, true,
                                                   true, 0.25, new PVector(0, 0, 0),
                                                   new PVector(255, 255, 255));
  Rigidbody slantedFloor1 = RigidbodyGenerator.CreateBoxBody(50,
                                                   3, new PVector(-20, -50), 1f, 1f, true, true,
                                                   true, 0.25, new PVector(0, 0, 0),
                                                   new PVector(255, 255, 255));
   Rigidbody slantedFloor2 = RigidbodyGenerator.CreateBoxBody(50,
                                                   3, new PVector(20, -70), 1f, 1f, true, true,
                                                   true, 0.25, new PVector(0, 0, 0),
                                                   new PVector(255, 255, 255));
  
  slantedFloor1.Rotate(PI/6);
  slantedFloor2.Rotate(-PI/6);

  rigidbodyArrayList.add(slantedFloor1);
  rigidbodyArrayList.add(slantedFloor2);
  rigidbodyArrayList.add(floor);
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

  for (Rigidbody rigidbody : rigidbodyArrayList) {
    rigidbody.draw();
    rigidbody.drawAABB();
  }
  for(PVector point : pointsOfContact) {
    stroke(0, 0, 0);
    strokeWeight(0.1f);
    noFill();
    rectMode(CENTER);
    rect(point.x, point.y, 1, 1);
  }

  Step(0.01, 64);

  interactivityListener.resetTransform();

    //TIMING UTILITIES
  if(millis() - systemTime>= 200) {
    totalStepTime = ((totalWorldStepTime/1000) / totalSampleCount);
    subStepTime = ((subWorldStepTime/1000) / subSampleCount);
    bodyCount = rigidbodyArrayList.size();

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