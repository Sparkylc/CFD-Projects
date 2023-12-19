
class Body {
  
 //creates vectors for position, velocity, and acceleration for a body object
  PVector position = new PVector();
  PVector previousPosition = new PVector();
  PVector velocity = new PVector();
  PVector acceleration = new PVector();
  PVector currentAccelerationVector = new PVector();
  

  //creates an integrator object with this object as an input
  Integrator objectIntegrator = new Integrator(this);

  //creates a temp float for calculations;


  int count = 0;

 
  //input the bodies radius in meters
  
  //convers the radius from meters to pixels given the value of meters per pixel
  float radius;
 
  //creates a float for mass of body
  float mass;
 
 
 //5 parameter constructor
  Body(PVector position, PVector acceleration, float mass, float radius) {
     this.position = position;
     this.acceleration = acceleration;
     this.mass = mass;
     this.radius = radius;
  }
  
  
  void initialVelocity(PVector initialMousePosition, PVector finalMousePosition){
      //edge case so no division by 0
      if(PVector.sub(initialMousePosition, finalMousePosition).mag()<0.01){
          this.previousPosition = position;
      } else {
        //calculates the initial velocity of the body based on the distance between the initial mouse position and the final mouse position
      float initialVelocity = PVector.sub(initialMousePosition, finalMousePosition).mag();
      //calculates the unit direction vector of the body based on the distance between the initial mouse position and the final mouse position
      //and multiplies this by a scaling factor that is inversely proportional to the square root of the distance
      float scalingFactor = 1/sqrt(initialVelocity);
      PVector unitDirectionVector = PVector.mult(PVector.sub(initialMousePosition, finalMousePosition).normalize(),scalingFactor);

      //sets the previous position of the body to the current position minus the unit direction vector multiplied by the initial velocity, 
      //so that the body starts at the position of the mouse, and moves in the direction of the mouse
      this.previousPosition = PVector.sub(this.position, PVector.mult(unitDirectionVector,initialVelocity));
      }
  }

  //updates the body's position, velocity, and acceleration
  void updateBody() {
      //sets the object integrator type
      //creates a copy of the acceleration vector for the user interface before it is reset for the next acceleration calculation
      this.currentAccelerationVector = this.acceleration.copy();

      //creates the velocity and acceleration vectors. this is done with the current frame information so that what is displayed is the current velocity
      //and acceleration, not the velocity and acceleration from the next frame
      userInterfaceController.velocityVectorArrow(this);
      userInterfaceController.accelerationVectorArrow(this);

      //updates the position, velocity, and acceleration vectors using the verlet integration mode
      objectIntegrator.verletIntegrator();

      //runs the constrain method for window bounds
      this.constrain();

      //runs the collision detection method on the entire body array
      this.collisionDetection(simulation.getBodyArray());
  
  }

  void constrain() {
      //multiplies each velocity by this to dampen wall impacts
      //checks if body is  out of bounds and simply flips the direction of velocity

      if(this.position.x - this.radius < 0 || this.position.x + this.radius > screenWidth){
        float temp;
        if(this.position.x - this.radius/2 < 0) {
          temp = this.position.x;
          this.position.x = previousPosition.x;
          previousPosition.x = temp;
        }
        if(this.position.x + this.radius/2 > screenWidth) {
          temp = this.position.x;
          this.position.x = previousPosition.x;
          previousPosition.x = temp;
        }
        
         
      }
      if(this.position.y - this.radius/2 < 0 || this.position.y + this.radius/2 > screenHeight){
        float temp;
        if(this.position.y - this.radius/2 < 0){
          temp = this.position.y;
          this.position.y = previousPosition.y;
          previousPosition.y = temp;
        }
        if(this.position.y + this.radius/2 > screenHeight){
          temp = this.position.y;
          this.position.y = previousPosition.y;
          previousPosition.y = temp;
        }
         
      }
  }

