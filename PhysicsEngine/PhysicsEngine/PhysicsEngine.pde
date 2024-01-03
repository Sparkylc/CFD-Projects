public static ArrayList<Rigidbody> rigidbodyArrayList;
Rigidbody rigidbodyGenerator = new Rigidbody();

//THIS MUST BE KEPT AS THIS NAME AS THE CLASS REQUIRES THIS NAME
InteractivityListener interactivityListener;

void setup(){
  size(1000, 1000);
  frameRate(240);
  rigidbodyArrayList = new ArrayList<Rigidbody>();
  interactivityListener = new InteractivityListener();

  int bodyCount = 10;

  for(int i = 0; i < bodyCount; i++){

    float padding = 20.0f;


    Rigidbody rigidbody = null;


    float x = random(padding, width-padding);
    float y = random(padding, height - padding);

    rigidbody = rigidbodyGenerator.CreateBoxBody(30f, new PVector(x, y), 0.5f, 0.5f, true, true, true, 5f, new PVector(0,0,0), new PVector(255, 255, 255));
    rigidbodyArrayList.add(rigidbody);
  }
}


void draw(){
  background(16, 18, 19);
  interactivityListener.applyTransform();
  for(Rigidbody rigidbody : rigidbodyArrayList){
    rigidbody.draw();
  }
  Collisions.collisionResponse();
  interactivityListener.resetTransform();
}