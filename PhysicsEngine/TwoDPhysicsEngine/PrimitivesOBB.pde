//same as Box2D
public class OBB {
  private PVector size = new PVector();
  private PVector halfSize = new PVector();
  private RigidBody2D rigidBody = null;

  
  public OBB(){
    this.halfSize = PVector.mult(this.size, 0.5f); 
  }
  //calculates using the bottom left corner and the top right corner  
  public OBB(PVector min, PVector max){
    //finds the width and height
    this.size = PVector.sub(max, min);
    this.halfSize = PVector.mult(this.size, 0.5f);
  }

  //THIS NEEDS TO BE UPDATED LATER
  public PVector getLocalMin() {
    return PVector.sub(this.rigidBody.getPosition(), this.halfSize);
  }

  public PVector getLocalMax() {
    return PVector.add(this.rigidBody.getPosition(), this.halfSize);

  }

  public PVector[] getVertices() {
    PVector min = getLocalMin();
    PVector max = getLocalMax();
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
             PMath.rotate(vertex, this.rigidBody.getRotation(), this.rigidBody.getPosition());
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

  public void setRigidBody(RigidBody2D rigidBody){
    this.rigidBody = rigidBody;
  }

  public void setSize(PVector size){
    this.size.set(size);
    this.halfSize.set(size.x / 2.0f, size.y / 2.0f);
  }

  public void drawOBB(){
    PVector[] vertices = getVertices();
    line(vertices[0].x, vertices[0].y, vertices[1].x, vertices[1].y);
    line(vertices[1].x, vertices[1].y, vertices[2].x, vertices[2].y);
    line(vertices[2].x, vertices[2].y, vertices[3].x, vertices[3].y);
    line(vertices[3].x, vertices[3].y, vertices[0].x, vertices[0].y);
  }
}
