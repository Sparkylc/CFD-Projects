
QueasyCam cam;

RigidBodyGeneration RigidBodyGeneration = new RigidBodyGeneration();
ArrayList<RigidBody> bodyList;
ArrayList<BoundingShape> boundingShapeList;


void setup(){
  size(1000, 1000, P3D);
  frameRate(500);

  cam = new QueasyCam(this);
	cam.speed = 1;              // default is 3
	cam.sensitivity = 0.5; 

  bodyList = new ArrayList<RigidBody>();
  boundingShapeList = new ArrayList<BoundingShape>();
  int bodyCount = 2;



  for(int i = 0; i < bodyCount; i++){

    float x = (float)random(0, 100);
    float y = (float)random(0, 100);
    float z = (float)random(0, 100);
      
    bodyList.add(RigidBodyGeneration.CreateCuboidBody(new PVector(x,y,z), 1f, 0.5f, false, 10f, 10f, 10f));


    boundingShapeList.add(new BoundingShape(new PVector(x,y,z), 10f, 10f, 10f,1));

    
    
  }
  bodyList.add(RigidBodyGeneration.CreateSphereBody(new PVector(0,0,0), 1f, 0.5f, false, 10f));
}



void draw(){
  background(0);
  fill(255);

  float dx = 0f;
  float dy = 0f;
  float dz = 0f;
  float rx = 0f;
  float ry = 0f;
  float rz = 0f;

  float speed = 0.1f;
  if(keyPressed){
    if(key == 'l'){
      dx++;
    }
    if(key == 'j'){
      dx--;
    }
    if(key == 'k'){
      dy++;
    }
    if(key == 'i'){
      dy--;
    }
    if(key == 'o'){
      dz--;
    }
    if(key == 'u'){
      dz++;
    }
    if(keyCode == UP){
      ry = radians((ry+1)%360);
    }
    if(keyCode == DOWN){
      ry = radians((ry-1)%360);
    }
    if(keyCode == LEFT){
      rx = radians((rx-1)%360);
    }
    if(keyCode == RIGHT){
      rx = radians((rx+1)%360);
    }

  }
  if(dx != 0 || dy != 0 || dz != 0){
    PVector direction = new PVector(dx, dy, dz);
    direction = direction.normalize();
    PVector velocity = direction.mult(speed);
    bodyList.get(0).Move(velocity);
   
  }
  if(rx != 0 || ry != 0 || rz != 0){
    PVector rotation = new PVector(rx, ry, rz);
    bodyList.get(0).Rotate(rotation);
    //boundingShapeList.get(0).rotate(rx, ry, rz);
  }
    for(int i = 0; i < boundingShapeList.size()-1; i++){
        
    RigidBody bodyA = bodyList.get(i);
    BoundingShape boundingShapeA =  boundingShapeList.get(i);
    boundingShapeA.origin = bodyA.position.copy();
    
    for(int j = i+1; j < boundingShapeList.size(); j++){   
        BoundingShape boundingShapeB = boundingShapeList.get(j);

        RigidBody bodyB = bodyList.get(j);
        boundingShapeB.origin = bodyB.position.copy();

        if(Collisions.polygonIntersection(boundingShapeA, boundingShapeB)){
            bodyA.Move(Collisions.normal.mult(-Collisions.depth/2));
            bodyB.Move(Collisions.normal.mult(-Collisions.depth/2));
            System.out.println("Collision");
        } 
        //if(Collisions.SphereIntersection(bodyA.position, bodyA.Radius, bodyB.position, bodyB.Radius)){
        //  bodyA.Move(Collisions.normal.multiply(-1*Collisions.depth/2));
        //  bodyB.Move(Collisions.normal.multiply(Collisions.depth/2));
        //}
    }
  }

  for(RigidBody body : bodyList){
    if(body.TypeID == 0){
      pushMatrix();
      translate(body.position.x, body.position.y, body.position.z);
      sphere(body.Radius);
      popMatrix();
    }
    if(body.TypeID == 1){
      pushMatrix();
      translate(body.position.x, body.position.y, body.position.z);
      box(body.Width, body.Height, body.Depth);
      popMatrix();
    }
  }

}
