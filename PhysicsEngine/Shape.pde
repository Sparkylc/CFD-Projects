public class Shape {
  
  public Shape() {
  }
  
  public void draw() {
    background(BACKGROUND_COLOUR.x, BACKGROUND_COLOUR.y, BACKGROUND_COLOUR.z);
    drawRigidbodies();
    drawAABB();
  /*---------------------------------Collision Point Debugging--------------------------------------
    drawCollisionPoints();
  -----------------------------------------------------------------------------------------------*/
  }

/*
====================================================================================================
==================================-=== Drawing Methods =============================================
====================================================================================================
*/
  public void drawRigidbodies() {
    for(int body = 0; body < rigidbodyList.size(); body++) {

      Rigidbody rigidbody = rigidbodyList.get(body);
        if(rigidbody.getIsVisible()) {
          
          if (rigidbody.getShapeType() == ShapeType.CIRCLE) {
            drawCircle(rigidbody.getPosition(), rigidbody.getRadius(),
                       rigidbody.getStrokeWeight(), rigidbody.getFillColour(),
                       rigidbody.getStrokeColour());
          }

          if (rigidbody.getShapeType() == ShapeType.BOX) {
            drawPolygon(rigidbody.getPosition(), rigidbody.GetTransformedVertices(),
                        rigidbody.getStrokeWeight(), rigidbody.getFillColour(),
                        rigidbody.getStrokeColour());
          }
        }
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
  
  public void drawBox(PVector position, float width, float height, float angle, float strokeWeight,
    PVector fillColour, PVector strokeColour) {
    
    fill(fillColour.x, fillColour.y, fillColour.z);
    stroke(strokeColour.x, strokeColour.y, strokeColour.z);
    strokeWeight(strokeWeight);
    rectMode(CENTER);
    pushMatrix();
    rect(position.x, position.y, width, height);
    popMatrix();
  }
  
  public void drawPolygon(PVector position, PVector[] transformedVertices, float strokeWeight,
    PVector fillColour, PVector strokeColour) {
    
    fill(fillColour.x, fillColour.y, fillColour.z);
    stroke(strokeColour.x, strokeColour.y, strokeColour.z);
    strokeWeight(strokeWeight);
    beginShape();
    for (PVector transformedVertex : transformedVertices) {
      vertex(transformedVertex.x, transformedVertex.y);
    }
    endShape(CLOSE);
  }

  public void drawAABB() {
    for(Rigidbody rigidbody : rigidbodyList) {
      if(rigidbody.getIsVisible()) {
        AABB aabb = rigidbody.GetAABB();
        rectMode(CORNERS);
        //stroke(255, 0, 0);
        noStroke();
        noFill();
        rect(aabb.getMin().x, aabb.getMin().y, aabb.getMax().x, aabb.getMax().y);
      }
    }
  }
/*---------------------------------Collision Point Debugging--------------------------------------
  public void drawCollisionPoints() {
    if(showCollisionPoints) {
      for(PVector point : pointsOfContact) {
        stroke(0, 0, 0);
        strokeWeight(0.1f);
        noFill();
        rectMode(CENTER);
        rect(point.x, point.y, 1, 1);
      }
    }
  }
-----------------------------------------------------------------------------------------------*/


}