

PhysicsSystem physics = new PhysicsSystem(1.0f/60.0f, new PVector(0, -10));
RigidBody2D rigidBody1, rigidBody2;
float dt = 1.0f/60.0f;
OBB obb1;

void setup(){
  size(1000, 1000, P2D);
  background(0);

  rigidBody1 = new RigidBody2D();
  rigidBody2 = new RigidBody2D();
  
  rigidBody1.setTransform(new PVector(500, 500));
  rigidBody2.setTransform(new PVector(500, 600));

  rigidBody1.setMass(100.0f);
  rigidBody2.setMass(200.0f);

  physics.addRigidBody(rigidBody1);
  physics.addRigidBody(rigidBody2);
  obb1 = new OBB(new PVector(0,0), new PVector(32, 32));
  obb1.setRigidBody(rigidBody1);




}

void draw(){

  physics.update(dt);
  obb1.drawOBB();

  
}

