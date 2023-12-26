
Integrator integrator;

PeasyCam cam;



void setup(){
    size(1000, 1000, P3D);
    frameRate(500);

    integrator = new Integrator();
    cam = new PeasyCam(this, 100);
    cam.setMinimumDistance(50);
    cam.setMaximumDistance(5000);
    
    integrator.addNewBody(new Body(new PVector(0, 0, 0), new PVector(50, 0, 0),  100, 50));
    integrator.addNewBody(new Body(new PVector(500, 500, 500), new PVector(20, -50, 10), 100, 50));
    integrator.addNewBody(new Body(new PVector(300, 300, 0), new PVector(0, -30, 0), 100, 50));
}

void draw(){
    background(0);
    directionalLight(126, 126, 126, 0, 0, -1);
    ambientLight(102, 102, 102);
    integrator.update();
    integrator.display();
    //System.out.println(integrator.bodies.get(0).velocity);

    
}