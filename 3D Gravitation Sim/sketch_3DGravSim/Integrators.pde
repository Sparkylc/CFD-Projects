/*to begin, we need to outline the ODE's that must be solved to calculate the motion of the particles
namely, we need to solve the equations of motion for the particles

To use RK4, the Runga-Kutta method, we need to be able to seperate our calculation of acceleration into a seperate function
which can be called by the RK4 function.
The Runga Kutta Order 4 method is as follows:


where h is the step size, f is the function we are solving, tn is the current time, yn is the current value of the function. 
For orbital mechanics, this equation needs to be solved twice, both for velocity and position. 
*/

class Integrator{
float G = 10000; //gravitational constant
ArrayList<Body> bodies = new ArrayList<Body>(); //list of bodies in the system


//allows you to add new bodies to the system
void addNewBody(Body body){
    bodies.add(body);
}

void RK4Position(Body body, float dt) {
       PVector initialPosition = body.position;
    PVector initialVelocity = body.velocity;

    // k1 calculations
    PVector k1_v = PVector.mult(calculateAcceleration(body, initialPosition), dt);
    PVector k1_r = PVector.mult(initialVelocity, dt);

    // k2 calculations
    PVector k2_v = PVector.mult(calculateAcceleration(body, PVector.add(initialPosition, PVector.mult(k1_r, 0.5f))), dt);
    PVector k2_r = PVector.mult(PVector.add(initialVelocity, PVector.mult(k1_v, 0.5f)), dt);

    // k3 calculations
    PVector k3_v = PVector.mult(calculateAcceleration(body, PVector.add(initialPosition, PVector.mult(k2_r, 0.5f))), dt);
    PVector k3_r = PVector.mult(PVector.add(initialVelocity, PVector.mult(k2_v, 0.5f)), dt);

    // k4 calculations
    PVector k4_v = PVector.mult(calculateAcceleration(body, PVector.add(initialPosition, k3_r)), dt);
    PVector k4_r = PVector.mult(PVector.add(initialVelocity, k3_v), dt);

    // Combine the slopes to get final position and velocity
    PVector finalPosition = PVector.add(initialPosition, PVector.mult(PVector.add(k1_r, PVector.add(PVector.mult(k2_r, 2), PVector.add(PVector.mult(k3_r, 2), k4_r))), 1.0f / 6.0f));
    PVector finalVelocity = PVector.add(initialVelocity, PVector.mult(PVector.add(k1_v, PVector.add(PVector.mult(k2_v, 2), PVector.add(PVector.mult(k3_v, 2), k4_v))), 1.0f / 6.0f));

    // Update the body's position and velocity
    body.position = finalPosition;
    body.velocity = finalVelocity;
}



void calculateAndPrintTotalEnergy() {
    float totalEnergy = 0;

    // Calculate kinetic energy
    for (Body body : bodies) {
        float speed = body.velocity.mag();
        totalEnergy += 0.5f * body.mass * speed * speed;  // Kinetic energy
    }

    // Calculate potential energy
    for (int i = 0; i < bodies.size(); i++) {
        for (int j = i + 1; j < bodies.size(); j++) {
            Body body1 = bodies.get(i);
            Body body2 = bodies.get(j);
            float distance = PVector.dist(body1.position, body2.position);
            totalEnergy -= G * body1.mass * body2.mass / distance;  // Potential energy
        }
    }

    // Print total energy
    System.out.println("Total Net Energy of the System: " + totalEnergy);
}


PVector calculateAcceleration(Body body, PVector currentPosition) {
    PVector netAcceleration = new PVector(0, 0, 0);

    for (Body other : bodies) {
        if (other != body) {
            PVector r = PVector.sub(other.position, currentPosition);
            float rMagnitude = r.mag();
            if (rMagnitude != 0) {  // Check to avoid division by zero
                PVector acceleration = r.normalize().mult(G * other.mass / (rMagnitude * rMagnitude));
                netAcceleration.add(acceleration);
            }
        }
    }
    return netAcceleration;
}


  void update(){
   //updates each body in the bodies arraylist with the aformentioned calculations
   for(int body = 0; body < bodies.size(); body++){
       //uses the updatebody function in the body class
       RK4Position(bodies.get(body), 0.01f);
   }
   calculateAndPrintTotalEnergy();
  }

   //displays object
void display() {
    
     stroke(0);
     fill(255);
     //draws the spheres
     for (int body = 0; body < bodies.size(); body++){
        pushMatrix();
        translate(bodies.get(body).position.x, bodies.get(body).position.y, bodies.get(body).position.z);
        noStroke();
        sphere(bodies.get(body).radius);
        popMatrix();
     }
  }

}