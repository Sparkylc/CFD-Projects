public class Ray2D {
  private PVector origin;
  //assuming direction is normalized
  private PVector direction;

  public Ray2D(PVector origin, PVector direction) {
    this.origin = origin;
    this.direction = direction;
    this.direction.normalize();
  }


  public PVector getOrigin() {
    return origin;
  }

  public PVector getDirection() {
    return direction;
  }
}