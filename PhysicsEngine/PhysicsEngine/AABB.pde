public class AABB {
  private final PVector Min;
  private final PVector Max;

  public AABB(PVector min, PVector max) {
    this.Min = min;
    this.Max = max;
  }

  public AABB(float minX, float minY, float maxX, float maxY) {
    this.Min = new PVector(minX, maxY);
    this.Max = new PVector(maxX, maxY);
  }

/*
====================================================================================================
==============================================GETTERS & SETTERS=====================================
====================================================================================================
*/
  public PVector getMin() {
    return Min;
  }

  public PVector getMax() {
    return Max;
  }

}