public static class Collisions {
  CollisionResult collisionResult;
/*
====================================================================================================
===================================== CIRCLE-CIRCLE COLLISIONS =====================================
======================================= BOOLEAN-NORMAL-DEPTH =======================================
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
    PhysicsEngine physicsEngine = new PhysicsEngine();
    return physicsEngine.new CollisionResult(isColliding, normal, depth);
  }


/*
====================================================================================================
===================================== POLYGON-POLYGON COLLISIONS ===================================
======================================= BOOLEAN-NORMAL-DEPTH =======================================
====================================================================================================
*/

public static CollisionResult IntersectPolygon(PVector[] transformedVerticesA,
                                     PVector[] transformedVerticesB) {
    //This is required as there is no enclosing instance of physics class for collisionResult
    PhysicsEngine physicsEngine = new PhysicsEngine();
    boolean isColliding;              
    float depth = Float.MAX_VALUE;
    PVector normal = new PVector();

    for(int vertexIndexA = 0; vertexIndexA < transformedVerticesA.length; vertexIndexA++) {
      //!!!ALL OF THIS ASSUMES A CLOCKWISE WINDING ORDER!!!

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

    isColliding = true;
    depth /= normal.mag();
    normal.normalize();


    //This is correction code so that the normal points in the correct direction
    //If its not pointing in the correct direction, flip the normal
    
    PVector centerA = FindCenter(transformedVerticesA);
    PVector centerB = FindCenter(transformedVerticesB);

    PVector correctNormalDirection = PVector.sub(centerB, centerA);
    if(PVector.dot(correctNormalDirection, normal) < 0) {
      normal.mult(-1);
    }
    

    return physicsEngine.new CollisionResult(isColliding, normal, depth);
  }
/*
====================================================================================================
===================================== CIRCLE-POLYGON COLLISIONS ====================================
======================================= BOOLEAN-NORMAL-DEPTH =======================================
*/
public static CollisionResult IntersectCirclePolygon(PVector circleCenter, float circleRadius, 
                                                     PVector[] transformedVertices){
//This is required as there is no enclosing instance of physics class for collisionResult
    PhysicsEngine physicsEngine = new PhysicsEngine();
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

    depth /= normal.mag();
    normal.normalize();

    PVector polygonCenter = FindCenter(transformedVertices);
    
    PVector directionVector = PVector.sub(polygonCenter, circleCenter);
    if(PVector.dot(directionVector, normal) < 0) {
      normal.mult(-1);
    }
  return physicsEngine.new CollisionResult(true, normal, depth);
}
/*
====================================================================================================
========================================= COLLISION-RESPONSE =======================================
====================================================================================================
*/
  public static void collisionResponse(){
    
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
    //Projects the vertex onto the axis
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
    //Swaps for min and max
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

private static PVector FindCenter(PVector[] vertices) {
  PVector center = new PVector();
  for(PVector vertex : vertices) {
    center.add(vertex);
  }
  center.div(vertices.length);
  return center;
}
}