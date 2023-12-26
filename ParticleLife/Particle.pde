class Particle {
    //A particle has three properties, a color/type, a position, and a velocity
    //a particle is only affected by particles within 1 distance unit of it

    PVector position;
    PVector velocity;
    

    //the type acts as the matrix index for the force matrix
    int type;
    float mass;
    float radius;

    Particle(){
        position = new PVector(random(initialWidth), random(initialHeight), random(initialDepth));

        //can change this later to create particles with random or set initial velocities
        velocity = new PVector(random(-30, 30),random(-30, 30), random(-30, 30));

        //sets the type of the particle (this will align with the force matrix index
        type = int(random(numTypes));
    }

    void updateParticle(){
     //updates the velocities
     PVector netForce = new PVector(0, 0, 0);
     for(int currentParticle = 0; currentParticle < numberOfParticles; currentParticle++){
         //if the particle is not itself
         if(particles.get(currentParticle) != this){
            PVector distanceVector = position.copy().sub(particles.get(currentParticle).position);
            float distance = distanceVector.mag();
            //if the particle is within 1 distance unit of the particle 
            if(distance > 0 && distance < maximumDistance){
                float force = forces.force(distance/maximumDistance, forceMatrix[type][particles.get(currentParticle).type]);

                netForce.add(distanceVector.normalize().mult(force*forceScalingFactor));
                }
            }
         }
    netForce.mult(maximumDistance);


    this.velocity.add(netForce.mult(dt));
    

    this.position.add(this.velocity.mult(dt));
    }

    void display(){
        //draws the particle
        pushMatrix();
        noStroke();
        fill(type*colorStep, 255, 255);
        translate(position.x, position.y, position.z);
        sphere(1);
        popMatrix();
    }
}
