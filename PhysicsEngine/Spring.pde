public class Spring implements ForceRegistry {

  private Rigidbody rigidbody;
  private PVector anchorPoint = new PVector(0,0);
  private Rigidbody springRigidbody;

  private float equilibriumLength = 0.5f; //Equilibrium length is a percentage of the total magnitude of the length, which for now will be 0.5f percent
  private float springLength = 10;
  private float springConstant = 5;
  private boolean isConnectedToSpring = false;

 public Spring(Rigidbody rigidbody) {
    this.rigidbody = rigidbody;
 }
  @Override
  public PVector getForce(Rigidbody rigidbody, PVector position) {

    if(isConnectedToSpring) {
      anchorPoint = springRigidbody.getPosition();
    }
    PVector direction = PVector.sub(position, anchorPoint);
    float currentLength = direction.mag();
    equilibriumLength = springLength * 0.5f;
    float displacement = currentLength - equilibriumLength;
    direction.normalize();
    return PVector.mult(direction, -springConstant * displacement);
  }
  

//TODO: IMPLEMENT A WAY TO MAKE THE SPRING SCALE WITH ITS LENGTH, SO THAT VISUALLY A LARGE SPRING
//WILL HAVE THICKER LINES, AND MORE OFFSET, ETC
  @Override
  public void draw() {

  ellipseMode(CENTER);
  fill(255);
  ellipse(rigidbody.getPosition().x, rigidbody.getPosition().y, 0.1, 0.1);
  ellipse(anchorPoint.x, anchorPoint.y, 0.1, 0.1);
  PVector direction = PVector.sub(rigidbody.getPosition().copy(), anchorPoint);
  float length = direction.mag();
  direction.normalize();

  float segments = 10;
  float segmentLength = length / segments;

  // Set the offset to a constant value
  float offsetMagnitude = 0.5; // Adjust this value to change the size of the zigzags

// Set the colors for the front and back lines
color frontColor = color(100, 100, 100); // Black
color backColor = color(255, 255, 255); // Light gray

// Draw the rod
strokeWeight(0.3);
stroke(0); // Black
line(anchorPoint.x, anchorPoint.y, rigidbody.getPosition().x, rigidbody.getPosition().y);
stroke(255); // White
strokeWeight(0.1);
line(anchorPoint.x, anchorPoint.y, rigidbody.getPosition().x, rigidbody.getPosition().y);

for(int i = 0; i < segments; i++) {
    PVector segmentStart = PVector.add(anchorPoint, PVector.mult(direction, segmentLength * i));
    PVector segmentEnd = PVector.add(anchorPoint, PVector.mult(direction, segmentLength * (i + 1)));

    // Calculate the midpoint of the segment
    PVector midPoint = PVector.lerp(segmentStart, segmentEnd, 0.5f);

    // Alternate the offset direction to give appearance of spring
    PVector offset1, offset2;
    if(i % 2 == 0) {
      offset1 = PVector.mult(new PVector(-direction.y, direction.x), offsetMagnitude);
      offset2 = PVector.mult(new PVector(direction.y, -direction.x), offsetMagnitude);
      stroke(backColor); // Set the color to backColor
    } else {
      offset1 = PVector.mult(new PVector(direction.y, -direction.x), offsetMagnitude);
      offset2 = PVector.mult(new PVector(-direction.y, direction.x), offsetMagnitude);
      stroke(frontColor); // Set the color to frontColor
    }

    // Add the offsets to the midpoint
    PVector midPoint1 = PVector.add(midPoint, offset1);
    PVector midPoint2 = PVector.add(midPoint, offset2);

    // Draw the lines
    strokeWeight(0.2);
    stroke(0);
    line(segmentStart.x, segmentStart.y, midPoint1.x, midPoint1.y);
    line(midPoint1.x, midPoint1.y, segmentEnd.x, segmentEnd.y);
    line(segmentStart.x, segmentStart.y, midPoint2.x, midPoint2.y);
    line(midPoint2.x, midPoint2.y, segmentEnd.x, segmentEnd.y);
    strokeWeight(0.1);
    stroke(255);
    line(segmentStart.x, segmentStart.y, midPoint1.x, midPoint1.y);
    line(midPoint1.x, midPoint1.y, segmentEnd.x, segmentEnd.y);
    line(segmentStart.x, segmentStart.y, midPoint2.x, midPoint2.y);
    line(midPoint2.x, midPoint2.y, segmentEnd.x, segmentEnd.y);

    
  }
  
}

@Override
public PVector getApplicationPoint() {
    return rigidbody.getPosition().copy();
 }


  public void setSpringConstant(float springConstant) {
    this.springConstant = springConstant;
  }

  public void setSpringAnchor(PVector anchorPoint) {
    this.anchorPoint = anchorPoint;
  }

  public void setSpringAnchor(Rigidbody rigidbody) {
    this.anchorPoint = rigidbody.getPosition();
  }

  public void setSpringLength(float springLength) {
    this.springLength = springLength;
  }

  public void setConnectedToSpring(boolean isConnectedToSpring) {
    this.isConnectedToSpring = isConnectedToSpring;
  }

  public void setAnchorRigidBody(Rigidbody rigidbody) {
    this.springRigidbody = rigidbody;
  }


}
