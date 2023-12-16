import java.math.BigDecimal;

float framesPerSecond = 60;
float metersPerPixel = 1;

 int screenWidth = 1720;
 int screenHeight = 880; 

//float dt = 1/(metersPerPixel*framesPerSecond);

float dt = 0.01;
Simulation simulation = new Simulation();

void setup() {
  size(1720, 880);
  frameRate(framesPerSecond);

}

void mouseClicked(){
  //creates a new object at the mouses current coordinaes
  PVector pos = new PVector(mouseX, mouseY);
   PVector vel = new PVector(30, 50);
  PVector acc = new PVector(30, 50);
  
  simulation.addNewBody(new Body(pos, acc, 50,50));

}

void draw() {
    background(0);
    simulation.display();
    simulation.updateVectors();

    

 }
 
 
