import java.math.BigDecimal;
import controlP5.*;

float framesPerSecond = 60;
float metersPerPixel = 1;

int screenWidth = 1720;
int screenHeight = 880; 

PVector initialMousePosition;
PVector finalMousePosition;


//mouse booleans for mouse interactions
boolean mousePressed = false;
boolean mouseReleased = false;

//declares a user interface object
UserInterface userInterfaceController;;
ControlP5 userInterface;


//initializes the timestep size and the simulation object
float dt = 0.01;
Simulation simulation = new Simulation();

void setup() {
  size(1720, 880, OPENGL);
  frameRate(framesPerSecond);
  userInterface = new ControlP5(this);
  userInterfaceController = new UserInterface(userInterface);
}

void mousePressed(){
  //creates a new object at the mouses current coordinaes
  if(!userInterface.isMouseOver()){
  initialMousePosition = new PVector(mouseX, mouseY);
  mousePressed = true;
  mouseReleased = false;

  }
}

 void mouseReleased() {
  if(!userInterface.isMouseOver()){
  finalMousePosition = new PVector(mouseX, mouseY);
  float radius = userInterface.getController("Radius").getValue();
  float mass = userInterface.getController("Mass").getValue();
  Body body = new Body(finalMousePosition, new PVector(0,0), mass, radius);
  body.initialVelocity(initialMousePosition, finalMousePosition);
  simulation.addNewBody(body);
  mousePressed = false;
  mouseReleased = true;
  }


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
 
 
