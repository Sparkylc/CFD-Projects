public class RaycastResult {
  private PVector point;
  private PVector normal;
  private float t;
  private boolean hit;

  public RaycastResult(){
    this.point = new PVector();
    this.normal = new PVector();
    this.t = -1;
    this.hit = false;
  }


  public void init(PVector point, PVector normal, float t, boolean hit){
    this.point.set(point);
    this.normal.set(normal);
    this.t = t;
    this.hit = hit; 
  }

  public static void reset(RaycastResult result){
    if(result != null) {
      result.point.zero();
      result.normal.set(0,0);
      result.t = -1;
      result.hit = false;
    }
  }
} 