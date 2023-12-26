import queasycam.*;

QueasyCam cam;

final float dt = 0.02;
final float frictionHalfLife = 0.040;

//sets the friction factor
final float frictionFactor = (float)Math.pow(0.5, dt/frictionHalfLife);

final int forceScalingFactor = 100;
final float maximumDistance = 0.2;

final int numberOfParticles = 1000; 
final int initialWidth = 100;
final int initialHeight = 100;
final int initialDepth = 100;

final int numTypes = 6;
final int colorStep = 360/numTypes;

ArrayList<Particle> particles;
float forceMatrix[][];

Forces forces;

void setup(){
    size(1000, 1000, P3D);
    colorMode(HSB, 360, 100, 100);
    particles = new ArrayList<Particle>();
    forces = new Forces();

    cam = new QueasyCam(this);
	cam.speed = 5;              // default is 3
	cam.sensitivity = 0.5; 

    //creates 1000 random particles
    for(int i = 0; i < numberOfParticles; i++){
        particles.add(new Particle());
    }

}

void draw(){
    background(0);

    for(Particle p : particles){
        p.updateParticle();
        p.display();
    }
}