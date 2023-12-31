public class Friction implements ForceRegistry {
  
  @Override
  public PVector getForce(Rigidbody rigidbody, PVector position) {
    //frictional force is equal too
    //F_friction = -1 * u * |F_normal| * ^v^
    //where v is a unit vector of the velocity

    PVector friction;
    PVector rigidbodyVelocity = rigidbody.getVelocity().copy();
    rigidbodyVelocity.normalize();

    //TODO: Implement a function which calculates the normal force on
    //whatever the current rigidbody is, by using which objects it is currently
    //collided with, the angle they are collided at
    //etc. For now, this will just be equal to the mass of the object
    
    float normalForce = rigidbody.getMass();
    float u = 0.4f; //coefficient of friction
    friction = rigidbodyVelocity.mult(-1 * u * normalForce);
    return friction;
  }


}