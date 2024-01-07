public class ForceRegistry {
  private List<ForceRegistration> registry;


  public ForceRegistry() {
    this.registry = new ArrayList<ForceRegistration>();
  }

  public void add(RigidBody2D rigidBody, ForceGenerator forceGenerator) {
    ForceRegistration forceRegistration = new ForceRegistration(rigidBody, forceGenerator);
    this.registry.add(forceRegistration);
  } 

  public void remove(RigidBody2D rigidBody, ForceGenerator forceGenerator) {
    ForceRegistration forceRegistration = new ForceRegistration(rigidBody, forceGenerator);
    this.registry.remove(forceRegistration);
  }

  public void clear() {
    this.registry.clear();
  }

  public void updateForces(double duration) {
    for (ForceRegistration forceRegistration : this.registry) {
      forceRegistration.forceGenerator.updateForce(forceRegistration.rigidBody, dt);
    }
  }

  public void zeroForces(){
    for (ForceRegistration forceRegistration : this.registry) {
      //TODO: FIXME
      //forceRegistration.rigidBody.zeroForces();
    }
  }

}