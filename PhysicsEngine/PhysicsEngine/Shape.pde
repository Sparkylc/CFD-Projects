public class Shape {
  Rigidbody rigidbody;

  public Shape(Rigidbody rigidbody) {
    this.rigidbody = rigidbody;
  }

  public void draw() {
    if(rigidbody.getShapeType() == ShapeType.CIRCLE){
        drawCircle(rigidbody.getPosition(), rigidbody.getRadius(), rigidbody.getStrokeWeight(), rigidbody.getFillColour(), rigidbody.getStrokeColour());
    }
    if(rigidbody.getShapeType() == ShapeType.BOX){
        drawBox(rigidbody.getPosition(), rigidbody.getWidth(), rigidbody.getHeight(), rigidbody.getStrokeWeight(), rigidbody.getFillColour(), rigidbody.getStrokeColour());
   }
  }

  public void drawCircle(PVector position, float radius, float strokeWeight, PVector fillColour, 
                         PVector strokeColour) {

    float diameter = radius * 2.0f;
    fill(fillColour.x, fillColour.y, fillColour.z);
    stroke(strokeColour.x, strokeColour.y, strokeColour.z);
    strokeWeight(strokeWeight);
    ellipseMode(CENTER);
    ellipse(position.x, position.y,  diameter,  diameter);
  }

  public void drawBox(PVector position, float width, float height, float strokeWeight, 
                      PVector fillColour, PVector strokeColour) {
                        
    fill(fillColour.x, fillColour.y, fillColour.z);
    stroke(strokeColour.x, strokeColour.y, strokeColour.z);
    strokeWeight(strokeWeight);
    rectMode(CENTER);
    rect(position.x, position.y, width, height);
  }
}