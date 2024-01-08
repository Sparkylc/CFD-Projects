public static class Collisions {
  CollisionResult collisionResult;

  //This is required as there is no enclosing instance of physics class for collisionResult
  public static PhysicsEngine physicsEngine = new PhysicsEngine();

/*
====================================================================================================
===================================== COLLIDE INFO =================================================
====================================================================================================
*/
public static CollisionResult Collide(Rigidbody rigidbodyA, Rigidbody rigidbodyB) {
    PVector normal = new PVector();
    float depth = 0f;
    boolean isColliding = false;

    ShapeType shapeTypeA = rigidbodyA.getShapeType();
    ShapeType shapeTypeB = rigidbodyB.getShapeType();

    if(shapeTypeA == ShapeType.BOX) {

      if(shapeTypeB == ShapeType.BOX) {

        return IntersectPolygon(rigidbodyA.getPosition(),
                                           rigidbodyA.GetTransformedVertices(),
                                           rigidbodyB.getPosition(),
                                           rigidbodyB.GetTransformedVertices());

      } else if(shapeTypeB == ShapeType.CIRCLE) {
        CollisionResult result = Collisions.IntersectCirclePolygon(rigidbodyB.getPosition(),
                                                                   rigidbodyB.getRadius(),
                                                                   rigidbodyA.getPosition(),
                                                                   rigidbodyA.GetTransformedVertices()
                                                                   );
        
        result.setNormal(result.getNormal().mult(-1).copy());
        return result;

      }

    }
  if (shapeTypeA == ShapeType.CIRCLE) {
        
        if(shapeTypeB == ShapeType.BOX) {

          return IntersectCirclePolygon(rigidbodyA.getPosition(), 
                                                   rigidbodyA.getRadius(), 
                                                   rigidbodyB.getPosition(), 
                                                   rigidbodyB.GetTransformedVertices());

        } else if(shapeTypeB == ShapeType.CIRCLE) {

          return IntersectCircle(rigidbodyA.getPosition(), rigidbodyB.getPosition(), rigidbodyA.getRadius(), rigidbodyB.getRadius());

        }
      }
    return physicsEngine.new CollisionResult(isColliding, normal, depth);
  }


/*
====================================================================================================
===================================== CONTACT-POINTS COLLISIONS ====================================
======================================= COLLISION-RESULT ===========================================
*/

//TODO: OVERLOAD THIS METHOD TO RETURN A NEW COLLISIONRESULT WITH THE CONTACT POINTS RATHER THAN
//ACCEPTING AN INPUT COLLISIONRESULT AND CHANGING IT


public static void FindCollisionPoints(Rigidbody rigidbodyA, Rigidbody rigidbodyB,
                                                  CollisionResult collisionResult) {


    PVector[] pointsOfContact = new PVector[0];
    int contactCount = 0;

    ShapeType shapeTypeA = rigidbodyA.getShapeType();
    ShapeType shapeTypeB = rigidbodyB.getShapeType();

if(shapeTypeA == ShapeType.BOX) {

      if(shapeTypeB == ShapeType.BOX) {
        pointsOfContact = FindPolygonsCollisionPoints(rigidbodyA.GetTransformedVertices(),
                                                      rigidbodyB.GetTransformedVertices());
        contactCount = pointsOfContact.length;

      } else if(shapeTypeB == ShapeType.CIRCLE) {

          pointsOfContact = FindCirclePolygonCollisionPoint(rigidbodyB.getPosition(),
                                                            rigidbodyB.getRadius(),
                                                            rigidbodyA.getPosition(),
                                                            rigidbodyA.GetTransformedVertices());
        contactCount = 1;
      }

    }
  if (shapeTypeA == ShapeType.CIRCLE) {
        
        if(shapeTypeB == ShapeType.BOX) {
          
          pointsOfContact = FindCirclePolygonCollisionPoint(rigidbodyA.getPosition(),
                                                            rigidbodyA.getRadius(),
                                                            rigidbodyB.getPosition(),
                                                            rigidbodyB.GetTransformedVertices());
            contactCount = 1;


        } else if(shapeTypeB == ShapeType.CIRCLE) {

          pointsOfContact = FindCirclesCollisionPoint(rigidbodyA.getPosition(),
                                                      rigidbodyA.getRadius(),
                                                      rigidbodyB.getPosition(),
                                                      rigidbodyB.getRadius());
            contactCount = 1;
        }
      }

   for(PVector point : pointsOfContact) {
        pointsOfContactList.add(point);
   }

  collisionResult.setPointsOfContact(pointsOfContact);
  collisionResult.setContactCount(contactCount);
}
/*
====================================================================================================
============================== CIRCLE-CIRCLE COLLISION CONTACT POINT ===============================
======================================= COLLISION-RESULT ===========================================
====================================================================================================
*/
 private static PVector[] FindCirclesCollisionPoint(PVector centerA, float radiusA,
                                                         PVector centerB, float radiusB) {

    PVector direction = PVector.sub(centerB, centerA).normalize();
    PVector collisionPoint = PVector.add(centerA, PVector.mult(direction, radiusA));
    return new PVector[] {collisionPoint};
    }
/*
====================================================================================================
=============================POLYGON-POLYGON COLLISION CONTACT POINT ===============================
======================================= COLLISION-RESULT ===========================================
====================================================================================================
*/
private static PVector[] FindPolygonsCollisionPoints(PVector[] transformedVerticesA,
                                                           PVector[] transformedVerticesB) {
  
  //PVector[] pointsOfContact = new PVector[0];
  PVector contactPointA = new PVector();
  PVector contactPointB = new PVector();
  int contactCount = 0;

  float minDistanceSquared = Float.MAX_VALUE;

  for(int i = 0; i < transformedVerticesA.length; i++) {

      PVector point = transformedVerticesA[i];

      for(int j = 0; j < transformedVerticesB.length; j++) {
          
          PVector vertexA = transformedVerticesB[j];
          PVector vertexB = transformedVerticesB[(j + 1) % transformedVerticesB.length];
  
          CollisionResult pointSegmentDistanceResult = PointSegmentDistance(point, vertexA, vertexB);

        if(PhysEngMath.Equals(pointSegmentDistanceResult.getDistanceSquared(),minDistanceSquared)) {

            if(!PhysEngMath.Equals(pointSegmentDistanceResult.getPointsOfContact()[0], contactPointA)) {

              contactPointB = pointSegmentDistanceResult.getPointsOfContact()[0];
              contactCount = 2;

            }
        } else if(pointSegmentDistanceResult.getDistanceSquared() < minDistanceSquared) {

            minDistanceSquared = pointSegmentDistanceResult.getDistanceSquared();
            contactPointA = pointSegmentDistanceResult.getPointsOfContact()[0];
            contactCount = 1;
        }
      }
    }

  for(int i = 0; i < transformedVerticesB.length; i++) {

      PVector point = transformedVerticesB[i];

      for(int j = 0; j < transformedVerticesA.length; j++) {
          
          PVector vertexA = transformedVerticesA[j];
          PVector vertexB = transformedVerticesA[(j + 1) % transformedVerticesA.length];
  
          CollisionResult pointSegmentDistanceResult = PointSegmentDistance(point, vertexA, vertexB);

        if(PhysEngMath.Equals(pointSegmentDistanceResult.getDistanceSquared(),minDistanceSquared)) {

            if(!PhysEngMath.Equals(pointSegmentDistanceResult.getPointsOfContact()[0], contactPointA)) {

              contactPointB = pointSegmentDistanceResult.getPointsOfContact()[0];
              contactCount = 2;

            }
        } else if(pointSegmentDistanceResult.getDistanceSquared() < minDistanceSquared) {

            minDistanceSquared = pointSegmentDistanceResult.getDistanceSquared();
            contactPointA = pointSegmentDistanceResult.getPointsOfContact()[0];
            contactCount = 1;
        }
      }
    }

    if(contactCount == 1){
      return new PVector[] {contactPointA};
    }
  return new PVector[] {contactPointA, contactPointB};
  
}

/*
====================================================================================================
=============================CIRCLE-POLYGON COLLISION CONTACT POINT ===============================
======================================= COLLISION-RESULT ===========================================
====================================================================================================
*/

private static PVector[] FindCirclePolygonCollisionPoint(PVector circleCenter,
                                                         float circleRadius,
                                                         PVector polygonCenter,
                                                         PVector[] transformedVertices) {

    float minDistanceSquared = Float.MAX_VALUE;
    PVector contactPoint = new PVector();

    for(int i = 0; i < transformedVertices.length; i++) {

      PVector vertexA = transformedVertices[i];
      PVector vertexB = transformedVertices[(i + 1) % transformedVertices.length];

      CollisionResult pointSegmentDistanceResult = PointSegmentDistance(circleCenter, vertexA, vertexB);

      if(pointSegmentDistanceResult.getDistanceSquared() < minDistanceSquared) {
        minDistanceSquared = pointSegmentDistanceResult.getDistanceSquared();
        contactPoint = pointSegmentDistanceResult.getPointsOfContact()[0];
      }
    }

    return new PVector[] {contactPoint};
  }


/*
====================================================================================================
===================================== AABB-AABB COLLISIONS =========================================
====================================================================================================
*/
public static boolean IntersectAABB (AABB aabbA, AABB aabbB) {

  if(aabbA.getMax().x <= aabbB.getMin().x || aabbB.getMax().x <= aabbA.getMin().x
    || aabbA.getMax().y <= aabbB.getMin().y || aabbB.getMax().y <= aabbA.getMin().y) {

    return false;
  }

  return true;
}
/*
====================================================================================================
===================================== CIRCLE-CIRCLE COLLISIONS =====================================
======================================= COLLISION-RESULT ===========================================
====================================================================================================
*/
  public static CollisionResult IntersectCircle(PVector centerA, PVector centerB,
                                                float radiusA, float radiusB) {

    boolean isColliding;
    PVector normal = new PVector();
    float depth;


    float distance = PVector.sub(centerA, centerB).mag();
    float radiusSum = (radiusA + radiusB);
    if(distance < radiusSum) {
        isColliding = true;
        normal = PVector.sub(centerB, centerA).normalize();
        depth = radiusSum - distance;
    } else {
        isColliding = false;
        normal = new PVector();
        depth = 0;
    }
    
    return physicsEngine.new CollisionResult(isColliding, normal, depth);
  }
  
                                             

/*
====================================================================================================
===================================== POLYGON-POLYGON COLLISIONS ===================================
======================================= COLLISION-RESULT============================================
====================================================================================================
*/


public static CollisionResult IntersectPolygon(PVector centerA,
                                               PVector[] transformedVerticesA,
                                               PVector centerB,
                                               PVector[] transformedVerticesB) {

    boolean isColliding;
    float depth = Float.MAX_VALUE;
    PVector normal = new PVector();

    for(int vertexIndexA = 0; vertexIndexA < transformedVerticesA.length; vertexIndexA++) {
 

      //Gets the transformed vertices in polygon A, when at the end of the list, loops back to the start
      PVector transformedVertexA = transformedVerticesA[vertexIndexA];
      PVector transformedVertexB = transformedVerticesA[(vertexIndexA + 1) % transformedVerticesA.length];

      //Finds the edge between the two vertices,
      PVector edge = PVector.sub(transformedVertexB, transformedVertexA);

      //Finds the normal or "axis" from the edge vector
      PVector axis = new PVector(-edge.y, edge.x).normalize();

      //Projects the vertices of polygon A onto the axis. Format is [min, max]
      float[] minMaxA = ProjectVertices(transformedVerticesA, axis);
      float[] minMaxB = ProjectVertices(transformedVerticesB, axis);

      if(minMaxA[0] >= minMaxB[1] || minMaxB[0] >= minMaxA[1]) {
        isColliding = false;
        depth = 0;
        normal = new PVector();

        return physicsEngine.new CollisionResult(isColliding, normal, depth);
      }

      float axisDepth = min(minMaxB[1]-minMaxA[0], minMaxA[1]-minMaxB[0]);
      
      if(axisDepth < depth) {
        depth = axisDepth;
        normal = axis;
      }
    }

    for(int vertexIndexB = 0; vertexIndexB < transformedVerticesB.length; vertexIndexB++) {
      //!!!ALL OF THIS ASSUMES A CLOCKWISE WINDING ORDER!!!

      //Gets the transformed vertices in polygon A, when at the end of the list, loops back to the start
      PVector transformedVertexA = transformedVerticesB[vertexIndexB];
      PVector transformedVertexB = transformedVerticesB[(vertexIndexB + 1) % transformedVerticesB.length];

      //Finds the edge between the two vertices, 
      PVector edge = PVector.sub(transformedVertexB, transformedVertexA);

      //Finds the normal or "axis" from the edge vector
      PVector axis = new PVector(-edge.y, edge.x).normalize();

      //Projects the vertices of polygon A onto the axis. Format is [min, max]
      float[] minMaxA = ProjectVertices(transformedVerticesA, axis);
      float[] minMaxB = ProjectVertices(transformedVerticesB, axis);

      if(minMaxA[0] >= minMaxB[1] || minMaxB[0] >= minMaxA[1]) {
        isColliding = false;
        depth = 0;
        normal = new PVector();
        
        return physicsEngine.new CollisionResult(isColliding, normal, depth);
      }

      float axisDepth = min(minMaxB[1]-minMaxA[0], minMaxA[1]-minMaxB[0]);
      
      if(axisDepth < depth) {
        depth = axisDepth;
        normal = axis;
      }
    }

    //This is correction code so that the normal points in the correct direction
    //If its not pointing in the correct direction, flip the normal
    
    PVector correctNormalDirection = PVector.sub(centerB, centerA);
    if(PVector.dot(correctNormalDirection, normal) < 0) {
      normal.mult(-1);
    }
    
    isColliding = true;
    return physicsEngine.new CollisionResult(isColliding, normal, depth);
  }

//The overloaded method is used when the center of the polygon is not known


/*
====================================================================================================
===================================== CIRCLE-POLYGON COLLISIONS ====================================
======================================= COLLISION-RESULT ===========================================
====================================================================================================
*/


public static CollisionResult IntersectCirclePolygon(PVector circleCenter, float circleRadius,
                                                     PVector polygonCenter,
                                                     PVector[] transformedVertices){
    boolean isColliding;
    float depth = Float.MAX_VALUE;
    PVector normal = new PVector();

    PVector axis = new PVector();
    float axisDepth = 0f;


    for(int vertexIndex = 0; vertexIndex < transformedVertices.length; vertexIndex++) {
      //!!!ALL OF THIS ASSUMES A CLOCKWISE WINDING ORDER!!!

      //Gets the transformed vertices in polygon A, when at the end of the list, loops back to the start
      PVector transformedVertexA = transformedVertices[vertexIndex];
      PVector transformedVertexB = transformedVertices[(vertexIndex + 1) % transformedVertices.length];

      //Finds the edge between the two vertices, 
      PVector edge = PVector.sub(transformedVertexB, transformedVertexA);

      //Finds the normal or "axis" from the edge vector
       axis = new PVector(-edge.y, edge.x).normalize();

      //Projects the vertices of polygon A onto the axis. Format is [min, max]
      float[] minMaxA = ProjectVertices(transformedVertices, axis);
      //Projects the circle onto the axis. Format is [min, max]
      float[] minMaxB = ProjectCircle(circleCenter, axis, circleRadius);

      if(minMaxA[0] >= minMaxB[1] || minMaxB[0] >= minMaxA[1]) {
        isColliding = false;
        depth = 0;
        normal = new PVector();

        return physicsEngine.new CollisionResult(isColliding, normal, depth);
      }

       axisDepth = min(minMaxB[1]-minMaxA[0], minMaxA[1]-minMaxB[0]);
      
      if(axisDepth < depth) {
        depth = axisDepth;
        normal = axis;
      }
  }

  int closestPointIndex = FindClosestPointOnPolygon(circleCenter, transformedVertices);
  PVector closestPoint = transformedVertices[closestPointIndex];

   axis = PVector.sub(closestPoint, circleCenter).normalize(); 

     //Projects the vertices of polygon A onto the axis. Format is [min, max]
      float[] minMaxA = ProjectVertices(transformedVertices, axis);
      //Projects the circle onto the axis. Format is [min, max]
      float[] minMaxB = ProjectCircle(circleCenter, axis, circleRadius);

      if(minMaxA[0] >= minMaxB[1] || minMaxB[0] >= minMaxA[1]) {
        isColliding = false;
        depth = 0;
        normal = new PVector();

        return physicsEngine.new CollisionResult(isColliding, normal, depth);
      }

       axisDepth = min(minMaxB[1]-minMaxA[0], minMaxA[1]-minMaxB[0]);
      
      if(axisDepth < depth) {
        depth = axisDepth;
        normal = axis;
      }
    
    PVector directionVector = PVector.sub(polygonCenter, circleCenter);
    if(PVector.dot(directionVector, normal) < 0) {
      normal.mult(-1);
    }
  
  isColliding = true;
  return physicsEngine.new CollisionResult(isColliding, normal, depth);
}




/*
====================================================================================================
========================================= HELPER-METHODS ===========================================
====================================================================================================
*/

//Returns an array with array = [min, max]
private static float[] ProjectVertices(PVector[] vertices, PVector axis){
  float min = Float.MAX_VALUE;
  float max = Float.MIN_VALUE; 

  for(PVector vertex : vertices) {

    float projectedVertex = PVector.dot(vertex, axis);

    if(projectedVertex < min) {
      min = projectedVertex;
    }
    if(projectedVertex > max) {
      max = projectedVertex;
    }
  }
  return new float[] {min, max};
}

private static float[] ProjectCircle(PVector center, PVector axis, float radius) {

  PVector direction = axis.copy();
  PVector directionAndRadius = PVector.mult(direction, radius);
  PVector vertexA = PVector.add(center, directionAndRadius);
  PVector vertexB = PVector.sub(center, directionAndRadius);
  float min = PVector.dot(vertexA, axis);
  float max = PVector.dot(vertexB, axis);
   
  if(min > max){
    float temp = min;
    min = max;
    max = temp;
  }

  return new float[] {min, max};
}

private static int FindClosestPointOnPolygon(PVector circleCenter, PVector[] transformedVertices) {

  int result = -1;
  float minDistance = Float.MAX_VALUE;

  for(int vertexIndex = 0; vertexIndex < transformedVertices.length; vertexIndex++) {

    PVector transformedVertex = transformedVertices[vertexIndex];
    float distance = PVector.sub(circleCenter, transformedVertex).mag();

    if(distance < minDistance) {
      minDistance = distance;
      result = vertexIndex;
    }
  }
  return result;
}

public static CollisionResult PointSegmentDistance(PVector point, PVector lineSegmentStart, 
                                        PVector lineSegmentEnd) 
{

  PVector closestPoint = new PVector();
  
  PVector lineSegment = PVector.sub(lineSegmentEnd, lineSegmentStart);
  PVector pointToLineSegment = PVector.sub(point, lineSegmentStart);

  float projection = PVector.dot(pointToLineSegment, lineSegment);
  float lineSegmentLengthSquared = lineSegment.magSq();

  float distance = projection/lineSegmentLengthSquared;

  if(distance <= 0f) {

    closestPoint = lineSegmentStart;

  } else if(distance >= 1f) {

    closestPoint = lineSegmentEnd;

  } else {

    closestPoint = PVector.add(lineSegmentStart, PVector.mult(lineSegment, distance));

  }

  float distanceSquared = PVector.sub(point, closestPoint).magSq();

  return physicsEngine.new CollisionResult(distanceSquared, closestPoint);                       
  }
} 