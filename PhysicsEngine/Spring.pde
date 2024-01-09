public class Spring implements ForceRegistry {

  private Rigidbody rigidbodyA;
  private Rigidbody rigidbodyB;

  private PVector anchorPoint;
  private PVector localAnchorA;
  private PVector localAnchorB;

  private float equilibriumLength = 0.5f; //Equilibrium length is a percentage of the total magnitude of the length, which for now will be 0.5f percent
  private float springLength = 1;
  private float springConstant = 5;

  private boolean isHingeable;
  private boolean isTwoBodySpring;

  private float initialRotationA;
  private float initialRotationB;



public Spring(Rigidbody rigidbody, PVector localAnchorA, PVector anchorPoint) {

    this.rigidbodyA = rigidbody;
    this.localAnchorA = localAnchorA;
    this.anchorPoint = anchorPoint;
    this.isTwoBodySpring = false;
    this.isHingeable = false;
}

 public Spring(Rigidbody rigidbodyA, Rigidbody rigidbodyB, PVector localAnchorA, PVector localAnchorB) {

    this.rigidbodyA = rigidbodyA;
    this.rigidbodyB = rigidbodyB;

    this.localAnchorA = localAnchorA;
    this.localAnchorB = localAnchorB;

    this.isTwoBodySpring = true;
    this.isHingeable = false;
 }

  @Override
  public PVector getForce(Rigidbody rigidbody, PVector position) {

    PVector direction;
    PVector worldAnchorA;
    PVector worldAnchorB;

    if(isTwoBodySpring) {
        worldAnchorA = PhysEngMath.Transform(localAnchorA, position, rigidbodyA.getAngle());
        worldAnchorB = PhysEngMath.Transform(localAnchorB, rigidbodyB.getPosition(), rigidbodyB.getAngle());
        direction = PVector.sub(worldAnchorB, worldAnchorA);
    } else {
        worldAnchorA = PhysEngMath.Transform(localAnchorA, position, rigidbodyA.getAngle());
        worldAnchorB = anchorPoint;
        direction = PVector.sub(worldAnchorB, worldAnchorA);
    }

    if(!this.isHingeable) {
        float rodAngle = PApplet.atan2(direction.y, direction.x);
        float angleDifference = rigidbodyA.getAngle() - rodAngle;
        rigidbodyA.setAngle(rigidbodyA.getAngle() - angleDifference);
    }

    float currentLength = direction.mag();
    direction.normalize();

    float equilibrium = springLength * equilibriumLength;
    float displacement = currentLength - equilibriumLength;

    return PVector.mult(direction, springConstant * displacement);
  }
  

//TODO: IMPLEMENT A WAY TO MAKE THE SPRING SCALE WITH ITS LENGTH, SO THAT VISUALLY A LARGE SPRING
//WILL HAVE THICKER LINES, AND MORE OFFSET, ETC
  @Override
  public void draw() {
    PVector anchorA;
    PVector anchorB;

  if(isTwoBodySpring) {
    anchorA = PhysEngMath.Transform(localAnchorA, rigidbodyA.getPosition(), rigidbodyA.getAngle());
    anchorB = PhysEngMath.Transform(localAnchorB, rigidbodyB.getPosition(), rigidbodyB.getAngle());
  } else {

    anchorA = PhysEngMath.Transform(localAnchorA, rigidbodyA.getPosition(), rigidbodyA.getAngle());
    anchorB = anchorPoint;
  }

  fill(255);

  PVector direction = PVector.sub(anchorA, anchorB);
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
line(anchorA.x, anchorA.y, anchorB.x, anchorB.y);
stroke(255); // White
strokeWeight(0.1);
line(anchorA.x, anchorA.y, anchorB.x, anchorB.y);

for(int i = 0; i < segments; i++) {
    PVector segmentStart = PVector.add(anchorB, PVector.mult(direction, segmentLength * i));
    PVector segmentEnd = PVector.add(anchorB, PVector.mult(direction, segmentLength * (i + 1)));

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
public PVector getApplicationPoint(Rigidbody rigidbody, PVector position) {
    return PhysEngMath.Transform(localAnchorA, position, rigidbody.getAngle());
    }

public void setIsHingeable(boolean isHingeable) {
    this.isHingeable = isHingeable;
}
 }


