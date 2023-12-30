public class Line2D {
  private PVector start;
  private PVector end;
  private color colour;


  public Line2D(PVector start, PVector end, color colour) {
    this.start = start;
    this.end = end;
    this.colour = colour;
  }

  public PVector getStart() {
    return this.start;
  }

  public PVector getEnd() {
    return this.end;
  }

  public PVector setStart(PVector start){
    this.start = start;
  }

  public PVector setEnd(PVector end){
    this.end = end;
  }

  public PVector getColour(){
    return this.colour;
  }

  public PVector setColour(color colour){
    this.colour = colour;
  }

  public float magSquared() {
    return PVector.sub(start, end).magSq();
  }
}