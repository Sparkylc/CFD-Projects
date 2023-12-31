
Rigidbody rigidbody = new Rigidbody(new PVector(500, 500), new PVector(5,5), new Integrator());
AddForce addForce = new AddForce();


void setup(){
  size(1000, 1000);
  frameRate(200);
  //rigidbody.addForce(new Friction());
  rigidbody.setRadius(50);
  //rigidbody.addForce(new FollowMouse());
  rigidbody.setStart(new PVector(100,100));
  rigidbody.setPosition(400, 600);
  rigidbody.setVelocity(10,0);

  //addForce.AddGravityForceToRigidBody(rigidbody, PhysicsWorld.GRAVITY);
  addForce.AddFollowMouseForceToRigidBody(rigidbody);
  //addForce.AddGravityForceToRigidBody(rigidbody, PhysicsWorld.GRAVITY);
  //addForce.AddSpringForceToRigidBody(rigidbody, new PVector(400, 500), 10.0f, 300);
  //rigidbody.addForce(new AirResistance());



}

void draw(){
  background(16, 18, 19);
  MouseEvent.mouseX = mouseX;
  MouseEvent.mouseY = mouseY;
  rigidbody.draw();

  

}