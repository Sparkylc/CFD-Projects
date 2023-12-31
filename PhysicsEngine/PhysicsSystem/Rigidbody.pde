public class Rigidbody {
  private PVector position;
  private PVector velocity;
  private float angularVelocity;

  //dimensional variables
  private float width;
  private PVector[] vertices;
  private float height;
  private float radius;
  private float density;

  private float mass = 5.0f;
  private Integrator rigidbodyIntegrator;
  private ArrayList<ForceRegistry> forceRegistry = new ArrayList<ForceRegistry>();
  private CollisionDetection collisionDetection = new CollisionDetection();



  public Rigidbody(PVector position, PVector velocity, Integrator rigidbodyIntegrator) {
    this.position = position;
    this.velocity = velocity;
    this.rigidbodyIntegrator = rigidbodyIntegrator;
  }

  public void draw(){
    rigidbodyIntegrator.RK4Position(this, 0.1f);
    collisionDetection.edgeCollision(this);
    ellipse(position.x, position.y, 10, 10);
  }



  public PVector getPosition() {
    return this.position;
  }

  public void setPosition(PVector position) {
    this.position = position;
  }

  public PVector getVelocity() {
    return this.velocity;
  }

  public void setVelocity(PVector velocity) {
    this.velocity = velocity;
  }


  public Integrator getRigidbodyIntegrator() {
    return this.rigidbodyIntegrator;
  }

  public void setRigidbodyIntegrator(Integrator rigidbodyIntegrator) {
    this.rigidbodyIntegrator = rigidbodyIntegrator;
  }

  public void addForce(ForceRegistry forceRegistry){
    this.forceRegistry.add(forceRegistry);
  }

  public ArrayList<ForceRegistry> getForceRegistry() {
    return this.forceRegistry;
  }

  public ForceRegistry getForce(int index) {
    return this.forceRegistry.get(index);
  }

  public void clearForce(){
    this.forceRegistry.clear();
  }

  public float getMass(){
    return this.mass;
  }

  public void setMass(float mass){
    this.mass = mass;
  }

  public float getAngularVelocity() {
    return this.angularVelocity;
  }

  public void setAngularVelocity(float angularVelocity) {
    this.angularVelocity = angularVelocity;
  }

  public float getWidth() {
    return this.width;
  }

  public void setWidth(float width) {
    this.width = width;
  }

  public float getHeight() {
    return this.height;
  }

  public void setHeight(float height) {
    this.height = height;
  }

  public float getRadius() {
    return this.radius;
  }

  public void setRadius(float radius) {
    this.radius = radius;
  }
  
  public float getDensity() {
    return this.density;
  }

  public void setDensity(float density) {
    this.density = density;
  }

  public PVector[] getVertices() {
    return this.vertices;
  }

  public void setVertices(PVector[] vertices) {
    this.vertices = vertices;
  }
}