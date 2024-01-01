
Rigidbody rigidbody = new Rigidbody(new PVector(500, 500), new PVector(0, 0), new Integrator());
Rigidbody springRigidBody = new Rigidbody(new PVector(500,700), new PVector(0, 0), new Integrator());
AddForce addForce = new AddForce();


void setup(){
  size(1000, 1000);
  frameRate(200);
  //rigidbody.addForce(new Friction());


  rigidbody.setRadius(50);
  rigidbody.setMass(10);
  rigidbody.setPosition(400, 600);

  springRigidBody.setRadius(5);
  springRigidBody.setMass(1);
  springRigidBody.setPosition(400, 700);

  //rigidbody.setVelocity(10,0);

  //addForce.AddGravityForceToRigidBody(rigidbody, PhysicsWorld.GRAVITY);
  //addForce.AddFollowMouseForceToRigidBody(rigidbody);
  //addForce.AddGravityForceToRigidBody(rigidbody, PhysicsWorld.GRAVITY);
  addForce.AddSpringForceToRigidBody(rigidbody, new PVector(400, 500), 10.0f, 300);
  addForce.AddSpringForceToSpringForce(springRigidBody, rigidbody, 10.0f, 300);

  //rigidbody.addForce(new AirResistance());



}

void draw(){
  background(16, 18, 19);
  MouseEvent.mouseX = mouseX;
  MouseEvent.mouseY = mouseY;
  rigidbody.draw();
  springRigidBody.draw();

  

}