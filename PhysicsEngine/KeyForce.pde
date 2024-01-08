
public class KeyForce implements ForceRegistry {
    private Rigidbody rigidbody;
  @Override
  public PVector getForce(Rigidbody rigidbody, PVector position) {
    this.rigidbody = rigidbody;
    PVector force = new PVector(0, 0);

    if (keyPressed) {
      if (key == 'w') {
        force.add(new PVector(0, -20));
      }
      if (key == 's') {
        force.add(new PVector(0, 20));
      }
      if (key == 'a') {
        force.add(new PVector(-20, 0));
      }
      if (key == 'd') {
        force.add(new PVector(20, 0));
      }
    }
    return force;
  }
  @Override
  public void draw() {
    // do nothing
  }
  @Override
public PVector getApplicationPoint() {
    return rigidbody.getPosition().copy();
 }
}