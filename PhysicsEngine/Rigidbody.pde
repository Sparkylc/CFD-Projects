public class Rigidbody {

  //Capital letter denotes read only

  private PVector position;
  private PVector linearVelocity;
  private float angle;
  private float angularVelocity;
    
  private ShapeType ShapeType;
  private float Mass;
  private float InvMass;
  private float Density;
  private float Restitution;
  private float Area;
  private float RotationalInertia;
  private float InvRotationalInertia;
  private float Radius;
  private float Width;
  private float Height;
  private float coefficientOfStaticFriction;
  private float coefficientOfKineticFriction;
  

  private PVector[] Vertices;
  private AABB aabb;
  private PVector[] transformedVertices;



  private Shape shapeRenderer;
  private float strokeWeight;
  private PVector strokeColour;
  private PVector fillColour;
  
  private boolean transformUpdateRequired;
  private boolean aabbUpdateRequired;
  
  private boolean isStatic;
  private boolean isVisible;
  private boolean isCollidable;
  private boolean isMouseInteractive;
  private boolean isSelected;
  
  //TESTING THIS OUT
  private float scaleFactor = 10.0f; //10px are 1 meter
  

  
  

  
  private ArrayList<ForceRegistry> forceRegistry = new ArrayList<ForceRegistry>();
  
  
  
  
  
  
  /*
  ==================================================================================================
  ==================================CONSTRUCTORS====================================================
  ==================================================================================================
  */
  public Rigidbody() {
    //do nothing
  }
  
  private Rigidbody(float density, float mass, float rotationalIntertia, float restitution,
    float area, float radius, float width, float height, PVector[] vertices, boolean isStatic,
    boolean isCollidable, boolean isMouseInteractive, float strokeWeight,
    PVector strokeColour, PVector fillColour, ShapeType shapeType)
  {
    this.Mass = mass;
    this.RotationalInertia = rotationalIntertia;
    this.InvMass = mass > 0 ? 1 / mass : 0;
    this.InvRotationalInertia = rotationalIntertia > 0 ? 1 / rotationalIntertia : 0;


    this.Density = density;
    this.Restitution = restitution;
    this.Area = area;
    this.Radius = radius;
    this.Width = width;
    this.Height = height;

    this.coefficientOfStaticFriction = 0.8f;
    this.coefficientOfKineticFriction = 0.3f;
  

    this.ShapeType = shapeType;
    this.strokeWeight = strokeWeight;
    this.strokeColour = strokeColour;
    this.fillColour = fillColour;


    this.isStatic = isStatic;
    this.isCollidable = isCollidable;
    this.isMouseInteractive = isMouseInteractive;
    this.isVisible = true;

  

    this.position = new PVector();
    this.linearVelocity = new PVector();
    this.angle = 0f;
    this.angularVelocity = 0f;
    
    
    if (shapeType == ShapeType.BOX) {

      this.Vertices = vertices;
      this.transformedVertices = new PVector[this.Vertices.length];
      this.aabb = this.GetAABB();
      
    } else {

      this.Vertices = null;
      this.transformedVertices = null;
    }
    
    //Sets InvMass for static objects to 0

    
    this.aabbUpdateRequired = true;
    this.transformUpdateRequired = true;
  }
  
  
  
  /*
  ==================================================================================================
  ========================== BODY & COLLIDER GEOMETRY METHODS ======================================
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

  
  public PVector[] GetTransformedVertices() {
    if (this.transformUpdateRequired) {

      for (int i = 0; i < this.Vertices.length; i++) {

        PVector vertex = this.Vertices[i];

        this.transformedVertices[i] = PhysEngMath.Transform(vertex, this.position, this.angle);
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
  
  
  public Rigidbody CreateCircleBody(float radius, float density,
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


    float mass = 0f;
    float rotationalIntertia = 0f;

    if(!isStatic) {
      mass = area * density;
      rotationalIntertia =  0.5f * mass * radius * radius;
    }
    


    rigidbody = new Rigidbody(density, mass, rotationalIntertia, restitution, area, radius, 0, 0,
                              null, isStatic, isCollidable, isMouseInteractive, strokeWeight,
                              strokeColour, fillColour, ShapeType.CIRCLE);
    
    System.out.println("Rigidbody created with mass: " + mass + " and area: " + area);
    return rigidbody;
  }
  
  public Rigidbody CreateBoxBody(float width, float height, float density,
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
    float mass = 0f;
    float rotationalIntertia = 0f;

    if(!isStatic) {
      mass = area * density;
      rotationalIntertia = 0.5f * mass * width * width + height * height;
    }

    PVector[] vertices = CreateBoxVertices(width, height);
    
    rigidbody = new Rigidbody(density, mass, rotationalIntertia, restitution, area, 0, width,
                              height, vertices, isStatic, isCollidable, isMouseInteractive,
                              strokeWeight, strokeColour, fillColour, ShapeType.BOX);
    
    System.out.println("Rigidbody created with mass: " + mass + " and area: " + area);
    
    return rigidbody;
  }

  public AABB GetAABB() {
    if(this.aabbUpdateRequired) {
    float minX = Float.MAX_VALUE;
    float minY = Float.MAX_VALUE;
    float maxX = -Float.MAX_VALUE;
    float maxY = -Float.MAX_VALUE;
    
    if(this.ShapeType == ShapeType.CIRCLE) {
      
      minX = this.position.x - this.Radius;
      minY = this.position.y - this.Radius;
      maxX = this.position.x + this.Radius;
      maxY = this.position.y + this.Radius;

    } else if (this.ShapeType == ShapeType.BOX) {
  PVector[] vertices = this.GetTransformedVertices();
  for (PVector vertex : vertices) {
    if (vertex.x < minX) {
      minX = vertex.x;
    }
    if (vertex.x > maxX) {
      maxX = vertex.x;
    }
    if (vertex.y < minY) {
      minY = vertex.y;
    }
    if (vertex.y > maxY) {
      maxY = vertex.y;
    }
  }
    }

this.aabb = new AABB(new PVector(minX, minY), new PVector(maxX, maxY));
  this.aabbUpdateRequired = false;

  }
  return this.aabb;
}

  /*
  ==================================================================================================
  ==================================METHODS=========================================================
  ==================================================================================================
  */
  public void Move(PVector amount) {
    this.position.add(amount);

    this.transformUpdateRequired = true;
    this.aabbUpdateRequired = true;
  }
  
  public void MoveTo(PVector position) {
    this.position = position;

    this.transformUpdateRequired = true;
    this.aabbUpdateRequired = true;
  }

  public void SetInitialPosition(PVector position) {
    this.position = position;
    this.transformUpdateRequired = true;
    this.aabbUpdateRequired = true;
  }
  
  public void Rotate(float amount) {
    this.angle += amount;

    this.transformUpdateRequired = true;
    this.aabbUpdateRequired = true;
  }

  public void RotateTo(float angle) {
    this.angle = angle;

    this.transformUpdateRequired = true;
    this.aabbUpdateRequired = true;
  }
  
  public void mouseInteraction() {
    if (this.isMouseInteractive) {
      if (PVector.sub(interactivityListener.screenToWorld(mouseX, mouseY), this.position).magSq() <= this.Radius * this.Radius) {
        this.isSelected = !this.isSelected;

        this.transformUpdateRequired = true;
        this.aabbUpdateRequired = true;
      } else {
        this.isSelected = false;
      }
    }
  }
  public void updateMouseInteraction() {
    if (this.isSelected) {

      this.position = interactivityListener.screenToWorld(mouseX, mouseY);

      this.transformUpdateRequired = true;
      this.aabbUpdateRequired = true;
    }
  }
  

  /*
  ==================================================================================================
  ==================================UPDATE==========================================================
  ==================================================================================================
  */
  
  public void update(float dt, int iterations) {
    if(this.isStatic) {
      this.aabbUpdateRequired = false;
      return;
    } else {
      this.aabbUpdateRequired = true;
      this.transformUpdateRequired = true;
      dt /= (float)iterations;
      this.RK4Position(dt);
      this.angularIntegration(dt);
    }
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
    
    this.position = finalPosition.copy();
    this.linearVelocity = finalVelocity.copy();
    this.transformUpdateRequired = true;
  }
  
  public void angularIntegration(float dt) {
    //float angularAcceleration = calculateAngularAcceleration();
    //this.angularVelocity += angularAcceleration*dt;
    this.angle += this.angularVelocity*dt;
  }

  public PVector calculateAcceleration(PVector position) {
    
    PVector netForce = new PVector();
    for (ForceRegistry force : this.forceRegistry) {
      netForce.add(force.getForce(this, position));
    }
    return PVector.div(netForce, this.Mass);
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
  
  
  public boolean getIsColliding() {
    return this.isCollidable;
  }
  
  public boolean getIsMouseInteractive() {
    return this.isMouseInteractive;
  }
  
  public PVector[] getVertices() {
    return this.Vertices;
  }
  
  public float getInvMass() {
    return this.InvMass;
  }

  public float getRotationalInertia() {
    return this.RotationalInertia;
  }

  public float getInvRotationalInertia() {
    return this.InvRotationalInertia;
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
  //Overloaded method for setting stroke colour with 3 floats
  public void setStrokeColour(float r, float g, float b) {
    this.strokeColour = new PVector(r, g, b);
  }
  
  public PVector getFillColour() {
    return this.fillColour;
  }
  
  
  public void setFillColour(PVector fillColour) {
    this.fillColour = fillColour;
  }
  //Overloaded method for setting fill colour with 3 floats
  public void setFillColour(float r, float g, float b) {
    this.fillColour = new PVector(r, g, b);
  }
  
  public ArrayList<ForceRegistry> getForceRegistry() {
    return this.forceRegistry;
  }
  
  public ForceRegistry getForceFromForceRegistry(int index) {
    return this.forceRegistry.get(index);
  }
  
  public int getForceRegistrySize() {
    return this.forceRegistry.size();
  }
  
  public void addForceToForceRegistry(ForceRegistry forceRegistry) {
    this.forceRegistry.add(forceRegistry);
  }
  public void clearForceRegistry() {
    this.forceRegistry.clear();
  }
  public void removeForceFromForceRegistry(ForceRegistry forceRegistry) {
    this.forceRegistry.remove(forceRegistry);
  }
  
  public void removeForceFromForceRegistry(int index) {
    this.forceRegistry.remove(index);
  }
  
  public boolean getIsStatic() {
    return this.isStatic;
  }
  
  public void setIsStatic(boolean isStatic) {
    this.isStatic = isStatic;
  }

  public boolean getIsVisible() {
    return this.isVisible;
  }

  public void setIsVisible(boolean isVisible) {
    this.isVisible = isVisible;
  }
    public float getAngle() {
    return this.angle;
  }

  public void setAngle(float angle) {
    this.angle = angle;
  }

  public float getAngularVelocity(){
    return this.angularVelocity;
  }

  public void setAngularVelocity(float angularVelocity) {
    this.angularVelocity = angularVelocity;
  }


public float getCoefficientOfKineticFriction() {
    return this.coefficientOfKineticFriction;
}

public void setCoefficientOfKineticFriction(float coefficientOfKineticFriction) {
    this.coefficientOfKineticFriction = coefficientOfKineticFriction;
}

public float getCoefficientOfStaticFriction() {
    return this.coefficientOfStaticFriction;
}

public void setCoefficientOfStaticFriction(float coefficientOfStaticFriction) {
    this.coefficientOfStaticFriction = coefficientOfStaticFriction;
}

}