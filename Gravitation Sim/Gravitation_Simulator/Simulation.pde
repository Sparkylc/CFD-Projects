 

class Simulation {
  ArrayList<Body> bodies; //creates an arrayList with all of the body objects
  double G = 1; //Gravitational Constant
  float  minimum = 0.01; //minimum distance between any two particles
  
  
 

  //n is the number of bodies that will be simulated
  Simulation(){
    bodies = new ArrayList<Body>();
  }
  

  void addNewBody(Body newBody){
    bodies.add(newBody);
  }
  
  void updateVectors(){
    
   //Selects each body and sums the accelerations of every other body around it to get net acceleration on the body, calculates values both ways
   for (int primaryBody = 0; primaryBody < bodies.size(); primaryBody++){
     
     //the position of the body we are calculating the acceleration for
     PVector primaryBodyPosition = bodies.get(primaryBody).position;

     float primaryBodyMass = bodies.get(primaryBody).mass;
     
      //gets radius of the primary body
       float primaryBodyRadius = bodies.get(primaryBody).bodyRadius;
     
     //for every other body that isnt this first body, calculate the acceleration
     for (int secondaryBody = primaryBody+1; secondaryBody < bodies.size(); secondaryBody++){
       
       //just ensuring that the body doesnt select itself as a body to accelerate towards
       if(primaryBody != secondaryBody){  
         
       //finds position of secondary body
       PVector secondaryBodyPosition = bodies.get(secondaryBody).position;
       
       //finds mass of secondary body
       float secondaryBodyMass = bodies.get(secondaryBody).mass;
       
       //finds radius of secondary body
       float secondaryBodyRadius = bodies.get(secondaryBody).bodyRadius;
       
       //finds the unit direction vector between the two bodies
       PVector directionVector = PVector.sub(secondaryBodyPosition, primaryBodyPosition).normalize();
    
       //finds the direction vectors magnitude
       float directionVectorMagnitude = directionVector.mag();
       
       
        
       //finds the resulting force vector, using the gravitation equation, minimum is the minimum distance I will treat as possible and will calculate something no lower than that
       PVector accelerationVector = PVector.mult(directionVector, 1/(directionVectorMagnitude*directionVectorMagnitude));
       
       
       //adds this acceleration onto the bodies current acceleration
       bodies.get(primaryBody).acceleration.add(PVector.mult(accelerationVector,secondaryBodyMass)); //a1 = m2/r^2 

       bodies.get(secondaryBody).acceleration.sub(PVector.mult(accelerationVector,primaryBodyMass));//a2 = m1/r^2
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
     ellipse(bodies.get(body).position.x, bodies.get(body).position.y, bodies.get(body).bodyRadius, bodies.get(body).bodyRadius);
     }
  }
}
