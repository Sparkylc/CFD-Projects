public class Shape {
  
  public Shape() {
  }
  
  public void draw() {
    background(BACKGROUND_COLOUR.x, BACKGROUND_COLOUR.y, BACKGROUND_COLOUR.z);
    drawRigidbodies();
    drawAABB(); //DONT REMOVE THIS, IT BREAKS SOMETHING
  /*---------------------------------Collision Point Debugging--------------------------------------*/
    drawCollisionPoints();
  /*-----------------------------------------------------------------------------------------------*/
  drawForces();
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
                      rigidbody.getAngle(), rigidbody.getStrokeWeight(), rigidbody.getFillColour(),
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
  public void drawCircle(PVector position, float radius, float angle, float strokeWeight, PVector fillColour,
    PVector strokeColour) {
    
    float diameter = radius * 2.0f;
    fill(fillColour.x, fillColour.y, fillColour.z);
    stroke(strokeColour.x, strokeColour.y, strokeColour.z);
    strokeWeight(strokeWeight);
    ellipseMode(CENTER);
    ellipse(position.x, position.y,  diameter,  diameter);

    PVector va = new PVector();
    PVector vb = new  PVector(radius, 0);
    va = PhysEngMath.Transform(va, position, angle);
    vb = PhysEngMath.Transform(vb, position, angle);
    line(va.x, va.y, vb.x, vb.y);
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

/*-----------------------------------------------------------------------------------------------*/
public void drawForces() {
    for(Rigidbody rigidbody : rigidbodyList) {
        for(ForceRegistry force : rigidbody.getForceRegistry()) {
            force.draw();
        }
    }
}
/*---------------------------------Collision Point Debugging--------------------------------------*/
  public void drawCollisionPoints() {
      for(PVector point : pointsOfContactList) {
        stroke(0, 0, 0);
        strokeWeight(0.1f);
        noFill();
        rectMode(CENTER);
        rect(point.x, point.y, 1, 1);
      }
        pointsOfContactList.clear();
    }

  
/*-----------------------------------------------------------------------------------------------*/


}