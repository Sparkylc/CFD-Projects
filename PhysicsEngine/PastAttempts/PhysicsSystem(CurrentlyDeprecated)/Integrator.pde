/*to begin, we need to outline the ODE's that must be solved to calculate the motion of the particles
namely, we need to solve the equations of motion for the particles

To use RK4, the Runga-Kutta method, we need to be able to seperate our calculation of acceleration into a seperate function
which can be called by the RK4 function.
The Runga Kutta Order 4 method is as follows:
*/

public class Integrator{
  private Rigidbody rigidbody;
public Integrator(Rigidbody rigidbody) {
  this.rigidbody = rigidbody;
}

//For normal force functions that are not velocity dependent
public void RK4Position(Rigidbody rigidbody, float dt) {
    PVector initialPosition = rigidbody.getPosition().copy();
    PVector initialVelocity = rigidbody.getVelocity().copy();

    // k1 calculations
    PVector k1_v = PVector.mult(calculateAcceleration(rigidbody, initialPosition), dt);
    PVector k1_r = PVector.mult(initialVelocity, dt);

    // k2 calculations
    PVector k2_v = PVector.mult(calculateAcceleration(rigidbody, PVector.add(initialPosition, PVector.mult(k1_r, 0.5f))), dt);
    PVector k2_r = PVector.mult(PVector.add(initialVelocity, PVector.mult(k1_v, 0.5f)), dt);

    // k3 calculations
    PVector k3_v = PVector.mult(calculateAcceleration(rigidbody, PVector.add(initialPosition, PVector.mult(k2_r, 0.5f))), dt);
    PVector k3_r = PVector.mult(PVector.add(initialVelocity, PVector.mult(k2_v, 0.5f)), dt);

    // k4 calculations
    PVector k4_v = PVector.mult(calculateAcceleration(rigidbody, PVector.add(initialPosition, k3_r)), dt);
    PVector k4_r = PVector.mult(PVector.add(initialVelocity, k3_v), dt);

    // Combine the slopes to get final position and velocity
    PVector finalPosition = PVector.add(initialPosition, PVector.mult(PVector.add(k1_r, PVector.add(PVector.mult(k2_r, 2), PVector.add(PVector.mult(k3_r, 2), k4_r))), 1.0f / 6.0f));
    PVector finalVelocity = PVector.add(initialVelocity, PVector.mult(PVector.add(k1_v, PVector.add(PVector.mult(k2_v, 2), PVector.add(PVector.mult(k3_v, 2), k4_v))), 1.0f / 6.0f));

    // Update the body's position and velocity
    rigidbody.setPosition(finalPosition);
    rigidbody.setVelocity(finalVelocity);
}

//simple solver for angular position and velocity before I figure this shit out, this just assumes
//im calculating the angular position of an object a certain distance R away from the center
public PVector angularPositionIntegrator(Rigidbody rigidbody, float r, float dt) {
    PVector centerPosition = rigidbody.getPosition().copy();

    float angularPosition = rigidbody.getAngularPosition();
    float angularVelocity = rigidbody.getAngularVelocity();
    float angularAcceleration = rigidbody.getAngularAcceleration();

    float newAngularVelocity = angularVelocity + angularAcceleration * dt;
    float newAngularPosition = angularPosition + newAngularVelocity * dt;

    // Calculate the new position based on the new angular position
    float newX = centerPosition.x + r * cos(newAngularPosition);
    float newY = centerPosition.y + r * sin(newAngularPosition);
    PVector newPosition = new PVector(newX, newY);

    // Update the rigidbody's angular position, angular velocity, and position
    rigidbody.setAngularPosition(newAngularPosition);
    rigidbody.setAngularVelocity(newAngularVelocity);
    return newPosition;
}

//for in house acceleration calculations
public PVector calculateAcceleration(Rigidbody rigidbody, PVector position){
  ArrayList<ForceRegistry> forceRegistry = rigidbody.getForceRegistry();
  PVector netForce = new PVector();
  for(ForceRegistry force : forceRegistry) {
      netForce.add(force.getForce(rigidbody, position));
  }
  return PVector.div(netForce, rigidbody.getMass());
  }

public float calculateAngularAcceleration(Rigidbody rigidbody) {
  return 0;
}

}