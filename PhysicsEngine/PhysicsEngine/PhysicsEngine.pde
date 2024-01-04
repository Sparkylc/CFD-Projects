
void setup() {
  size(1000, 1000);
  frameRate(240);
    rigidbodyArrayList = new ArrayList<Rigidbody>();
  interactivityListener = new InteractivityListener();
  
  int bodyCount = 10;
  int type = 0;
  
  for (int i = 0; i < bodyCount; i++) {
    
    float padding = 20.0f;
    type = (int)random(0, 2);
      
      
    Rigidbody rigidbody = null;
    
    
    float x = random(padding, width - padding);
    float y = random(padding, height - padding);

    
    
    if (type == 0) {
      rigidbody = rigidbodyGenerator.CreateCircleBody(20f, new PVector(x, y), 0.5f, 0.5f, true, true, true, 5f, new PVector(0,0,0), new PVector(255, 255, 255));
    } else{
      rigidbody = rigidbodyGenerator.CreateBoxBody(30f, 20f, new PVector(x, y), 0.5f, 0.5f, true, true, true, 5f, new PVector(0,0,0), new PVector(255, 255, 255));
    }
    rigidbodyArrayList.add(rigidbody);
  }
}

float rotationCount = 0;
void draw() {
  background(16, 18, 19);
  interactivityListener.applyTransform();
  for (Rigidbody rigidbody : rigidbodyArrayList) {
    //rigidbody.Rotate(radians(rotationCount*0.01));
    rigidbody.draw();
  }
  Step(0.01);
  interactivityListener.resetTransform();
}