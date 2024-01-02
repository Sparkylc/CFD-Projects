public class Rigidbody {
  private PVector position;
  private PVector velocity;
  private float angularVelocity;

  //variables for rendering
  private boolean isVisible = true;
  private boolean isForceVisible = true;
  private String shapeType = "circle"; //String to define what type of shape it is for other calculations like moment of inertia, drag coefficient, etc.


  //dimensional variables
  private float mass = 5.0f;
  private float density = 1.0f;
  private float width;
  private float height;
  private float radius;
  private PVector[] vertices;

  //variables for interactivity controls
  private boolean isMouseInteractive;
  private boolean isCurrentlyMouseInteractive;
  private boolean isSimulationPaused;


  //For lines, ropes and springs
  //the end of the line/rope/spring will be the current position of the rigidbody
  private PVector start;
  private PVector end;
  private float angle;

  //Variables for properties of the rigidbody
  private boolean isStatic = false;
  private boolean isCollidable = false;
 
  




  private ShapeRenderer shapeRenderer = new ShapeRenderer(this);
  private Integrator rigidbodyIntegrator;

  //ForceRegistry to store all the external forces acting on the rigidbody
  private ArrayList<ForceRegistry> forceRegistry = new ArrayList<ForceRegistry>();

  private CollisionDetection collisionDetection = new CollisionDetection();



  public Rigidbody(PVector position, PVector velocity, Integrator rigidbodyIntegrator) {
    this.position = position;
    this.end = this.position;
    this.velocity = velocity;

    this.isVisible = true;
    this.isMouseInteractive = true;

    this.rigidbodyIntegrator = rigidbodyIntegrator;
    // default initialization of a circle
    this.radius = 10.0f;
    this.mass = 10.0f;
  }

  public void draw(){
    if(!isStatic) {
      if(!this.isCurrentlyMouseInteractive && this.isVisible && !PhysicsWorld.IS_SIMULATION_PAUSED) {
      rigidbodyIntegrator.RK4Position(this, PhysicsWorld.DT);
      }
      if(this.isCollidable) {
        collisionDetection.edgeCollision(this);
      }
      if(this.isVisible){
        shapeRenderer.render();
      }
      if(this.isForceVisible) {
        for(ForceRegistry force : forceRegistry) {
          force.draw();
        }
      }
    }
    if(isStatic){
      if(this.isVisible){
        shapeRenderer.render();
      }
      if(this.isCollidable) {
        collisionDetection.edgeCollision(this);
      }
      if(this.isForceVisible) {
        for(ForceRegistry force : forceRegistry) {
          force.draw();
        }
      }
    }
  }



  public PVector getPosition() {
    return this.position;
  }

  public float getX() {
    return this.position.x;
  }
  public float getY() {
    return this.position.y;
  }

  public void setPosition(PVector position) {
    this.position = position;
  }
  //Overloaded method to accept floats
  public void setPosition(float x, float y) {
    this.position.x = x;
    this.position.y = y;
  }

  public PVector getVelocity() {
    return this.velocity;
  }

  public void setVelocity(PVector velocity) {
    this.velocity = velocity;
  }

  //Overloaded method to accept floats
  public void setVelocity(float x, float y) {
    this.velocity.x = x;
    this.velocity.y = y;
  }


  public Integrator getRigidbodyIntegrator() {
    if(this.rigidbodyIntegrator == null){
      System.out.println("RigidbodyIntegrator is null, returning null");
      return null;
    } else {
    return this.rigidbodyIntegrator;
    }
  }

  public void setRigidbodyIntegrator(Integrator rigidbodyIntegrator) {
    if(rigidbodyIntegrator == null){
      System.out.println("Trying to set a null integrator, returning null");
      return;
    } else {
    this.rigidbodyIntegrator = rigidbodyIntegrator;
    }
  }

  public void addForce(ForceRegistry force){
    if(force == null){
      System.out.println("Trying to add a null force to the forceRegisty, returning");
      return;
    } else {
    this.forceRegistry.add(force);
    }
  }

  public ArrayList<ForceRegistry> getForceRegistry() {
    if(this.forceRegistry.isEmpty()){
      System.out.println("ForceRegistry is empty, returning forceRegistry");
      return this.forceRegistry;
    } else {
    return this.forceRegistry;
  }
  }

  public ForceRegistry getForce(int index) {
    if(index >= this.forceRegistry.size()){
      System.out.println("Index is out of bounds, returning null");
      return null;
    } else {
    return this.forceRegistry.get(index);
    }
  }

  public void clearForce(){
    if(this.forceRegistry.isEmpty()){
      System.out.println("ForceRegistry is already empty, returning");
      return;
    } else {
    this.forceRegistry.clear();
    }
  }

  public float getMass(){
    if(this.mass == 0.0f) {
      System.out.println("Mass is 0.0f, has possibly not been initialized. Returning -1");
      return -1;
    } else {
    return this.mass;
    }
  }

  public void setMass(float mass){
    if(mass == 0.0f){
      System.out.println("Trying to set mass to 0.0f, returning");
      return;
    } else {
    this.mass = mass;
    }
  }

  public float getAngularVelocity() {
    return this.angularVelocity;
  }

  public void setAngularVelocity(float angularVelocity) {
    this.angularVelocity = angularVelocity;
  }

  public float getWidth() {
    if(this.radius == 0.0f && this.width != 0.0f){
      return this.width;
    } else if(this.radius == 0.0f && this.width == 0.0f) {
      System.out.println("Cannot get width as width is 0.0f, returning -1");
      return -1;
    } else {
      System.out.println("Cannot get width when radius is set");
      return -1;
    }
  }

  public void setWidth(float width) {
    if(this.radius == 0.0f && width != 0.0f){
    this.width = width;
    } else {
      if(width == 0.0f || this.radius != 0.0f){
        System.out.println("Is width 0.0f: " + (width == 0.0f) + " Is radius not 0.0f " + (radius != 0.0f) + " , returning");
      }
    }
  }

  public float getHeight() {

    if(this.radius == 0.0f && this.height != 0.0f){
      return this.height;
    } else if(this.radius == 0.0f && this.height == 0.0f){
      System.out.println("Cannot get height as height is 0.0f, returning -1");
      return -1;
    } else {
      System.out.println("Cannot get height when radius is set");
      return -1;
    }
  }

  public void setHeight(float height) {
    if(this.radius == 0.0f && height != 0.0f){
    this.height = height;
    } else {
      if(height == 0.0f || this.radius != 0.0f){
        System.out.println("Is height 0.0f: " + (height == 0.0f) + " Is radius not 0.0f " + (radius != 0.0f) + " , returning");
      }
    }
  }

  public float getRadius() {
    if(this.radius != 0.0f && (this.width == 0.0f && this.height == 0.0f)){
      return this.radius;
    } else if(this.radius == 0.0f && (this.width == 0.0f && this.height == 0.0f)){
      System.out.println("Cannot get radius as radius is 0.0f, returning -1");
      return -1;
    } else {
      System.out.println("Cannot get radius when width and height is set");
      return -1;
    }
  }

  public void setRadius(float radius) {
    if(this.width == 0.0f && this.height == 0.0f && radius != 0.0f){
      this.radius = radius;
    } else {
      if(radius == 0.0f || (this.width != 0.0f && this.height != 0.0f)){
        System.out.println("Is radius 0.0f: " + (radius == 0.0f) + " Is width and height not 0.0f " + (this.width != 0.0f && this.height != 0.0f) + " , returning");
      }
    }
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

  public float getArea() {
    if(this.width != 0.0f && this.height != 0.0f) {
      return (float)(this.width * this.height);
    }
    if(radius != 0.0f){
      return (float)PI * this.radius * this.radius;
    }
    System.out.println("Cannot get area as neither width nor height or radius is set, returning -1");
    return -1.0f;
  }

  public String getShapeType() {
    if(this.shapeType != null) {
      return this.shapeType;
    } else {
      System.out.println("ShapeType is null, returning null");
      return null;
    }
  }
  
  public void setShapeType(String shapeType) {
    if(shapeType != null) {
      this.shapeType = shapeType;
    } else {
      System.out.println("Trying to set shapeType to null, returning");
    }
  }

  public void setStart(PVector start){
    if(start != null){
      this.start = start;
    } else {
      System.out.println("Trying to set start to null, returning");
    }
  }

  public PVector getStart(){
    if(this.start != null){
      return this.start;
    } else {
      System.out.println("Start is null, returning null");
      return null;
    }
  }

  public PVector getEnd(){
    return this.position;
  }

  public void setEnd(PVector end){
    if(end != null){
      this.position = end;
    } else {
      System.out.println("Trying to set end to null, returning");
      return;
    }
  }

  public void setAngle(float angle){
    this.angle = angle;
  }

  public float getAngle(){
    return this.angle;
  }

  public void setVisibility(boolean isVisible){
    this.isVisible = isVisible;
  }

  public boolean getVisibility(){
    return this.isVisible;
  }

  public void setIsForceVisible(boolean isForceVisible){
    this.isForceVisible = isForceVisible;
  }

  public boolean getIsForceVisible(){
    return this.isForceVisible;
  }

  public void setIsStatic(boolean isStatic){
    this.isStatic = isStatic;
  }

  public boolean getIsStatic(){
    return this.isStatic;
  }

  public void setIsCollidable(boolean isCollidable){
    this.isCollidable = isCollidable;
  }

  public boolean getIsCollidable(){
    return this.isCollidable;
  }




  /*
  ======================================================================================================
  ========================================== MOUSE INTERACTIVITY =======================================
  ======================================================================================================
  */
  public void OnMouseClick() {
    if(this.isMouseInteractive && PVector.dist(new PVector(mouseX, mouseY), this.position) < this.radius){
        this.isCurrentlyMouseInteractive = !this.isCurrentlyMouseInteractive;
    }
  }

  public void OnMouseMove() {
    if(this.isMouseInteractive && this.isCurrentlyMouseInteractive){
      this.position.x = mouseX;
      this.position.y = mouseY;
    }
  }

  public void setMouseInteractive(boolean isMouseInteractive){
    this.isMouseInteractive = isMouseInteractive;
  }
}