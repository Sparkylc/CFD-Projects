
public class RigidBody2D {
  private PVector position = new PVector();
  private float rotation = 0.0f;
  private float mass = 0.0f;
  private float inverseMass = 0.0f;

  private PVector forceAccum = new PVector();
  private PVector linearVelocity = new PVector();
  private float angularVelocity = 0.0f;
  private float linearDamping = 0.0f;
  private float angularDamping = 0.0f;

  private boolean fixedRotation = false;

  public PVector getPosition() {
    return position;
  }

  public void physicsUpdate(float dt) {
      if (mass == 0.0f){
        return;
      }

      //calculate linear velocity
      //TODO: IMPLEMENT RK4 FOR THIS
      PVector acceleration = PVector.mult(forceAccum, this.inverseMass);
      linearVelocity.add(PVector.mult(acceleration, dt));
       
       //update linear position
       this.position.add(PVector.mult(linearVelocity, dt));
       syncCollisionTransforms();
       clearAccumulators();
  }

  public void syncCollisionTransforms() {

  }
  public void clearAccumulators() {
    this.forceAccum.set(0,0);
  }

  public void setTransform(PVector position, float rotation) {
    this.position.set(position);
    this.rotation = rotation;
  }
  public void setTransform(PVector position) {
    this.position.set(position);
  }

  public float getRotation() {
    return rotation;
  }

  public float getMass() {
    return mass;
  }

  public void setMass(float mass) {
    this.mass = mass;
    if(this.mass != 0.0f) {
      this.inverseMass = 1.0f / this.mass;
    } 
  }

  public void addForce(PVector force) {
    this.forceAccum.add(force);
  }




}