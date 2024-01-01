public class FollowMouse implements ForceRegistry {
  
  private Rigidbody rigidbody;

  @Override
  public PVector getForce(Rigidbody rigidbody, PVector position) {
    if(mousePressed) {
    this.rigidbody = rigidbody;
    PVector mouse = new PVector(MouseEvent.mouseX, MouseEvent.mouseY);
    PVector rigidbodyPosition = rigidbody.getPosition().copy();
    PVector direction = PVector.sub(mouse, position);
    direction.normalize();
    direction.mult(20);
    PVector force = PVector.mult(direction, rigidbody.getMass());
    return force;
    } else {
      return new PVector();
    }
  }

  @Override
  public void draw(){
    // do nothing
  }
}