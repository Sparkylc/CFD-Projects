import java.lang.Math;
import queasycam.*;

QueasyCam cam;


int numberOfParticles = 1000;
float dt = 0.05;
float frictionHalfLife = 0.04;
float distanceMax = 5;
int numParticleTypes = 6;
float forceFactor = 30;
 
float spawnWidth = 500;
float spawnHeight = 500;
float spawnDepth = 500;
 
float maxSpawnVelocityX = 5;
float maxSpawnVelocityY = 5;
float maxSpawnVelocityZ = 5;

float frictionFactor = (float) Math.pow(0.5, dt / frictionHalfLife);

int[] colors = new int[numberOfParticles];

float[][] forceMatrix = new float[numParticleTypes][numParticleTypes];

//creates the position and velocity arrays for the particles
float[] positionsX = new float[numberOfParticles];
float[] positionsY = new float[numberOfParticles];
float[] positionsZ = new float[numberOfParticles];


float[] velocitiesX = new float[numberOfParticles];
float[] velocitiesY = new float[numberOfParticles];
float[] velocitiesZ = new float[numberOfParticles];





void initializeParticles(){
    for(int i = 0; i < numParticleTypes; i++){
    for (int j = 0; j < numParticleTypes; j++) {
            forceMatrix[i][j] = (float)random(-1, 1);
    }
    }
  for (int i = 0; i < numberOfParticles; i++) {
    colors[i] = (int)(Math.random()*numParticleTypes);

    positionsX[i] = random(spawnWidth);
    positionsY[i] = random(spawnHeight);
    positionsZ[i] = random(spawnDepth);
    velocitiesX[i] = random(30);
    velocitiesY[i] = random(30);
    velocitiesZ[i] = random(30);
    }
}


void updateParticles() {
    
    //update velocities
    for(int i = 0; i < numberOfParticles; i++) {

        float totalForceX = 0;
        float totalForceY = 0;
        float totalForceZ = 0;

        for(int j = 0; j < numberOfParticles; j++){

            float distanceX = positionsX[j] - positionsX[i];
            float distanceY = positionsY[j] - positionsY[i];
            float distanceZ = positionsZ[j] - positionsZ[i];

            float distance = (float)Math.sqrt(distanceX * distanceX + distanceY * distanceY + distanceZ * distanceZ);
            
            if(distance > 0 && distance < distanceMax){

                float force = force(distance/distanceMax, forceMatrix[colors[i]][colors[j]]);

                totalForceX += distanceX / distance * force;
                totalForceY += distanceY / distance * force;
                totalForceZ += distanceZ / distance * force;
            }
        }

        totalForceX *= distanceMax * forceFactor;
        totalForceY *= distanceMax * forceFactor;
        totalForceZ *= distanceMax * forceFactor;
        
        //velocitiesX[i] *= frictionFactor;
        //velocitiesY[i] *= frictionFactor;
        //velocitiesZ[i] *= frictionFactor;

        velocitiesX[i] += totalForceX * dt;
        velocitiesY[i] += totalForceY * dt;
        velocitiesZ[i] += totalForceZ * dt;
    }

    //update positions
    for(int i = 0; i < numberOfParticles; i++){
        positionsX[i] += velocitiesX[i] * dt;
        positionsY[i] += velocitiesY[i] * dt;
        positionsZ[i] += velocitiesZ[i] * dt;
    }
}

float force(float distance, float scaleFactor){

    float beta = 0.3;

    if(distance < beta){

        return distance / beta - 1;

    } else if (beta < distance && distance < 1){

        return scaleFactor * (1 - Math.abs(2 * distance - 1 - beta) / (1 - beta));

    } else{
        return 0;
    }
    }


void setup(){
    size(1000, 1000, P3D);
    cam = new QueasyCam(this);
    frameRate(240);
	cam.speed = 5;              // default is 3
	cam.sensitivity = 0.5;    
    noStroke();
    colorMode(HSB, 360, 100, 100);
    initializeParticles();
  
}

void draw(){
    //draws particles
        background(0);
    updateParticles();

    for(int i = 0; i < numberOfParticles; i++){
        pushMatrix();
        translate(positionsX[i], positionsY[i], positionsZ[i]);
        fill(colors[i] * 360 / numParticleTypes, 100, 50);
        sphere(5);
        popMatrix();
        
        
    }
}
