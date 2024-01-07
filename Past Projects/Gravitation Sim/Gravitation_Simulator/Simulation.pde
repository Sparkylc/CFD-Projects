 class Simulation {
  ArrayList<Body> bodies; //creates an arrayList with all of the body objects
  float G = 1; //Gravitational Constant
  float  minimum = 0.01; //minimum distance between any two particles
  float totalEnergy = 0; //total energy of the system

  //n is the number of bodies that will be simulated
  Simulation(){
    bodies = new ArrayList<Body>();
  }

  ArrayList<Body> getBodyArray(){
    return bodies;
  }
  

  void addNewBody(Body newBody){
    bodies.add(newBody);

  }
  

  //updates acceleration vectors
  void updateVectors(){
    
   //Selects each body and sums the accelerations of every other body around it to get net acceleration on the body, calculates values both ways
   for (int primaryBody = 0; primaryBody < bodies.size(); primaryBody++){
     
     //the position of the body we are calculating the acceleration for
     PVector primaryBodyPosition = bodies.get(primaryBody).position;

     float primaryBodyMass = bodies.get(primaryBody).mass;
     
      //gets radius of the primary body
       float primaryBodyRadius = bodies.get(primaryBody).radius;
     
     //for every other body that isnt this first body, calculate the acceleration
     for (int secondaryBody = primaryBody+1; secondaryBody < bodies.size(); secondaryBody++){
       
       //just ensuring that the body doesnt select itself as a body to accelerate towards
       if(primaryBody != secondaryBody){  
         
       //finds position of secondary body
       PVector secondaryBodyPosition = bodies.get(secondaryBody).position;
       
       //finds mass of secondary body
       float secondaryBodyMass = bodies.get(secondaryBody).mass;
       
       //finds radius of secondary body
       float secondaryBodyRadius = bodies.get(secondaryBody).radius;
       
       //finds the unit direction vector between the two bodies
       PVector directionVector = PVector.sub(secondaryBodyPosition, primaryBodyPosition).normalize();
    
       //finds the direction vectors magnitude
       float directionVectorMagnitude = PVector.sub(secondaryBodyPosition, primaryBodyPosition).mag();
       

       //finds the resulting force vector, using the gravitation equation, minimum is the minimum distance I will treat as possible and will calculate something no lower than that
       PVector accelerationVector = PVector.mult(directionVector, 1/max(directionVectorMagnitude*directionVectorMagnitude,0.1));
       
       //adds this acceleration onto the bodies current acceleration
       bodies.get(primaryBody).acceleration.add(PVector.mult(PVector.mult(accelerationVector,secondaryBodyMass),gravitationalScalingCoefficient)); //a1 = m2/r^2 
       bodies.get(secondaryBody).acceleration.sub(PVector.mult(PVector.mult(accelerationVector,primaryBodyMass), gravitationalScalingCoefficient));//a2 = m1/r^2
       
       bodies.get(primaryBody).currentAccelerationVector = bodies.get(primaryBody).acceleration;
       bodies.get(secondaryBody).currentAccelerationVector = bodies.get(secondaryBody).acceleration;
      }
    }
  
  }
}

  void updateBodies(){
   //updates each body in the bodies arraylist with the aformentioned calculations
   for(int body = 0; body < bodies.size(); body++){
       //uses the updatebody function in the body class
       bodies.get(body).updateBody();
   }
  }

  
  

   //displays object
   void display() {
    
     stroke(0);
     fill(255);
     for (int body = 0; body < bodies.size(); body++){
        float strokeWeight = max(min(bodies.get(body).radius*5/100,7),4);
             strokeWeight(strokeWeight);
      //ELLIPSE USEs DIAMETER AS INPUT NOT RADIUS
      ellipse(bodies.get(body).position.x, bodies.get(body).position.y, bodies.get(body).radius-strokeWeight, bodies.get(body).radius-strokeWeight);
     }
    

  }

  void resetSimulation(){
    bodies.clear();
    
    zoom = 1;
  }


  void spawnOrbitingBody(Body centralBody, float mass, float radius, float distance) {
    // Calculate the position of the orbiting body
    float G = userInterface.getController(activeTab + " Gravity Scale").getValue();
    PVector position = centralBody.position.copy();
    position.add(distance, 0);  // Add the distance to the x-coordinate


    // Create the orbiting body
    Body orbitingBody = new Body(position, mass, radius);

   
    float initialVelocity = sqrt(G/1000000*centralBody.mass / distance);
    PVector unitDirectionVector = new PVector(0, 1);
          
    orbitingBody.previousPosition = PVector.sub(orbitingBody.position, PVector.mult(unitDirectionVector,initialVelocity));

    // Add the orbiting body to the simulation
    this.addNewBody(orbitingBody);
}


Body getClickedBody() {
    PVector mousePosition = getMouseWorldCoordinates();
    for (Body body : bodies) {
        float distance = PVector.dist(mousePosition, body.position);
        if (distance <= body.radius) {
            return body;
        }
    }
    return null;  // Return null if no body was clicked
}
}

