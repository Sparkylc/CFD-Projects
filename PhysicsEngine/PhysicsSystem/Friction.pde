public class Friction implements ForceRegistry {

  private Rigidbody rigidbody;
  private float u; //coefficient of friction

  @Override
  public PVector getForce(Rigidbody rigidbody, PVector position) {
    this.rigidbody = rigidbody;

    PVector friction;
    PVector rigidbodyVelocity = rigidbody.getVelocity().copy();
    rigidbodyVelocity.normalize();

    //TODO: Implement a function which calculates the normal force on
    //whatever the current rigidbody is, by using which objects it is currently
    //collided with, the angle they are collided at
    //etc. For now, this will just be equal to the mass of the object
    
    float normalForce = rigidbody.getMass();
    friction = rigidbodyVelocity.mult(-1 * u * normalForce);
    return friction;
  }

  @Override
  public void draw(){
    //do nothing
  }

  public void setCoefficientOfFriction(float u){
    this.u = u;
  }
}