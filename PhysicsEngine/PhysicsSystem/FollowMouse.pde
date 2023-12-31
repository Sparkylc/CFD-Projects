public class FollowMouse implements ForceRegistry {

  @Override
  public PVector getForce(Rigidbody rigidbody, PVector position) {
    PVector mouse = new PVector(MouseEvent.mouseX, MouseEvent.mouseY);
    PVector rigidbodyPosition = rigidbody.getPosition().copy();
    PVector direction = PVector.sub(mouse, position);
    direction.normalize();
    direction.mult(0.5f);
    PVector force = PVector.mult(direction, rigidbody.getMass());
    return force;
  }
}