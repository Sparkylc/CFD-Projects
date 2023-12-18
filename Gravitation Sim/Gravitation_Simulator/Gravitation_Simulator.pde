import java.math.BigDecimal;

float framesPerSecond = 60;
float metersPerPixel = 1;

 int screenWidth = 1720;
 int screenHeight = 880; 

//float dt = 1/(metersPerPixel*framesPerSecond);

PVector initialMousePosition;
PVector finalMousePosition;

boolean mousePressed = false;
boolean mouseReleased = false;


float dt = 0.01;
Simulation simulation = new Simulation();

void setup() {
  size(1720, 880);
  frameRate(framesPerSecond);

}

void mousePressed(){
  //creates a new object at the mouses current coordinaes
  initialMousePosition = new PVector(mouseX, mouseY);
  mousePressed = true;
  mouseReleased = false;

}

 void mouseReleased() {
  finalMousePosition = new PVector(mouseX, mouseY);
  Body body = new Body(finalMousePosition, new PVector(0,0), 1500, random(50,100));
  body.initialVelocity(initialMousePosition, finalMousePosition);
  simulation.addNewBody(body);
  mousePressed = false;
  mouseReleased = true;


}

void draw() {
    background(0);
    simulation.display();
    simulation.updateVectors();
    simulation.updateBodies();
    PVector currentPosition = new PVector(mouseX, mouseY);
    if (mousePressed == true && mouseReleased == false ){
    
      stroke(200);

      line(initialMousePosition.x, initialMousePosition.y, mouseX, mouseY);
    }
    

 }
 
 
