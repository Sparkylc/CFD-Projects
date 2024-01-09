public class Rod implements ForceRegistry {

    private float length = 1f;
    private float stiffness = 2f;
    private float damping = 100f;

    private PVector localAnchorA;
    private PVector localAnchorB;
    
    private boolean isHingeable = false;

    private Rigidbody rigidbodyA;
    private Rigidbody rigidbodyB;

    public Rod(Rigidbody rigidbodyA, Rigidbody rigidbodyB, PVector localAnchorA, PVector localAnchorB) {

        this.rigidbodyA = rigidbodyA;
        this.rigidbodyB = rigidbodyB;

        this.localAnchorA = localAnchorA;
        this.localAnchorB = localAnchorB;
    }


    @Override
public PVector getForce(Rigidbody rigidbody, PVector position) {

    PVector direction = PVector.sub(getApplicationPoint(rigidbodyB, rigidbodyB.getPosition()), position);

    if(!this.isHingeable) {
    float rodAngle = PApplet.atan2(direction.y, direction.x);
    float angleDifference = rigidbody.getAngle() - rodAngle;
    rigidbody.setAngle(rigidbody.getAngle() - angleDifference);
    }

    float currentLength = direction.mag();
    float lengthDifference = length - currentLength;
    direction.normalize();

    PVector force = PVector.mult(direction, -lengthDifference * stiffness * 1000);

    /*-------------------DAMPING-------------------*/
    PVector relativeVelocity = PVector.sub(rigidbodyB.getVelocity(), rigidbodyA.getVelocity());
    float rodVelocity = PVector.dot(relativeVelocity, direction);
    float dampingForceMagnitude = rodVelocity * damping;
    PVector dampingForce = PVector.mult(direction, dampingForceMagnitude);
    force.add(dampingForce);
    /*----------------------------------------------*/
    //(This dampening basically finds the relative velocity, checks how much of it is in the
    //direction of the rod, and then applies a force in the opposite direction of the rod to
    //slow it down.)


    return force;
}

@Override
public void draw() {
    PVector worldAnchorA = getApplicationPoint(rigidbodyA, rigidbodyA.getPosition());
    PVector worldAnchorB = getApplicationPoint(rigidbodyB, rigidbodyB.getPosition());

    strokeWeight(0.15);
    stroke(0);
    line(worldAnchorA.x, worldAnchorA.y, worldAnchorB.x, worldAnchorB.y);
    strokeWeight(0.1);
    stroke(255);
    line(worldAnchorA.x, worldAnchorA.y, worldAnchorB.x, worldAnchorB.y);
}


@Override
public PVector getApplicationPoint(Rigidbody rigidbody, PVector position) {
    
    PVector transformedAnchor = PhysEngMath.Transform(localAnchorA, position, rigidbodyA.getAngle());
    
    return transformedAnchor;
    }

public void setLength(float length) {
    this.length = length;
  }

public void setIsHingable(boolean isHingeable) {
    this.isHingeable = isHingeable;
  }

}

  