  //just creates a list with the bodies the current body is in contact with, then updates those bodies;
  void collisionDetection(ArrayList<Body> bodies){
    ArrayList<Body> collidedBodies = new ArrayList();

    //just checks if the current body has collided with the other body, and if that other body is not the current body
    for(int currentBody = 0; currentBody < bodies.size(); currentBody++){
      if(bodies.get(currentBody) != this && hasCollided(bodies.get(currentBody))){
        collidedBodies.add(bodies.get(currentBody));
        
    }
   }
    //performs the collision response with every object in the list
   for (int currentBody = 0; currentBody < collidedBodies.size(); currentBody++){
    this.collisionResponse(collidedBodies.get(currentBody));
   } 
  } 
  
  //checks if the current object is within the minimum distance of the other object, and performs a correction so that the body doesnt intersect itself
  boolean hasCollided(Body body){
    PVector distanceVector = PVector.sub(body.position, this.position);
    if (distanceVector.mag() < (body.radius+this.radius)/2){
      //if (distanceVector.mag() < (body.radius + this.radius)/2){
      float distanceCorrection = ((body.radius+this.radius)/2 - distanceVector.mag())/2;
      PVector d = distanceVector.copy();
      PVector correctionVector = d.normalize().mult(distanceCorrection);
      body.position.add(correctionVector);
      position.sub(correctionVector);

      return true;
    }
    return false;
  }



