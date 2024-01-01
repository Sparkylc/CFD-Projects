public class RigidbodySpring implements ForceRegistry {
  private Rigidbody rigidbody;
  private PVector anchorPoint = new PVector(0,0);

  private float equilibriumLength; //Equilibrium length is a percentage of the total magnitude of the length, which for now will be 0.5f percent
  private float springLength;
  private float springConstant;


  @Override
  public PVector getForce(Rigidbody rigidbody, PVector position) {
    this.rigidbody = rigidbody;

    PVector direction = PVector.sub(position, anchorPoint);
    float currentLength = direction.mag();
    equilibriumLength = springLength * 0.5f;
    float displacement = currentLength - equilibriumLength;
    direction.normalize();
    return PVector.mult(direction, -springConstant * displacement);
  }
  

  @Override
  public void draw() {
  PVector direction = PVector.sub(rigidbody.getPosition().copy(), anchorPoint);
  float length = direction.mag();
  direction.normalize();

  float segments = 10;
  float segmentLength = length / segments;

  // Set the offset to a constant value
  float offsetMagnitude = 20; // Adjust this value to change the size of the zigzags

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
    } else {
      offset1 = PVector.mult(new PVector(direction.y, -direction.x), offsetMagnitude);
      offset2 = PVector.mult(new PVector(-direction.y, direction.x), offsetMagnitude);
    }

    // Add the offsets to the midpoint
    PVector midPoint1 = PVector.add(midPoint, offset1);
    PVector midPoint2 = PVector.add(midPoint, offset2);

    // Draw the lines
    strokeWeight(5);
    stroke(255);
    line(segmentStart.x, segmentStart.y, midPoint1.x, midPoint1.y);
    line(midPoint1.x, midPoint1.y, segmentEnd.x, segmentEnd.y);
    line(segmentStart.x, segmentStart.y, midPoint2.x, midPoint2.y);
    line(midPoint2.x, midPoint2.y, segmentEnd.x, segmentEnd.y);
  }
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
}
