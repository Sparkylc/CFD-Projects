/*------------------------Related to Timekeeping Debugging --------------------------------------*/
public long totalWorldStepTime;
public long subWorldStepTime;

public int totalBodyCount;
public double systemTime;

public int totalSampleCount;
public int subSampleCount;

public double totalStepTime;
public double subStepTime;
public int bodyCount;

String totalStepTimeUnit;
String subStepTimeUnit;


int lastFrameTime;
float dt;
float fps;
float displayTimeStep;

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
public ArrayList<ArrayList<Integer>> collisionPairs = new ArrayList<ArrayList<Integer>>();
    

public PVector[] contactList = new PVector[0];
public PVector[] impulseList = new PVector[2];
public PVector[] raList = new PVector[2];
public PVector[] rbList = new PVector[2];
   


public final float MIN_BODY_AREA = 0.01f * 0.01f; // m^2
public final float MAX_BODY_AREA = 300f * 300f; // m^2

public final float MIN_BODY_DENSITY = 0.1f; //g/cm^3
public final float MAX_BODY_DENSITY = 30.0f; //g/cm^3

public final int MIN_ITERATIONS = 1;
public final int MAX_ITERATIONS = 128;

public PVector BACKGROUND_COLOUR = new PVector(16, 18, 19);


public final PVector GRAVITY_VECTOR = new PVector(0, 9.81f, 0);
public final float GRAVITY_MAG = 9.81f;



