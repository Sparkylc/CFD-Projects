
Rigidbody rigidbody = new Rigidbody(new PVector(500, 500), new PVector(5,5), new Integrator());
void setup(){
  size(1000, 1000);
  frameRate(200);
  rigidbody.addForce(new Friction());
  rigidbody.addForce(new FollowMouse());
}

void draw(){
  background(0);
  MouseEvent.mouseX = mouseX;
  MouseEvent.mouseY = mouseY;
  rigidbody.draw();
  

}