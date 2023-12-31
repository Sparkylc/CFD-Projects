public class Gravity implements ForceRegistry {
  
  private Rigidbody rigidbody;
  private PVector gravity;
  
  @Override
  public PVector getForce(Rigidbody rigidbody, PVector position) {
    
    this.rigidbody = rigidbody;
    
    PVector force = PVector.mult(this.gravity, rigidbody.getMass());
    return force;
  }
  
  @Override
  public void draw() {
    // do nothing
  }
  
  public void setGravity(PVector gravity) {
    this.gravity = gravity;
  }
  
  
}