public class Line2D {
  private PVector start;
  private PVector end;
  private color colour;


  public Line2D(PVector start, PVector end, color colour) {
    this.start = start.copy();
    this.end = end.copy();
    this.colour = colour;
  }

  public PVector getStart() {
    return this.start;
  }

  public PVector getEnd() {
    return this.end;
  }

  public void setStart(PVector start){
    this.start = start;
  }

  public void setEnd(PVector end){
    this.end = end;
  }

  public color getColour(){
    return this.colour;
  }

  public void setColour(color colour){
    this.colour = colour;
  }

  public float magSquared() {
    return PVector.sub(start, end).magSq();
  }
}
