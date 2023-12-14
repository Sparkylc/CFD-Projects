 final float dt = 0.01;

class Body {
  
 //creates vectors for position, velocity, and acceleration for a body object
  PVector position = new PVector();
  PVector velocity = new PVector();
  PVector acceleration = new PVector();
 
//creates a float for mass of body
 float mass;
 
 
 //4 parameter constructor
  Body(PVector position, PVector velocity, PVector acceleration, float mass) {
     this.position = position;
     this.velocity = velocity;
     this.acceleration = acceleration;
  }
  
  
  void updateBody() {
    
      //finds the change in position of the body per frame
      PVector positionDelta = PVector.mult(velocity, dt);
      
      //adds this change in position to the current position
      position.add(positionDelta);
      
      
      //finds the change in velocity of the body per frame
      PVector velocityDelta = PVector.mult(acceleration, dt);
      
      //adds this change in velocity to the current velocity
      velocity.add(velocityDelta);
      
      //resets acceleration as to recalculate it for the next frame
      acceleration.mult(0);
  }


}
