
Rigidbody rigidbody = new Rigidbody(new PVector(500, 500), new PVector(0, 0), new Integrator());
Rigidbody springRigidbody = new Rigidbody(new PVector(500,600), new PVector(0, 0), new Integrator());
Rigidbody testBody = new Rigidbody(new PVector(500,600), new PVector(0, 0), new Integrator());

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


  testBody.setRadius(50);
  testBody.setMass(10);
  testBody.setPosition(600, 600);
  testBody.setVisibility(true);
  testBody.setMouseInteractive(true);


  springRigidbody.setRadius(10);
  springRigidbody.setMass(10);
  springRigidbody.setPosition(400, 500);
  springRigidbody.setVisibility(true);
  springRigidbody.setMouseInteractive(true);
  springRigidbody.setAngularAcceleration(0);
  springRigidbody.setAngularVelocity(0.1);
  springRigidbody.setAngularPosition(0);
  springRigidbody.setIsStatic(true);

  rigidbodyArrayList.add(rigidbody);
  rigidbodyArrayList.add(springRigidbody);
  rigidbodyArrayList.add(testBody);





  //test.setRadius(50);
  //test.setMass(10);
  //test.setPosition(600, 600);

  //rigidbody.setVelocity(10,0);

  addForce.AddGravityForceToRigidBody(rigidbody, PhysicsWorld.GRAVITY);
  addForce.AddGravityForceToRigidBody(springRigidbody, PhysicsWorld.GRAVITY);


  //addForce.AddFollowMouseForceToRigidBody(rigidbody);
  //addForce.AddGravityForceToRigidBody(rigidbody, PhysicsWorld.GRAVITY);


  //addForce.AddSpringForceToRigidBody(rigidbody, new PVector(400, 300), 20.0f, 10);
  //addForce.AddSpringForceToRigidBody(rigidbody, new PVector(300, 400), 20.0f, 10);
  //addForce.AddSpringForceToRigidBody(rigidbody, new PVector(500, 400), 20.0f, 10);
  //addForce.AddSpringForceToRigidBody(rigidbody, new PVector(400, 500), 20.0f, 10);
  //addForce.AddSpringForceToSpringForce(rigidbody, springRigidbody, 20.0f, 10);

  //addForce.AddSpringForceToSpringForce(springRigidbody, rigidbody, 20.0f, 10);

  //addForce.AddRigidRodForceToRigidBody(rigidbody, new PVector(400, 300), 100, 100);

  //rigidbody.addForce(new AirResistance());

  addForce.AddRigidRodForceToPointOnRigidBody(rigidbody, springRigidbody, 100, 100);


}

void draw(){
  background(16, 18, 19);

  for (Rigidbody body : rigidbodyArrayList) {
        body.draw();
    }

  

}