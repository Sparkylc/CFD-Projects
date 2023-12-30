//same as Box2D
public class OBB {
  private PVector size = new PVector();
  private PVector halfSize = new PVector();
  private RigidBody rigidBody = null;

  
  public Box2D(){
    this.halfSize = PVector.mult(this.size, 0.5f); 
  }
  //calculates using the bottom left corner and the top right corner  
  public Box2D(PVector min, PVector max){
    //finds the width and height
    this.size = PVector.sub(max, min);
    this.halfSize = PVector.mult(this.size, 0.5f);
  }

  //THIS NEEDS TO BE UPDATED LATER
  public PVector getMin() {
    return PVector.sub(this.rigidBody.getPosition(), this.halfSize);
  }

  public PVector getMax() {
    return PVector.add(this.rigidBody.getPosition(), this.halfSize);

  }

  public PVecor[] getVertices() {
    PVector min = getMin();
    PVector max = getMax();
    PVector[] vertices = {
      new PVector(min.x, min.y), //bottom left
      new PVector(max.x, min.y), //bottom right
      new PVector(max.x, max.y), //top right
      new PVector(min.x, max.y)  //top left
      };

      if(rigidBody.getRotation() != 0.0f){
        //TODO: IMPLEMENT ME
        //Rotates point(PVector) about center (PVector) by rotation (float in rad)
          for(PVector vertex : vertices) {
              //Translate.rotate(vertex, this.rigidBody.getPosition(), this.rigidBody.getRotation());
          }
      }

      return vertices; 
  }

  public RigidBody2D getRigidBody() {
    return this.rigidBody;
  }

  public PVector getHalfSize(){
    return this.halfSize;
  }
}