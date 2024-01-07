class Integrator {
    Body body;
    PVector position = new PVector();
    PVector velocity = new PVector();
    PVector acceleration = new PVector();
    ArrayList<Body> bodies;


    Integrator(Body body){
        //assigns the variable to the inputted body
        this.body = body;
    }

    Integrator(ArrayList<Body> bodies){
        this.bodies = bodies;
    }
    void verletIntegrator(){

      //generate a velocity vector
      body.velocity = PVector.sub(body.position, body.previousPosition);

      //this sets the current position to the old position 
      body.previousPosition = body.position;
    
      //finds the change in position of the body per frams
      body.position = PVector.add(body.position, PVector.add(body.velocity, PVector.mult(body.acceleration,sq(dt)))); 
        
      //resets acceleration as to recalculate it for the next frame
      body.acceleration.mult(0);
    }

} 