  void collisionResponse(Body body) {


          
            /* First you find the normal vector, the vector that crosses through both centers, and the vector tangential to their point of impact,
            ie the vector orthogonal to the line between the two centers of the bodies:

              n is the normal vector
              pos2 is the position of the second body
              pos1 is the position of the current body
                      n = pos2 - pos1


            then you find the unit normal vector:
            
              un is the unit normal vector
              n is the normal vector
              ||n|| is the magnitude of the normal vector 
                        un = n/||n||
            
            to find the unit tangent vector:

              ut is the unit tangent vector
              un_y is the y component of the unit normal vector
              un_x is the x component of the unit normal vector
                       ut = <-un_y,unx>
            
            then you project your velocity vector onto the tangent and normal vectors using a dot product to find the magnitude of the components of velocity of the object along
            the normal and tangent lines

              v_1n is the magnitude of the component of velocity in the normal direction for the first body
              v_1t is the magnitude of the component of velocity in the tangential direction for the first body
              v_2n is the magnitude of the component of velocity in the normal direction for the secondary body
              v_2t is the magnitude of the component of velocity in the tangential direction for the secondary body
              un is the unit normal vector
              ut is the unit tangent vector
              v_1 is the current velocity vector for the first body
              v_2 is the current velocity vector for the second body

                            v_1n= un (dot) v_1
                            v_1t = ut (dot) v_1
                            v_2n = un (dot) v_2
                            v_2t = ut (dot) v_2

            then using the laws of conservation of energy, as well as the laws of momentum, ie
                      0.5*m_1*(v_1)^2 + 0.5*m_2*(v_2)^2 = 0.5*m_1(v'_1)^2 + 0.5m_1(v'_2)^2
                                                   and
                                m_1*v_1 + m_2*v_2 = m_1*v'_1 + m_2*v'_2

            (as the collision is elastic so both kinetic energy and momentum are conserved)
            you can find the following equations for the new magnitudes of the normal and tangential components of the two velocities:

              v'_1n is the magnitude of the normal component of the new velocity for the first body
              v'_2n is the magnitude of the normal component of the new velocity for the second body
              v'_1t is the magnitude of the tangential component of the new velocity for the first body
              v'_2t is the magnitude of the tangential component of the new velocity for the second body
              m_1 is the mass of the first body
              m_2 is the mass of the secondary body

                            v'_1n = (v_1n(m_1-m_2)+2m_2*v_2n)/(m_1+m_2) 
                            v'_2n = (v_2n(m_2-m_1)+2m_1*v_1n)/(m_1+m_2) 

                            v'_1t = v_1t
                            v'_2t = v_2t

            finally from there convert the scalar normal and tangential velocities for both objects back into their respective vectors, and find the final velocity vectors 
            by summing the new normal and tangential vectors
              
              vec(v'_1) is the new velocity vector for the first body
              vec(v'_2) is the new velocity vector for the second body
              vec(v'_1n) is the new normal velocity vector for the first body
              vec(v'_2n) is the new normal velocity vector for the second body
              vec(v'_1t) is the new tangent velocity vector for the first body
              vec(v'_2t) is the new tangent velocity vector for the second body
              v'_1n is the magnitude of the normal component of the new velocity for the first body
              v'_2n is the magnitude of the normal component of the new velocity for the second body
              v'_1t is the magnitude of the tangential component of the new velocity for the first body
              v'_2t is the magnitude of the tangential component of the new velocity for the second body
              un is the unit normal vector
              ut is the unit tangent vector

                                    vec(v'_1n) = (v'_1n)*(un)
                                    vec(v'_2n) = (v'_2n)*(un)
                                    vec(v'_1t) = (v'_1t)*(ut)
                                    vec(v'_2t) = (v'_2t)*(ut)
                                  vec(v'_1)=vec(v'_1n)+vec(v'_1t)
                                  vec(v'_2)=vec(v'_2n)+vec(v'_2t)
            
            */
            PVector secondaryBodyPosition = body.position;
            PVector secondaryBodyVelocity = body.velocity;
            float secondaryBodyMass = body.mass;

            //finds the unit vector of the line that goes between the centers of bodies
            PVector unitNormalVector = PVector.sub(secondaryBodyPosition, position).normalize();
     
            
            //finds the unit vector tangent to both body at the point of collision
            PVector unitTangentVector = new PVector(-1*unitNormalVector.y, unitNormalVector.x);

            //finds the scalar values for the tangential and normal velocity of both bodies
            float primaryBodyScalarTangentialVelocity = PVector.dot(unitTangentVector, this.velocity);
            float primaryBodyScalarNormalVelocity = PVector.dot(unitNormalVector, this.velocity);

            float secondaryBodyScalarTangentialVelocity = PVector.dot(unitTangentVector, secondaryBodyVelocity);
            float secondaryBodyScalarNormalVelocity = PVector.dot(unitNormalVector, secondaryBodyVelocity);

            //finds the new scalar values for the components of velocity along the normal line
            float newPrimaryBodyScalarNormalVelocity = (primaryBodyScalarNormalVelocity * (this.mass - secondaryBodyMass) + 2 * secondaryBodyMass * secondaryBodyScalarNormalVelocity) / (this.mass + secondaryBodyMass);
            float newSecondaryBodyScalarNormalVelocity = (secondaryBodyScalarNormalVelocity * (secondaryBodyMass-this.mass) + 2 * this.mass * primaryBodyScalarNormalVelocity)/(this.mass + secondaryBodyMass);
 
            PVector newPrimaryBodyNormalVelocityVector = PVector.mult(unitNormalVector, newPrimaryBodyScalarNormalVelocity);
            PVector newSecondaryBodyNormalVelocityVector = PVector.mult(unitNormalVector, newSecondaryBodyScalarNormalVelocity);

            PVector newPrimaryBodyTangentialVelocityVector = PVector.mult(unitTangentVector, primaryBodyScalarTangentialVelocity);
            PVector newSecondaryBodyTangentialVelocityVector = PVector.mult(unitTangentVector, secondaryBodyScalarTangentialVelocity);

            PVector newPrimaryBodyVelocityVector = PVector.add(newPrimaryBodyNormalVelocityVector,newPrimaryBodyTangentialVelocityVector);
            PVector newSecondaryBodyVelocityVector = PVector.add(newSecondaryBodyNormalVelocityVector, newSecondaryBodyTangentialVelocityVector);
            //System.out.println(velocity);
            
            this.velocity = newPrimaryBodyVelocityVector;
            body.velocity = newSecondaryBodyVelocityVector;

            

            //System.out.println(velocity);
         
        }
        }








