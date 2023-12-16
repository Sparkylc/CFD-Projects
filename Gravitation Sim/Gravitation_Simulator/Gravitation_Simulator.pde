import java.math.BigDecimal;

float framesPerSecond = 60;
float metersPerPixel = 10;

//float dt = 1/(metersPerPixel*framesPerSecond);

float dt = 0.01;
Simulation simulation = new Simulation();

void setup() {
  size(1920,1080);
  frameRate(framesPerSecond);

}

void mouseClicked(){
  //creates a new object at the mouses current coordinaes
  PVector pos = new PVector(mouseX, mouseY);
  PVector vel = new PVector((ceil(random(50,100))), ceil(random(50,100)));
  PVector acc = new PVector(0, 0);
  
  simulation.addNewBody(new Body(pos, vel, acc, ceil(random(100,100)),200));

}

void draw() {
    background(0);
    simulation.display();
    simulation.updateVectors();

    

 }
 
 
