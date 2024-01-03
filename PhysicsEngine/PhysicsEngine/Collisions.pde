public static class Collisions {

  public static boolean IntersectCircleBoolean(PVector centerA, PVector centerB, 
                                             float radiusA, float radiusB, float strokeWeight) {
    float distanceSq = PVector.sub(centerA, centerB).magSq();
    float radiusSumSq = (radiusA + radiusB + strokeWeight) * (radiusA + radiusB + strokeWeight); 
    return distanceSq < radiusSumSq;
}

public static PVector IntersectCircleNormal(PVector centerA, PVector centerB,
                                            float radiusA, float radiusB, float strokeWeight) {
    if(IntersectCircleBoolean(centerA, centerB, radiusA, radiusB, strokeWeight)) {
        return PVector.sub(centerB, centerA).normalize();
    } else {
        return new PVector(0, 0);
    } 
}

public static float IntersectCircleDepth(PVector centerA, PVector centerB, 
                                         float radiusA, float radiusB, float strokeWeight) {
    if(IntersectCircleBoolean(centerA, centerB, radiusA, radiusB, strokeWeight)) {
        float distance = PVector.sub(centerA, centerB).mag();
        float radiusSum = (radiusA + radiusB + strokeWeight);
        return radiusSum - distance;
    } else {
        return 0;
    }
}

  public static void collisionResponse(){
    for(int i = 0; i < rigidbodyArrayList.size() - 1; i++) {

      Rigidbody rigidbodyA = rigidbodyArrayList.get(i);

      for(int j = i + 1; j < rigidbodyArrayList.size(); j++) {

        Rigidbody rigidbodyB = rigidbodyArrayList.get(j);
        
        PVector normal = IntersectCircleNormal(rigidbodyA.getPosition(), rigidbodyB.getPosition(), 
                                               rigidbodyA.getRadius(), rigidbodyB.getRadius(), 
                                               rigidbodyA.getStrokeWeight());
        float depth = IntersectCircleDepth(rigidbodyA.getPosition(), rigidbodyB.getPosition(), 
                                           rigidbodyA.getRadius(), rigidbodyB.getRadius(),
                                           rigidbodyA.getStrokeWeight());
        rigidbodyA.Move(PVector.mult(normal, -1 * depth / 2f));
        rigidbodyB.Move(PVector.mult(normal, depth / 2f));
       
      }
    }
  }
}