


Simulation simulation;

void setup() {
  size(640,360);
  PVector p1, v1, a1, p2, v2, a2, p3, v3, a3;
  
  p1 = new PVector(50, 50);
  p2 = new PVector(90, 90);
  p3 = new PVector(100, 200);
  
  v1 = new PVector(10, 10);
  v2 = new PVector(10, 10);
  v3 = new PVector(10, 10);
  
  a1 = new PVector(0,0);
  a2 = new PVector(0,0);
  a3 = new PVector(0,0);
  
  Body body1 = new Body(p1, v1, a1, 10);
  Body body2 = new Body(p2, v2, a2, 10); 
  Body body3 = new Body(p3, v3, a3, 10);
  
  simulation = new Simulation(body1, body2, body3);
  
}


void draw(){
    background(0);
    
    simulation.updateVectors();
    simulation.display();
 }
 
 
