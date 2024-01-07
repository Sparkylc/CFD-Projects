  
  //TIME KEEPING AND PERFOMANCE DEBUGGING STUFF
  public long totalWorldStepTime;
  public long subWorldStepTime;

  public int totalBodyCount;
  public double systemTime;

  public int totalSampleCount;
  public int subSampleCount;





  //===================================================================================================
  
  public Rigidbody RigidbodyGenerator = new Rigidbody();
  public InteractivityListener interactivityListener = new InteractivityListener();

  int aabbCollsionCount = 0;

  public ArrayList<Rigidbody> rigidbodyArrayList = new ArrayList<Rigidbody>();
  public ArrayList<CollisionManifold> collisionManifoldArrayList = new ArrayList<CollisionManifold>();
  public ArrayList<PVector> pointsOfContact = new ArrayList<PVector>();


  public final float MIN_BODY_AREA = 0.01f * 0.01f; // m^2
  public final float MAX_BODY_AREA = 300f * 300f; // m^2

  public final float MIN_BODY_DENSITY = 0.1f; //g/cm^3
  public final float MAX_BODY_DENSITY = 30.0f; //g/cm^3

  public final int MIN_ITERATIONS = 1;
  public final int MAX_ITERATIONS = 128;

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

  //Iterations for substeps for each frame
  public void Step(float dt, int iterations) {
    //TIMEKEEPING
    long totalWorldStepTimeStart = System.nanoTime();

    iterations = PhysEngMath.Clamp(iterations, MIN_ITERATIONS, MAX_ITERATIONS);

    this.pointsOfContact.clear();

  for(int it = 0; it < iterations; it++) {
    //TIMEKEEPING
    long subWorldStepTimeStart = System.nanoTime();


    for(Rigidbody rigidbody : rigidbodyArrayList) {
      rigidbody.update(dt, iterations);
    }

    this.collisionManifoldArrayList.clear();

    for(int i = 0; i < rigidbodyArrayList.size() - 1; i++) {

      Rigidbody rigidbodyA = rigidbodyArrayList.get(i);
      AABB rigidbodyA_AABB = rigidbodyA.GetAABB();



      for(int j = i + 1; j < rigidbodyArrayList.size(); j++) {

        Rigidbody rigidbodyB = rigidbodyArrayList.get(j);
        AABB rigidbodyB_AABB = rigidbodyB.GetAABB();


        if((rigidbodyA.getIsStatic() && rigidbodyB.getIsStatic()) && (rigidbodyA.getInvMass() == 0f && rigidbodyB.getInvMass() == 0f)) {
          continue;
        }

        
        if(!Collisions.IntersectAABB(rigidbodyA_AABB, rigidbodyB_AABB)) {
          continue;
        } 
        
        CollisionResult collisionResult = Collisions.Collide(rigidbodyA, rigidbodyB);

        if(collisionResult.getIsColliding()) {
          if(rigidbodyA.getIsStatic()) {

            rigidbodyB.Move(PVector.mult(collisionResult.getNormal(),collisionResult.getDepth()));

          } else if (rigidbodyB.getIsStatic()) {

            rigidbodyA.Move(PVector.mult(collisionResult.getNormal(),-collisionResult.getDepth()));

          } else {

            rigidbodyA.Move(PVector.mult(collisionResult.getNormal(),-collisionResult.getDepth() / 2));
            rigidbodyB.Move(PVector.mult(collisionResult.getNormal(),collisionResult.getDepth() / 2));  
          }

          Collisions.FindCollisionPoints(rigidbodyA, rigidbodyB, collisionResult);

          CollisionManifold collisionManifold = new CollisionManifold(rigidbodyA, rigidbodyB, collisionResult);
          collisionManifoldArrayList.add(collisionManifold);
        
      
        }
      }
    }
  for(int i = 0; i < this.collisionManifoldArrayList.size(); i++)
  {
    CollisionManifold contact = this.collisionManifoldArrayList.get(i);
    this.ResolveCollision(contact);

    if(contact.getContactCount() > 0) {

      if(!this.pointsOfContact.contains(contact.pointsOfContact[0])){

      this.pointsOfContact.add(contact.pointsOfContact[0]);

      }
    }

    if(contact.getContactCount() > 1) {

      if(!this.pointsOfContact.contains(contact.pointsOfContact[1])){

      this.pointsOfContact.add(contact.pointsOfContact[1]);

      }
    }
  }

  //TIMEKEEPING
  subSampleCount++;
  subWorldStepTime += System.nanoTime() - subWorldStepTimeStart;
  }
  //TIMEKEEPING
  totalSampleCount++;
  totalWorldStepTime += System.nanoTime() - totalWorldStepTimeStart;
  }

  public void ResolveCollision(CollisionManifold collisionManifold) {
    
    Rigidbody rigidbodyA = collisionManifold.getRigidbodyA();
    Rigidbody rigidbodyB = collisionManifold.getRigidbodyB();
    PVector normal = collisionManifold.getNormal();
    float depth = collisionManifold.getDepth();


    PVector velocityA = rigidbodyA.getVelocity().copy();
    PVector velocityB = rigidbodyB.getVelocity().copy();
    float restitution = min(rigidbodyA.getRestitution(), rigidbodyB.getRestitution());
    PVector relativeVelocity = PVector.sub(velocityB, velocityA);
    
    if(PVector.dot(relativeVelocity, normal) > 0.0f) {
      return;
    }
    
    float invMassA = rigidbodyA.getInvMass();
    float invMassB = rigidbodyB.getInvMass();

    float j = -(1f+restitution) * PVector.dot(relativeVelocity, normal) / (invMassA + invMassB);

    PVector impulse = PVector.mult(normal, j);


    velocityA = PVector.sub(velocityA, PVector.mult(impulse, invMassA));
    velocityB = PVector.add(velocityB, PVector.mult(impulse, invMassB));

    rigidbodyA.setVelocity(velocityA);
    rigidbodyB.setVelocity(velocityB);

  }

  


