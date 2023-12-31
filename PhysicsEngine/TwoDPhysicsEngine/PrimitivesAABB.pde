//Axis-Aligned Bounding Box
public class AABB{
  private PVector size = new PVector();
  private PVector halfSize = new PVector();
  private RigidBody2D rigidBody = null;


  public AABB(){

    this.halfSize = PVector.mult(this.size, 0.5f); 
  }
  //calculates using the bottom left corner and the top right corner  
  public AABB(PVector min, PVector max){
    //finds the width and height
    this.size = PVector.sub(max, min);
    this.halfSize = PVector.mult(this.size, 0.5f);
  }

  //BOTH ASSUME THAT POSITION IS AT THE CENTER
  public PVector getMin() {
    return PVector.sub(this.rigidBody.getPosition(), this.halfSize);
  }

  public PVector getMax() {
    return PVector.add(this.rigidBody.getPosition(), this.halfSize);

  }

  public void setRigidBody(RigidBody2D rigidBody){
    this.rigidBody = rigidBody;
  }

  public void setSize(PVector size){
    this.size.set(size);
    this.halfSize.set(size.x / 2.0f, size.y / 2.0f);
  }
}