public class AirResistance implements ForceRegistry {
  
  private Rigidbody rigidbody;

  @Override
  public PVector getForce(Rigidbody rigidbody, PVector position) {
    this.rigidbody = rigidbody;
    PVector force;
    float speedSquared = rigidbody.getVelocity().magSq();
    float dragCoefficient = PhysicsWorld.getDragCoefficient(rigidbody.getShapeType());

    //checks if density is zero, because if it is, then there is no air resistance
    if(rigidbody.getDensity() == 0) {
      System.out.println("Density is 0");
    }

    float density = rigidbody.getDensity();
    PVector speedDirection = rigidbody.getVelocity().copy().normalize();
    force = PVector.mult(PVector.mult(speedDirection, -0.5f * density * speedSquared * dragCoefficient), PhysicsWorld.DRAG_COEFFIIENT_SCALING_FACTOR);
    return force;
  } 

  @Override
  public void draw(){
    //do nothing
  }
}