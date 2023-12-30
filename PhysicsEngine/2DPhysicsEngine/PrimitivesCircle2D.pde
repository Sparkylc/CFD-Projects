public class Circle {
  private float radius;
  private RigidBody2D rigidBody = null;

  public Circle(float radius){
    this.radius = radius;
  }

  public float getRadius(){
    return this.radius;
  }

  public PVector getCenter(){
    return this.rigidBody.getPosition();
  }
}