//Iterations for substeps for each frame
public void Step(float dt, int totalIterations) {
    
    
    /*-----------------Related to Timekeeping Debugging -----------------*/
    long totalWorldStepTimeStart = System.nanoTime();
    /*-------------------------------------------------------------------*/
    
    
    totalIterations = PhysEngMath.Clamp(totalIterations, MIN_ITERATIONS, MAX_ITERATIONS);
    
    for (int currentIteration = 0; currentIteration < totalIterations; currentIteration++) {
        
        /*-----------------Related to Timekeeping Debugging -----------------*/
        long subWorldStepTimeStart = System.nanoTime();
        /*-------------------------------------------------------------------*/
        
        
        this.collisionPairs.clear();

        StepBodies(dt, totalIterations);
        BroadPhaseStep();
        NarrowPhaseStep();
        
        
        
        
        
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


/*
====================================================================================================
=================================== Collision Resolution Methods ===================================
====================================================================================================
*/

public void SeperateBodies(Rigidbody rigidbodyA, Rigidbody rigidbodyB, PVector minimumTranslationVector) {
    
    if (rigidbodyA.getIsStatic()) {
        
        rigidbodyB.Move(minimumTranslationVector);
        
    } else if (rigidbodyB.getIsStatic()) {
        
        rigidbodyA.Move(PVector.mult(minimumTranslationVector, -1.0f));
        
    } else {
        
        rigidbodyA.Move(PVector.mult(minimumTranslationVector, -0.5f));
        rigidbodyB.Move(PVector.mult(minimumTranslationVector, 0.5f));
    }
}


public void ResolveCollisionLinear(CollisionManifold collisionManifold) {
    
    Rigidbody rigidbodyA = collisionManifold.getRigidbodyA();
    Rigidbody rigidbodyB = collisionManifold.getRigidbodyB();
    PVector normal = collisionManifold.getNormal();
    float depth = collisionManifold.getDepth();
    
    
    PVector velocityA = rigidbodyA.getVelocity().copy();
    PVector velocityB = rigidbodyB.getVelocity().copy();
    float restitution = min(rigidbodyA.getRestitution(), rigidbodyB.getRestitution());
    PVector relativeVelocity = PVector.sub(velocityB, velocityA);
    
    if (PVector.dot(relativeVelocity, normal) > 0.0f) {
        return;
    }
    
    float invMassA = rigidbodyA.getInvMass();
    float invMassB = rigidbodyB.getInvMass();
    
    float j = -(1f + restitution) * PVector.dot(relativeVelocity, normal) / (invMassA + invMassB);
    
    PVector impulse = PVector.mult(normal, j);
    
    
    velocityA = PVector.add(velocityA, PVector.mult(PVector.mult(impulse, -1), invMassA));
    velocityB = PVector.add(velocityB, PVector.mult(impulse, invMassB));
    
    rigidbodyA.setVelocity(velocityA);
    rigidbodyB.setVelocity(velocityB);
    
}

public void ResolveCollisionRotation(CollisionManifold contact) {
    Rigidbody rigidbodyA = contact.getRigidbodyA();
    Rigidbody rigidbodyB = contact.getRigidbodyB();
    float invMassA = rigidbodyA.getInvMass();
    float invMassB = rigidbodyB.getInvMass();
    float invRotationalInertiaA = rigidbodyA.getInvRotationalInertia();
    float invRotationalInertiaB = rigidbodyB.getInvRotationalInertia();
    PVector normal = contact.getNormal();
    PVector velocityA = rigidbodyA.getVelocity();
    PVector velocityB = rigidbodyB.getVelocity();
    float angularVelocityA = rigidbodyA.getAngularVelocity();
    float angularVelocityB = rigidbodyB.getAngularVelocity();

    int contactCount = contact.getContactCount();
    contactList = contact.getPointsOfContact();

    float e = min(rigidbodyA.getRestitution(), rigidbodyB.getRestitution());


    for(int i = 0; i < contactCount; i++) {
        this.impulseList[i] = new PVector();
        this.raList[i] = new PVector();
        this.rbList[i] = new PVector();
    }

    for (int i = 0; i < contactCount; i++) {
        PVector ra = PVector.sub(contactList[i], rigidbodyA.getPosition());
        PVector rb = PVector.sub(contactList[i], rigidbodyB.getPosition());

        raList[i] = ra;
        rbList[i] = rb;

        PVector raPerp = new PVector(-ra.y, ra.x);
        PVector rbPerp = new PVector(-rb.y, rb.x);

        PVector angularLinearVelocityA = PVector.mult(raPerp, angularVelocityA);
        PVector angularLinearVelocityB = PVector.mult(rbPerp, angularVelocityB);

        PVector relativeVelocity = PVector.sub(PVector.add(velocityB, angularLinearVelocityB),
                                               PVector.add(velocityA, angularLinearVelocityA));

        float contactVelocityMag = relativeVelocity.dot(normal);

        if (contactVelocityMag > 0f) {
            continue;
        }

        float raPerpDotN = raPerp.dot(normal);
        float rbPerpDotN = rbPerp.dot(normal);

        float denom = (invMassA + invMassB) +
            ((raPerpDotN * raPerpDotN) * invRotationalInertiaA) +
            ((rbPerpDotN * rbPerpDotN) * invRotationalInertiaB);

        float j = -(1f + e) * contactVelocityMag;
        j /= denom;
        j /= (float)contactCount;

        PVector impulse = PVector.mult(normal, j);
        impulseList[i] = impulse;
    }

    for(int i = 0; i < contactCount; i++) {
        PVector impulse = impulseList[i];
        PVector ra = raList[i];
        PVector rb = rbList[i];

        //float raCrossImpulse = ra.x * impulse.y - ra.y * impulse.x;
        //float rbCrossImpulse = rb.x * impulse.y - rb.y * impulse.x;

        velocityA.add(PVector.mult(impulse, -invMassA));
        velocityB.add(PVector.mult(impulse, invMassB));

        angularVelocityA += ra.cross(impulse).z * -1 * invRotationalInertiaA;
        angularVelocityB += rb.cross(impulse).z * invRotationalInertiaB;

        rigidbodyA.setVelocity(velocityA);
        rigidbodyB.setVelocity(velocityB);
        rigidbodyA.setAngularVelocity(angularVelocityA);
        rigidbodyB.setAngularVelocity(angularVelocityB);
    }
}
/*
==================================================================================================
============================ Broad & Narrow - Phase Collision Methods ============================
==================================================================================================
*/

public void BroadPhaseStep() {
    
    for (int i = 0; i < rigidbodyList.size() - 1; i++) {
        
        Rigidbody rigidbodyA = rigidbodyList.get(i);
        AABB rigidbodyA_AABB = rigidbodyA.GetAABB();
        
        
        
        for (int j = i + 1; j < rigidbodyList.size(); j++) {
            
            Rigidbody rigidbodyB = rigidbodyList.get(j);
            AABB rigidbodyB_AABB = rigidbodyB.GetAABB();
            
            
            if ((rigidbodyA.getIsStatic() && rigidbodyB.getIsStatic()) && (rigidbodyA.getInvMass() == 0f && rigidbodyB.getInvMass() == 0f)) {
                continue;
            }
            
            
            if (!Collisions.IntersectAABB(rigidbodyA_AABB, rigidbodyB_AABB)) {
                continue;
            }

            ArrayList<Integer> pair = new ArrayList<Integer>(Arrays.asList(i, j));
            collisionPairs.add(pair);
        }
    }
}

public void NarrowPhaseStep() {
    for (int i = 0; i < collisionPairs.size(); i++)
    {
        ArrayList<Integer> pair = collisionPairs.get(i);
        Rigidbody rigidbodyA = rigidbodyList.get(pair.get(0));
        Rigidbody rigidbodyB = rigidbodyList.get(pair.get(1));
        
        CollisionResult collisionResult = Collisions.Collide(rigidbodyA, rigidbodyB);
            
        if (collisionResult.getIsColliding()) {
                
            PVector minimumTranslationVector = PVector.mult(collisionResult.getNormal(), collisionResult.getDepth());
            
            SeperateBodies(rigidbodyA, rigidbodyB, minimumTranslationVector);
            Collisions.FindCollisionPoints(rigidbodyA, rigidbodyB, collisionResult);
            CollisionManifold collisionManifold = new CollisionManifold(rigidbodyA, rigidbodyB, collisionResult);
            this.ResolveCollisionRotation(collisionManifold);
                
        }
    }
}
        
public void StepBodies(float dt, int totalIterations) {

    for (Rigidbody rigidbody : rigidbodyList) {
        rigidbody.update(dt, totalIterations);
    }
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
   
   if(index < 0 || index >= rigidbodyList.size()) {
        throw new IndexOutOfBoundsException("Index: " + index + ", Size: " + rigidbodyList.size());
    }

    rigidbodyList.remove(index);
}

public Rigidbody GetBodyFromBodyEntityList(int index) {

    if(index < 0 || index >= rigidbodyList.size()) {
        throw new IndexOutOfBoundsException("Index: " + index + ", Size: " + rigidbodyList.size());
    }

    return rigidbodyList.get(index);
}
                        
public void ClearBodyEntityList() {
    rigidbodyList.clear();
}

public void displayTimings() {

if(millis() - systemTime>= 200) {
  totalStepTime = ((totalWorldStepTime) / totalSampleCount);
  subStepTime = ((subWorldStepTime) / subSampleCount);
  bodyCount = rigidbodyList.size();
  
  totalStepTimeUnit = "ns";
  subStepTimeUnit = "ns";

  if(totalStepTime > 1000) {
    totalStepTime /= 1000;
    totalStepTime = new BigDecimal(totalStepTime).setScale(3, RoundingMode.HALF_UP).doubleValue();
    totalStepTimeUnit = "μs";
  }
  if(subStepTime > 1000) {
    subStepTime /= 1000;
    subStepTime = new BigDecimal(subStepTime).setScale(3, RoundingMode.HALF_UP).doubleValue();
    subStepTimeUnit = "μs";
  }
  if (totalStepTime > 1000) {
    totalStepTime /= 1000;
    totalStepTime = new BigDecimal(totalStepTime).setScale(3, RoundingMode.HALF_UP).doubleValue();
    totalStepTimeUnit = "ms";
  }
  if (subStepTime > 1000) {
    subStepTime /= 1000;
    subStepTime = new BigDecimal(subStepTime).setScale(3, RoundingMode.HALF_UP).doubleValue();
    subStepTimeUnit = "ms";
  }

  //updates the counter and resets values
  totalWorldStepTime = 0;
  subWorldStepTime = 0;
  totalSampleCount = 0;
  subSampleCount = 0;
  systemTime = millis();

  fps = frameRate;
  displayTimeStep = dt;


}

text("Total Step Time: " + totalStepTime + totalStepTimeUnit, 10, 20);
text("Sub Step Time: " + subStepTime + subStepTimeUnit, 10, 40);
text("Body Count: " + bodyCount, 10, 60);
text("FPS: " + fps, 10, 80);
text("dt: " + displayTimeStep, 10, 100);
/*------------------------------------------------------------------------------------------------*/
}
             
                                        
                                        