  /*------------------------Related to Timekeeping Debugging --------------------------------------*/
  public long totalWorldStepTime;
  public long subWorldStepTime;

  public int totalBodyCount;
  public double systemTime;

  public int totalSampleCount;
  public int subSampleCount;
/*----------------------------------------------------------------------------------------------*/




/*
====================================================================================================
===================================  PHYSICS ENGINE CONSTANTS  =====================================
====================================================================================================
*/
  public Rigidbody RigidbodyGenerator = new Rigidbody();
  public InteractivityListener interactivityListener = new InteractivityListener();
  public Shape render = new Shape();


  public ArrayList<Rigidbody> rigidbodyList = new ArrayList<Rigidbody>();
  public ArrayList<CollisionManifold> collisionManifoldArrayList = new ArrayList<CollisionManifold>();


  /*---------------------------------Points of Contact Debugging --------------------------------- 
    public boolean showCollisionPoints = true;
    public ArrayList<PVector> pointsOfContact = new ArrayList<PVector>();
  ---------------------------------------------------------------------------------------------- */

  public final float MIN_BODY_AREA = 0.01f * 0.01f; // m^2
  public final float MAX_BODY_AREA = 300f * 300f; // m^2

  public final float MIN_BODY_DENSITY = 0.1f; //g/cm^3
  public final float MAX_BODY_DENSITY = 30.0f; //g/cm^3

  public final int MIN_ITERATIONS = 1;
  public final int MAX_ITERATIONS = 128;


  public final PVector GRAVITY_VECTOR = new PVector(0, 9.81f, 0);
  public final float GRAVITY_MAG = 9.81f;



  //Iterations for substeps for each frame
  public void Step(float dt, int totalIterations) {


/*-----------------Related to Timekeeping Debugging -----------------*/
      long totalWorldStepTimeStart = System.nanoTime();
/*-------------------------------------------------------------------*/

/* ------------------------Points of Contact Debugging Variable-------------------------------------
      this.pointsOfContact.clear();
/* ----------------------------------------------------- */

    totalIterations = PhysEngMath.Clamp(totalIterations, MIN_ITERATIONS, MAX_ITERATIONS);

  for(int currentIteration = 0; currentIteration < totalIterations; currentIteration++) {

    /*-----------------Related to Timekeeping Debugging -----------------*/
      long subWorldStepTimeStart = System.nanoTime();
    /*-------------------------------------------------------------------*/


    for(Rigidbody rigidbody : rigidbodyList) {
      rigidbody.update(dt, totalIterations);
    }

    this.collisionManifoldArrayList.clear();

    for(int i = 0; i < rigidbodyList.size() - 1; i++) {

      Rigidbody rigidbodyA = rigidbodyList.get(i);
      AABB rigidbodyA_AABB = rigidbodyA.GetAABB();



      for(int j = i + 1; j < rigidbodyList.size(); j++) {

        Rigidbody rigidbodyB = rigidbodyList.get(j);
        AABB rigidbodyB_AABB = rigidbodyB.GetAABB();


        if((rigidbodyA.getIsStatic() && rigidbodyB.getIsStatic()) && (rigidbodyA.getInvMass() == 0f && rigidbodyB.getInvMass() == 0f)) {
          continue;
        }

        
        if(!Collisions.IntersectAABB(rigidbodyA_AABB, rigidbodyB_AABB)) {
          continue;
        } 
        

        //The result of the collision which holds the collision values
        CollisionResult collisionResult = Collisions.Collide(rigidbodyA, rigidbodyB);

        if(collisionResult.getIsColliding()) {

          PVector minimumTranslationVector = PVector.mult(collisionResult.getNormal(), collisionResult.getDepth());

          SeperateBodies(rigidbodyA, rigidbodyB, minimumTranslationVector);

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

/* ---------------------------------Points of Contact Debugging --------------------------------- */
/*
      if(currentIteration == totalIterations - 1) {
      if(!this.pointsOfContact.contains(contact.pointsOfContact[0])){

        this.pointsOfContact.add(contact.pointsOfContact[0]);

      }
      
      if(contact.getContactCount() > 1) {

        if(!this.pointsOfContact.contains(contact.pointsOfContact[1])){

          this.pointsOfContact.add(contact.pointsOfContact[1]);
      }
    }
  }
*/
/* ---------------------------------------------------------------------------------------------- */

}


  /*-----------------Related to Timekeeping Debugging -----------------*/ 
  subSampleCount++;
  subWorldStepTime += System.nanoTime() - subWorldStepTimeStart;
  /*-------------------------------------------------------------------*/
  }
  /*-----------------Related to Timekeeping Debugging -----------------*/
  totalSampleCount++;
  totalWorldStepTime += System.nanoTime() - totalWorldStepTimeStart;
  /*-------------------------------------------------------------------*/
  }



  private void SeperateBodies(Rigidbody rigidbodyA, Rigidbody rigidbodyB, PVector minimumTranslationVector) { 
    
     if(rigidbodyA.getIsStatic()) {

            rigidbodyB.Move(minimumTranslationVector);

          } else if (rigidbodyB.getIsStatic()) {

            rigidbodyA.Move(PVector.mult(minimumTranslationVector, -1.0f));

          } else {

            rigidbodyA.Move(PVector.mult(minimumTranslationVector, -0.5f));
            rigidbodyB.Move(PVector.mult(minimumTranslationVector, 0.5f));  
          }
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

  /*
  ==================================================================================================
  ======================================== Helper Methods  =========================================
  ==================================================================================================
  */
   public void AddBodyToBodyEntityList(Rigidbody body) {
    rigidbodyList.add(body);
  }

  public void RemoveBodyFromBodyEntityList(Rigidbody body) {
    rigidbodyList.remove(body);
  }
  
  public void RemoveBodyFromBodyEntityList(int index) {
    if(index < 0 || index >= rigidbodyList.size()){
      throw new IndexOutOfBoundsException("Index: " + index + ", Size: " + rigidbodyList.size());
    }
    rigidbodyList.remove(index);
  }

  public Rigidbody GetBodyFromBodyEntityList(int index) {
    if(index < 0 || index >= rigidbodyList.size()){
      throw new IndexOutOfBoundsException("Index: " + index + ", Size: " + rigidbodyList.size());
    }
    return rigidbodyList.get(index);
  }

  public void ClearBodyEntityList() {
    rigidbodyList.clear();
  }


  


