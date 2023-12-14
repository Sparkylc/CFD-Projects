class Simulation {
  ArrayList<Body> bodies; //creates an arrayList with all of the body objects
  final float dt = 0.01; //sets the timestep between each velocity and acceleration calculation
  double G = 1; //Gravitational Constant
  float  minimum = 0.01; //minimum distance between any two particles
  
  //n is the number of bodies that will be simulated
  
  
  //randomly generates a bunch of particles with random positions, velocities, and
  Simulation (Body body1, Body body2, Body body3) {
    bodies.add(body1);
    bodies.add(body2);
    bodies.add(body3);
  }
  
  
  void updateVectors(){
    
   //Selects each body and sums the accelerations of every other body around it to get net acceleration on the body
   for (int primaryBody = 0; primaryBody < bodies.size(); primaryBody++){
     
     //the position of the body we are calculating the acceleration for
     PVector primaryBodyPosition = bodies.get(primaryBody).position;
     
     //for every other body that isnt this first body, calculate the acceleration
     for (int secondaryBody = 0; secondaryBody < bodies.size(); secondaryBody++){
       
       //just ensuring that the body doesnt select itself as a body to accelerate towards
       if(primaryBody != secondaryBody){  
         
       //finds position of secondary body
       PVector secondaryBodyPosition = bodies.get(secondaryBody).position;
       
       //finds mass of secondary body
       float secondaryBodyMass = bodies.get(secondaryBody).mass;
       
       //finds the vector between the two bodies
       PVector directionVector = PVector.sub(secondaryBodyPosition, primaryBodyPosition);
       
       //finds the magnitude of the direction vector
       float directionVectorMagnitude = directionVector.mag();
       
       //finds the squared magnitude of the direction vector
       float directionVectorSquaredMagnitude = directionVector.magSq();
       
       //finds the resulting acceleration vector, using the gravitation equation, minimum is the minimum distance I will treat as possible and will calculate something no lower than that
       PVector newAccelerationVector = PVector.mult(directionVector, secondaryBodyMass / directionVectorMagnitude*directionVectorMagnitude*directionVectorMagnitude); //add minimum function
       
       //adds this acceleration onto the bodies current acceleration
       bodies.get(primaryBody).acceleration.add(newAccelerationVector);
      }
    }  
  }
  
   //updates each body in the bodies arraylist with the aformentioned calculations
   for(int body = 0; body < bodies.size(); body++){
       //uses the updatebody function in the body class
       bodies.get(body).updateBody();
   }
  }
   //displays object
   void display() {
     stroke(255);
     strokeWeight(2);
     fill(127);
     for (int body = 0; body < bodies.size(); body++){
     ellipse(bodies.get(body).position.x, bodies.get(body).position.y, 48,48);
     }
  }
}
