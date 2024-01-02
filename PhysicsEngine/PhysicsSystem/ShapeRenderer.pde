public class ShapeRenderer {
    private Rigidbody rigidBody;
    public ShapeRenderer(Rigidbody rigidBody){
        this.rigidBody = rigidBody;
    }
    public void render(){
      if(rigidbody.getShapeType().equals("circle")){
        this.drawCircle();
      }
      if(rigidbody.getShapeType().equals("square")){
        this.drawSquare();
      }
      if(rigidbody.getShapeType().equals("rectangle")){
        this.drawRectangle();
      }
      if(rigidbody.getShapeType().equals("triangle")){
        this.drawTriangle();
      }
      if(rigidbody.getShapeType().equals("spring")){
        this.drawSpring();
      }
      if(rigidbody.getShapeType().equals("line")){
        this.drawLine();
      }
      if(rigidbody.getShapeType().equals("polygon")){
        this.drawPolygon();
      }
    }

    private void drawCircle(){
      fill(255);
      ellipseMode(RADIUS);
      ellipse(rigidbody.getPosition().x, rigidbody.getPosition().y, rigidbody.getRadius(), rigidbody.getRadius());
    }

    private void drawSquare(){
      fill(255);
      rectMode(CENTER);
      rect(rigidbody.getX(), rigidbody.getY(), rigidbody.getWidth(), rigidbody.getHeight());
    }

    private void drawRectangle(){
      fill(255);
      rectMode(CENTER);
      rect(rigidbody.getX(), rigidbody.getY(), rigidbody.getWidth(), rigidbody.getHeight());
    }

    private void drawTriangle(){
    fill(255);
    PVector[]vertices = rigidbody.getVertices();
    triangle(vertices[0].x, vertices[0].y, vertices[1].x, vertices[1].y, vertices[2].x, vertices[2].y);
    }

    private void drawSpring(){

      ellipse(rigidbody.getStart().x, rigidbody.getStart().y, 10, 10);
      //TODO: IS ANCHOR POINT BETTER THAN GET START, CHECK NAMING CONVENTIONS AND PLAN HOW YOU WANT
      //TO DO THIS 
      PVector direction = PVector.sub(rigidbody.getPosition(), rigidbody.getStart());

      float length = direction.mag();
      direction.normalize();


      //MAKE THIS SOMEWHAT PROPORTIONAL TO SPRING CONSTANT
      float segments = 10;

      float segmentLength = length / segments;
      for(int i = 0; i < segments; i++) {
        PVector segmentStart = PVector.add(rigidbody.getStart(), PVector.mult(direction, segmentLength * i));
        PVector segmentEnd = PVector.add(rigidbody.getStart(), PVector.mult(direction, segmentLength * (i + 1)));
        //Alternate end points to give appearance of spring
        if(i % 2 == 0) {
          segmentEnd.add(PVector.mult(new PVector(-direction.y, direction.x), 10));
        } else {
          segmentEnd.add(PVector.mult(new PVector(direction.y, -direction.x), 10));
        }
        line(segmentStart.x, segmentStart.y, segmentEnd.x, segmentEnd.y);
      }

      ellipse(rigidbody.getPosition().x, rigidbody.getPosition().y, 10, 10);
    }

    private void drawLine(){
      fill(255);
      line(rigidbody.getStart().x, rigidbody.getStart().y, rigidbody.getEnd().x, rigidbody.getEnd().y);
    }


    //THIS IMPLEMENTATION IS UNTESTED, MAY NOT WORK
    private void drawPolygon(){
      PVector[]vertices = rigidbody.getVertices();
      beginShape();
      for(int i = 0; i < vertices.length; i++){
        vertex(vertices[i].x, vertices[i].y);
      }
      endShape(CLOSE);
    }

}