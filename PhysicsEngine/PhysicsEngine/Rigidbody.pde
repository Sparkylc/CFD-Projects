public class Rigidbody {
  private PVector position;
  private PVector linearVelocity;
  private float rotation;
  private float angularVelocity;
  
  
  
  
  
  //Capital letter denotes read only
  private float Mass;
  private float Density;
  private float Restitution; //how bouncy it is
  private float Area;
  
  
  private float Radius;
  private float Width;
  private float Height;
  
  private PVector[] Vertices;
  public int[] Triangles;
  private PVector[] transformedVertices;
  
  private boolean transformUpdateRequired;
  
  
  private float strokeWeight;
  private PVector strokeColour;
  private PVector fillColour;
  
  
  private ShapeType ShapeType;
  private Shape shapeRenderer = new Shape(this);
  
  private boolean IsStatic;
  private boolean IsCollidable;
  private boolean IsMouseInteractive = true;
  public boolean isSelected;
  
  
  
  
  /*
  ==================================================================================================
  ==================================CONSTRUCTORS====================================================
  ==================================================================================================
  */
  public Rigidbody() {
    //do nothing
  }
  
  private Rigidbody(PVector position, float density, float mass, float restitution, 
    float area, float radius, float width, float height, boolean isStatic,
    boolean isCollidable, boolean isMouseInteractive, float strokeWeight,
    PVector strokeColour, PVector fillColour, ShapeType shapeType)
  {
    this.position = position;
    this.linearVelocity =  new PVector(10, 10);
    this.rotation = 0f;
    this.angularVelocity = 0f;
    
    this.Mass = mass;
    this.Density = density;
    this.Restitution = restitution;
    this.Area = area;
    
    this.Radius = radius;
    this.Width = width;
    this.Height = height;
    
    this.ShapeType = shapeType;
    this.IsStatic = isStatic;
    this.IsCollidable = isCollidable;
    this.IsMouseInteractive = isMouseInteractive;
    
    this.strokeWeight = strokeWeight;
    this.strokeColour = strokeColour;
    this.fillColour = fillColour;
    
    if (shapeType == ShapeType.BOX) {
      this.Vertices = CreateBoxVertices(this.Width, this.Height);
      this.Triangles = CreateBoxTriangles();
      this.transformedVertices = new PVector[this.Vertices.length];
      
    } else {
      this.Vertices = null;
      this.transformedVertices = null;
      this.Triangles = null;
    }
    
    this.transformUpdateRequired = true;
  }
  
  
  
  /*
  ==================================================================================================
  ==================================SHAPE-GENERATORS================================================
  ==================================================================================================
  */
  private PVector[] CreateBoxVertices(float width, float height) {
    float left = -width / 2;
    float right = width / 2;
    float top = height / 2;
    float bottom = -height / 2;
    
    PVector[] vertices = new PVector[4];
    vertices[0] = new PVector(left, top);
    vertices[1] = new PVector(right, top);
    vertices[2] = new PVector(right, bottom);
    vertices[3] = new PVector(left, bottom);
    return vertices;
  }
  
  private int[] CreateBoxTriangles() {
    int[] triangles = new int[6];
    triangles[0] = 0;
    triangles[1] = 1;
    triangles[2] = 2;
    triangles[3] = 0;
    triangles[4] = 2;
    triangles[5] = 3; 
    return triangles;
    
  }
  
  public PVector[] GetTransformedVertices() {
    if (this.transformUpdateRequired) {
      for (int i = 0; i < this.Vertices.length; i++) {
        PVector vertex = this.Vertices[i];
        this.transformedVertices[i] = PhysEngMath.Transform(vertex, this.position, this.rotation);
      } 
    } 
    
    /*
    The way this transform system works, is that it caches the transformed vertices,
    and only transforms them once a change has been made. This means that,
    if no change is made is made, cached vertices are returned.
    if the transform is updated, the vertices are transformed, and the cache is updated.
    */
    
    this.transformUpdateRequired = false;
    return this.transformedVertices;
  }
  

  public Rigidbody CreateCircleBody(float radius, PVector position, float density, 
    float restitution, boolean isStatic, boolean isCollidable, 
    boolean isMouseInteractive, float strokeWeight, 
    PVector strokeColour, PVector fillColour) {
    Rigidbody rigidbody;
    
    float area = (float) PI * radius * radius;
    
    //Argument exceptions for area and density
    if (area < MIN_BODY_AREA) {
      throw new IllegalArgumentException("Body area is too small, radius too small. Min area is " + MIN_BODY_AREA);
    }
    if (area > MAX_BODY_AREA) {
      throw new IllegalArgumentException("Body area is too large, radius too large. Max area is " + MAX_BODY_AREA);
    }
    if (density < MIN_BODY_DENSITY) {
      throw new IllegalArgumentException("Density is too small. Min density is " + MIN_BODY_DENSITY);
    }
    if (density > MAX_BODY_DENSITY) {
      throw new IllegalArgumentException("Density is too large. Max density is " + MAX_BODY_DENSITY);
    }
    
    //Clamps restitution between 0 and 1
    restitution = PhysEngMath.Clamp(restitution, 0, 1);
    
    float mass = area * density;
    
    rigidbody = new Rigidbody(position, density, mass, restitution, area, radius, 0, 0, isStatic, isCollidable, isMouseInteractive, strokeWeight, strokeColour, fillColour, ShapeType.CIRCLE);
    
    System.out.println("Rigidbody created with mass: " + mass + " and area: " + area);
    return rigidbody;
  }
  
  public Rigidbody CreateBoxBody(float width, float height, PVector position, float density, 
    float restitution, boolean isStatic, boolean isCollidable, 
    boolean isMouseInteractive, float strokeWeight, 
    PVector strokeColour, PVector fillColour) {
    Rigidbody rigidbody; 
    
    float area = width * height;
    
    //Argument exceptions for area and density
    if (area < MIN_BODY_AREA) {
      throw new IllegalArgumentException("Body area is too small, dimensions too small. Min area is " + MIN_BODY_AREA);
    }
    if (area > MAX_BODY_AREA) {
      throw new IllegalArgumentException("Body area is too large, dimensions too large. Max area is " + MAX_BODY_AREA);
    }
    if (density < MIN_BODY_DENSITY) {
      throw new IllegalArgumentException("Density is too small. Min density is " + MIN_BODY_DENSITY);
    }
    if (density > MAX_BODY_DENSITY) {
      throw new IllegalArgumentException("Density is too large. Max density is " + MAX_BODY_DENSITY);
    }
    
    //Clamps restitution between 0 and 1
    restitution = PhysEngMath.Clamp(restitution, 0, 1);
    
    //calculates mass from density and area
    float mass = area * density;
    
    rigidbody = new Rigidbody(position, density, mass, restitution, area, 0, width, height, isStatic, isCollidable, isMouseInteractive, strokeWeight, strokeColour, fillColour, ShapeType.BOX);
    
    System.out.println("Rigidbody created with mass: " + mass + " and area: " + area);
    
    return rigidbody;
  }
  
  /*
  ==================================================================================================
  ==================================METHODS=========================================================
  ==================================================================================================
  */
  
  public void draw() {
    shapeRenderer.draw();
  }
  
  public void Move(PVector amount) {
    this.position.add(amount);
    this.transformUpdateRequired = true;
  }
  
  public void MoveTo(PVector position) {
    this.position = position;
    this.transformUpdateRequired = true;
  }
  
  public void Rotate(float amount) {
    this.rotation += amount;
    this.transformUpdateRequired = true;
  }
  
  public void mouseInteraction() {
    if (this.IsMouseInteractive) {
      if (PVector.sub(interactivityListener.screenToWorld(mouseX, mouseY), this.position).magSq() <= this.Radius * this.Radius) {
        this.isSelected = !this.isSelected;
      } else {
        this.isSelected = false;
      }
    }
  }
  public void updateMouseInteraction() {
    if (this.isSelected) {
      this.position = interactivityListener.screenToWorld(mouseX, mouseY);
    }
  }


  public void update(float dt) {
      this.RK4Position(dt);
  }

  /*
  ==================================================================================================
  ================================== INTEGRATOR ====================================================
  ==================================================================================================
  */
  public void RK4Position(float dt) {

    PVector initialPosition = this.position.copy();
    PVector initialVelocity = this.linearVelocity.copy();

    // k1 calculations
    PVector k1_v = PVector.mult(calculateAcceleration(initialPosition), dt);
    PVector k1_r = PVector.mult(initialVelocity, dt);

    // k2 calculations
    PVector k2_v = PVector.mult(calculateAcceleration(PVector.add(initialPosition, PVector.mult(k1_r, 0.5f))), dt);
    PVector k2_r = PVector.mult(PVector.add(initialVelocity, PVector.mult(k1_v, 0.5f)), dt);

    // k3 calculations
    PVector k3_v = PVector.mult(calculateAcceleration(PVector.add(initialPosition, PVector.mult(k2_r, 0.5f))), dt);
    PVector k3_r = PVector.mult(PVector.add(initialVelocity, PVector.mult(k2_v, 0.5f)), dt);

    // k4 calculations
    PVector k4_v = PVector.mult(calculateAcceleration(PVector.add(initialPosition, k3_r)), dt);
    PVector k4_r = PVector.mult(PVector.add(initialVelocity, k3_v), dt);

    // Combine the slopes to get final position and velocity
    PVector finalPosition = PVector.add(initialPosition, PVector.mult(PVector.add(k1_r, PVector.add(PVector.mult(k2_r, 2), PVector.add(PVector.mult(k3_r, 2), k4_r))), 1.0f / 6.0f));
    PVector finalVelocity = PVector.add(initialVelocity, PVector.mult(PVector.add(k1_v, PVector.add(PVector.mult(k2_v, 2), PVector.add(PVector.mult(k3_v, 2), k4_v))), 1.0f / 6.0f));

    this.position = finalPosition;
    this.linearVelocity = finalVelocity;
    this.transformUpdateRequired = true;
  }

  //TODO: Implement RK4 ACCELERATION FUNCTION FOR ANGULAR ACCELL AND NORMAL ACELL
  public PVector calculateAcceleration(PVector position){
    return new PVector(0,0);
  }
  
  /*
  ==================================================================================================
  ==================================READ-ONLY FIELDS================================================
  ==================================================================================================
  */
  
  public float getMass() {
    return this.Mass;
  }
  
  public float getDensity() {
    return this.Density;
  }
  
  public float getRestitution() {
    return this.Restitution;
  }
  
  public float getArea() {
    return this.Area;
  }
  
  public float getRadius() {
    return this.Radius;
  }
  
  public float getWidth() {
    return this.Width;
  }
  
  public float getHeight() {
    return this.Height;
  }
  
  public ShapeType getShapeType() {
    return this.ShapeType;
  }
  
  public boolean getIsStatic() {
    return this.IsStatic;
  }
  
  public boolean getIsColliding() {
    return this.IsCollidable;
  }
  
  public boolean getIsMouseInteractive() {
    return this.IsMouseInteractive;
  }
  
  public PVector[] getVertices() {
    return this.Vertices;
  }
  
  public int[] getTriangles() {
    return this.Triangles;
  }
  
  /*
  ==================================================================================================
  ==================================GETTERS & SETTERS===============================================
  ==================================================================================================
  */
  
  public boolean getTransformUpdateRequired() {
    return this.transformUpdateRequired;
  }
  
  public void setTransformUpdateRequired(boolean transformUpdateRequired) {
    this.transformUpdateRequired = transformUpdateRequired;
  }
  
  public PVector getPosition() {
    return this.position;
  }
  
  public void setPosition(PVector position) {
    this.position = position;
  }
  public PVector getVelocity() {
    return this.linearVelocity;
  }

  public void setVelocity(PVector velocity) {
    this.linearVelocity = velocity;
  }
  
  public boolean getIsSelected() {
    return this.isSelected;
  }
  
  public void setIsSelected(boolean isSelected) {
    this.isSelected = isSelected;
  }
  
  public float getStrokeWeight() {
    return this.strokeWeight;
  }
  
  public void setStrokeWeight(float strokeWeight) {
    this.strokeWeight = strokeWeight;
  }
  
  public PVector getStrokeColour() {
    return this.strokeColour;
  }
  
  public void setStrokeColour(PVector strokeColour) {
    this.strokeColour = strokeColour;
  }
  
  public PVector getFillColour() {
    return this.fillColour;
  }
  
  public void setFillColour(PVector fillColour) {
    this.fillColour = fillColour;
  }
  
  
}