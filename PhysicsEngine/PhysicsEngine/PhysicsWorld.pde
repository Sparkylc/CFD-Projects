  
  public Rigidbody rigidbodyGenerator = new Rigidbody();
  public InteractivityListener interactivityListener = new InteractivityListener();
  public ArrayList<Rigidbody> rigidbodyArrayList = new ArrayList<Rigidbody>();


  public final float MIN_BODY_AREA = 0.01f * 0.01f; // m^2
  public final float MAX_BODY_AREA = 300f * 300f; // m^2

  public final float MIN_BODY_DENSITY = 0.1f; //g/cm^3
  public final float MAX_BODY_DENSITY = 30.0f; //g/cm^3

  public final PVector GRAVITY_VECTOR = new PVector(0, 9.81f, 0);
  public final float GRAVITY_MAG = 9.81f;

  public void AddBody(Rigidbody body) {
    rigidbodyArrayList.add(body);
  }

  public void RemoveBody(Rigidbody body) {
    rigidbodyArrayList.remove(body);
  }

  public void ClearBodies() {
    rigidbodyArrayList.clear();
  }

  public void RemoveBody(int index) {
    if(index < 0 || index >= rigidbodyArrayList.size()){
      throw new IndexOutOfBoundsException("Index: " + index + ", Size: " + rigidbodyArrayList.size());
    }
    rigidbodyArrayList.remove(index);
  }

  public Rigidbody getBody(int index) {
    if(index < 0 || index >= rigidbodyArrayList.size()){
      throw new IndexOutOfBoundsException("Index: " + index + ", Size: " + rigidbodyArrayList.size());
    }
    return rigidbodyArrayList.get(index);
  }

  public void Step(float dt) {
    for(Rigidbody rigidbody : rigidbodyArrayList) {
      rigidbody.update(dt);
    }
    for(int i = 0; i < rigidbodyArrayList.size() - 1; i++) {
      Rigidbody rigidbodyA = rigidbodyArrayList.get(i);
      for(int j = i + 1; j < rigidbodyArrayList.size(); j++) {
        Rigidbody rigidbodyB = rigidbodyArrayList.get(j);
         
        CollisionResult collisionResult = Collide(rigidbodyA, rigidbodyB);
        if(collisionResult.getIsColliding()) {
          rigidbodyA.Move(PVector.mult(collisionResult.getNormal(), -collisionResult.getDepth()/2));
          rigidbodyB.Move(PVector.mult(collisionResult.getNormal(), collisionResult.getDepth()/2));
        }
      }
    }
  }

  public CollisionResult Collide(Rigidbody rigidbodyA, Rigidbody rigidbodyB) {
    PVector normal = new PVector();
    float depth = 0f;
    boolean isColliding = false;

    ShapeType shapeTypeA = rigidbodyA.getShapeType();
    ShapeType shapeTypeB = rigidbodyB.getShapeType();

    if(shapeTypeA == ShapeType.BOX) {

      if(shapeTypeB == ShapeType.BOX) {

        return Collisions.IntersectPolygon(rigidbodyA.GetTransformedVertices(), rigidbodyB.GetTransformedVertices());

      } else if(shapeTypeB == ShapeType.CIRCLE) {
        CollisionResult result = Collisions.IntersectCirclePolygon(rigidbodyB.getPosition(), rigidbodyB.getRadius(), rigidbodyA.GetTransformedVertices());
        result.setNormal(result.getNormal().mult(-1));
        return result;

      }

    }
  if (shapeTypeA == ShapeType.CIRCLE) {
        
        if(shapeTypeB == ShapeType.BOX) {

          return Collisions.IntersectCirclePolygon(rigidbodyA.getPosition(), rigidbodyA.getRadius(), rigidbodyB.GetTransformedVertices());

        } else if(shapeTypeB == ShapeType.CIRCLE) {

          return Collisions.IntersectCircle(rigidbodyA.getPosition(), rigidbodyB.getPosition(), rigidbodyA.getRadius(), rigidbodyB.getRadius());

        }
      }
    return new CollisionResult(isColliding, normal, depth);
  }
  


