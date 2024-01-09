public class RigidJoint implements ForceRegistry {

    private Rigidbody rigidbody;
    private Rigidbody anchorRigidBody;
    
    private float length;
    private float stiffness;

    private float threshold = 0.1f;

    private PVector thisAnchorPoint;
    private PVector anchorRigidbodyAnchorPoint; //Sets the position of the anchor point relative
                                                //to the anchor assuming zero rotation to begin wit
    
    public RigidJoint(Rigidbody rigidbody, Rigidbody anchorRigidbody, PVector thisAnchorPoint,
                      PVector anchorRigidbodyAnchorPoint, float length, float stiffness) {


        this.rigidbody = rigidbody;
        this.anchorRigidBody = anchorRigidbody;
        this.thisAnchorPoint = thisAnchorPoint;
        this.anchorRigidbodyAnchorPoint = anchorRigidbodyAnchorPoint;
        this.length = length;
        this.stiffness = stiffness;
    }


    @Override
    public PVector getForce(Rigidbody rigidbody, PVector position) {
         this.rigidbody = rigidbody;
         PVector direction = PVector.sub(this.getAnchorBodyAnchorPoint(),this.getThisAnchorPoint());
         float currentLength = direction.mag();
         direction.normalize();

    if (currentLength > length + threshold) {
        // If the Rigidbody has moved beyond the length of the rod, pull it back with a very large force
        float lengthDifference = length - currentLength;
        PVector force = direction.mult(-lengthDifference * stiffness * 1000);
        return force;
    } else if (currentLength < length - threshold) {
        // If the Rigidbody is within the length of the rod, apply a spring force to keep it at the rod's length
        float lengthDifference = length - currentLength;
        PVector force = direction.mult(lengthDifference * stiffness * 1000);
        return force;
    } else {
        return new PVector();
    }
    }
    @Override
    public void draw() {
        //draw a circle
    }

    @Override
    public PVector getApplicationPoint() {
        PVector transformedAnchorPoint = PhysEngMath.Transform(thisAnchorPoint, 
                                                               rigidbody.getPosition(), 
                                                               rigidbody.getAngle());
        return transformedAnchorPoint;
    }

    public PVector getThisAnchorPoint() {
        PVector transformedAnchorPoint = PhysEngMath.Transform(thisAnchorPoint,
                                                               rigidbody.getPosition(),
                                                               rigidbody.getAngle());
        return transformedAnchorPoint;
    }

    public PVector getAnchorBodyAnchorPoint() {
        PVector transformedAnchorPoint = PhysEngMath.Transform(anchorRigidbodyAnchorPoint, 
                                                               anchorRigidBody.getPosition(), 
                                                               anchorRigidBody.getAngle());
        return transformedAnchorPoint;
    }
}




