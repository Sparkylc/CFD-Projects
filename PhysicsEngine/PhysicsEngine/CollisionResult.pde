public class CollisionResult {
 
  private boolean IsColliding;
  private PVector Normal;
  private float Depth;
  
  
  
  public CollisionResult(boolean isColliding, PVector normal, float depth) {
    this.IsColliding = isColliding;
    this.Normal = normal;
    this.Depth = depth;
  }
  
  public boolean getIsColliding() {
    return IsColliding;
  }
  public PVector getNormal() {
    return Normal;
  }
  public float getDepth() {
    return Depth;
  }

  public void setIsColliding(boolean isColliding) {
    this.IsColliding = isColliding;
  }

  public void setNormal(PVector normal) {
    this.Normal = normal;
  }

  public void setDepth(float depth) {
    this.Depth = depth;
  }
}