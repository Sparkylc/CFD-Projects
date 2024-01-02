public class RigidbodyRod implements ForceRegistry {
    private float length;
    private float stiffness;
    private PVector anchorPoint;
    private Rigidbody rigidbody;


    private Rigidbody anchorRigidbody;
    private boolean connectedToRigidbody;


    @Override
public PVector getForce(Rigidbody rigidbody, PVector position) {
    this.rigidbody = rigidbody;
    if(connectedToRigidbody){
        anchorPoint = anchorRigidbody.getPosition();
    }
    float rodLength = length;
    float rodStiffness = stiffness;

    PVector direction = PVector.sub(anchorPoint, position);
    float currentLength = direction.mag();
    direction.normalize();

    if (currentLength > rodLength) {
        // If the Rigidbody has moved beyond the length of the rod, pull it back with a very large force
        float lengthDifference = rodLength - currentLength;
        PVector force = direction.mult(-lengthDifference * rodStiffness * 1000);
        return force;
    } else {
        // If the Rigidbody is within the length of the rod, apply a spring force to keep it at the rod's length
        float lengthDifference = rodLength - currentLength;
        PVector force = direction.mult(-lengthDifference * rodStiffness * 1000);
        return force;
    }
}

@Override
public void draw() {
  strokeWeight(15);
  stroke(0);
  line(rigidbody.getPosition().x, rigidbody.getPosition().y, anchorPoint.x, anchorPoint.y);
  strokeWeight(10);
  stroke(255);
  line(rigidbody.getPosition().x, rigidbody.getPosition().y, anchorPoint.x, anchorPoint.y);
}

  public void setLength(float length) {
    this.length = length;
  }

  public void setAnchorPoint(PVector anchorPoint) {
    this.anchorPoint = anchorPoint;
  }

  public void setAnchorRigidbody(Rigidbody anchorRigidbody) {
    this.anchorRigidbody = anchorRigidbody;
  }

  public void setConnectedToRigidbody(boolean connectedToRigidbody) {
    this.connectedToRigidbody = connectedToRigidbody;
  }

  public void setStiffness(float stiffness) {
    this.stiffness = stiffness;
  }
  

}