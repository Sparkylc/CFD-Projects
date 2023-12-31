public class Rope implements ForceRegistry {
    private PVector origin = new PVector(500, 500);
    private float length;
    private Rigidbody rigidbody;
    private float rigidity;
    private float ROPE_RIGIDITY_MULTIPLIER;
    private float ROPE_DAMPENING_MULTIPLIER;

public PVector getForce(Rigidbody rigidbody, PVector position) {
    return null;
}
    public void draw(){
      PVector start = origin.copy();
      PVector end = rigidbody.getPosition().copy();
      strokeWeight(5);
      stroke(255);
      line(start.x, start.y, end.x, end.y);
    }


  public void setLength(float length){
    this.length = length;
  }
  public void setOrigin(PVector origin){
    this.origin = origin;
  }

  public void setRigidity(float rigidity){
    this.rigidity = rigidity;
  }

  public void setRopeRigidityMultiplier(float ropeRigidityMultiplier){
    this.ROPE_RIGIDITY_MULTIPLIER = ropeRigidityMultiplier;
  }

  public void setRopeDampeningMultiplier(float ropeDampeningMultiplier){
    this.ROPE_DAMPENING_MULTIPLIER = ropeDampeningMultiplier;
  }

}
