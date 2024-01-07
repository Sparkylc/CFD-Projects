public class Gravity implements ForceRegistry {
  private Rigidbody rigidbody;
  
  @Override
  public PVector getForce(Rigidbody rigidbody, PVector position) {\
    this.rigidbody = rigidbody;


    return PVector.mult(GRAVITY_VECTOR, rigidbody.getMass());
  }
  @Override
  public void draw() {
    // do nothing
  }
}