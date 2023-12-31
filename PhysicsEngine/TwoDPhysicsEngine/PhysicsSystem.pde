public class PhysicsSystem {
  private ForceRegistry forceRegistry;
  private List<RigidBody2D> rigidBodies;
  private Gravity2D gravity;
  private float fixedUpdate;

  public PhysicsSystem(float fixedUpdateDt, PVector gravity) {
    this.forceRegistry = new ForceRegistry();
    this.rigidBodies = new ArrayList<RigidBody2D>();
    this.gravity = new Gravity2D(gravity);

    this.fixedUpdate = fixedUpdateDt;
  }
  public void update(float dt) {
    //ensures that physics is done at the correct dt regardless of framerate
      fixedUpdate();
  }

  public void fixedUpdate() {
    forceRegistry.updateForces(fixedUpdate);
    for (int i = 0; i < rigidBodies.size(); i++) {
      rigidBodies.get(i).physicsUpdate(fixedUpdate);
    }
    //update the velocities of all rigid bodies
  }

  public void addRigidBody(RigidBody2D rigidBody) {
      this.rigidBodies.add(rigidBody);
      //Register gravity
      this.forceRegistry.add(rigidBody, gravity);
      //rigidBody.init();
  }
}
