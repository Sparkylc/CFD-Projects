
Rigidbody rigidbody = new Rigidbody(new PVector(500, 500), new PVector(0, 0), new Integrator());
Rigidbody springRigidbody = new Rigidbody(new PVector(500,600), new PVector(0, 0), new Integrator());
AddForce addForce = new AddForce();

ArrayList<Rigidbody> rigidbodyArrayList = new ArrayList<Rigidbody>();

//Rigidbody test = new Rigidbody(new PVector(500, 500), new PVector(0, 0), new Integrator());


void setup(){
  size(1000, 1000);
  frameRate(200);
  //rigidbody.addForce(new Friction());


  rigidbody.setRadius(10);
  rigidbody.setMass(10);
  rigidbody.setPosition(400, 400);
  rigidbody.setVisibility(true);
  rigidbody.setMouseInteractive(true);
  rigidbodyArrayList.add(rigidbody);

  springRigidbody.setRadius(10);
  springRigidbody.setMass(10);
  springRigidbody.setPosition(400, 500);
  springRigidbody.setVisibility(true);
  springRigidbody.setMouseInteractive(true);
  rigidbodyArrayList.add(springRigidbody);





  //test.setRadius(50);
  //test.setMass(10);
  //test.setPosition(600, 600);

  //rigidbody.setVelocity(10,0);

  addForce.AddGravityForceToRigidBody(rigidbody, PhysicsWorld.GRAVITY);
  addForce.AddGravityForceToRigidBody(springRigidbody, PhysicsWorld.GRAVITY);
  //addForce.AddFollowMouseForceToRigidBody(rigidbody);
  //addForce.AddGravityForceToRigidBody(rigidbody, PhysicsWorld.GRAVITY);


  //addForce.AddSpringForceToRigidBody(springRigidbody, new PVector(400, 300), 20.0f, 10);
 //addForce.AddSpringForceToRigidBody(springRigidbody, new PVector(300, 400), 20.0f, 10);
  //addForce.AddSpringForceToRigidBody(rigidbody, new PVector(500, 400), 20.0f, 10);
  addForce.AddSpringForceToSpringForce(springRigidbody, rigidbody, 20.0f, 10);

  addForce.AddRigidRodForceToRigidBody(rigidbody, new PVector(400, 300), 100, 100);

  //rigidbody.addForce(new AirResistance());



}

void draw(){
  background(16, 18, 19);
  rigidbody.draw();
  springRigidbody.draw();
  System.out.println(rigidbody.getPosition());
  //springRigidbody.draw();

  

}