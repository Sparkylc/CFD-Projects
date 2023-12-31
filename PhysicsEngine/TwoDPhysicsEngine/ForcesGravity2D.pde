public class Gravity2D implements ForceGenerator {

  private PVector gravity;
  private PVector position;

  public Gravity2D(PVector force) {
    gravity.set(force.copy());
  }
  
  @Override
  public void updateForce(RigidBody2D rigidBody, float dt) {
      rigidBody.addForce(PVector.mult(gravity, rigidBody.getMass()));

  }
}
