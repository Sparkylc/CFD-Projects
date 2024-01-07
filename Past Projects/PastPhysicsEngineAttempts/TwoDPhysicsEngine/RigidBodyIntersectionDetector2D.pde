public static class IntersectionDetector2D {
  

  public static boolean pointOnLIne(PVector point, Line2D line){
    float dy = line.getEnd().y - line.getStart().y;
    float dx = line.getEnd().x - line.getStart().x;
    if(dx == 0f){
      return PMath.compare(point.x, line.getStart().x);
    }
    float slope = dy / dx;

    float yIntercept= line.getEnd().y - (slope * line.getEnd().x);

    //checks line equation
    return point.y == (slope * point.x) + yIntercept;
  }

  public static boolean pointInCircle(PVector point, Circle circle) {
    PVector circleCenter = circle.getCenter();
    PVector centerToPoint = PVector.sub(point, circleCenter);

    return centerToPoint.magSq() <= circle.getRadius() * circle.getRadius();
  }

  public static boolean pointInAABB(PVector point, AABB box) {
    PVector min = box.getMin();
    PVector max = box.getMax();

    return point.x <= max.x && point.x >= min.x && point.y <= max.y && point.y >= min.y;
  }

  public static boolean pointInOBB(PVector point, OBB box) {
    // Translate point into local space of OBB

    PVector localPoint = point.copy();
    PMath.rotate(localPoint, box.getRigidBody().getRotation(), box.getRigidBody().getPosition());
    PVector min = box.getLocalMin();
    PVector max = box.getLocalMax();

    return localPoint.x <= max.x && localPoint.x >= min.x && localPoint.y <= max.y && localPoint.y >= min.y;

  }

  public static boolean lineAndCircle(Line2D line, Circle circle) {
    if(pointInCircle(line.getStart(), circle) || pointInCircle(line.getEnd(), circle)) {
      return true;
    }

    PVector ab = PVector.sub(line.getEnd(), line.getStart());

    //Project point (circle position) ont ab (line segment)
    PVector circleCenter = circle.getCenter();
    float t = PVector.dot(PVector.sub(circleCenter, line.getStart()), ab) / PVector.dot(ab, ab);

    if (t < 0.0f || t > 1.0f) {
      return false;
    }

    //Find the closest point on the line segment to the circle
    PVector closestPoint = PVector.add(line.getStart(), PVector.mult(ab, t));

    return pointInCircle(closestPoint, circle);
  }

  public static boolean lineAndAABB(Line2D line, AABB box) {
    if(pointInAABB(line.getStart(), box) || pointInAABB(line.getEnd(), box)) {
      return true;
    }

    PVector unitVector = PVector.sub(line.getEnd(), line.getStart());
    unitVector.normalize();
    unitVector.x = (unitVector.x != 0) ? 1.0f / unitVector.x : 0;
    unitVector.y = (unitVector.y != 0) ? 1.0f / unitVector.y : 0;

    PVector min = box.getMin().copy();
    min = min.sub(line.getStart()).mult(unitVector);
    PVector max = box.getMax().copy();
    max = max.sub(line.getStart()).mult(unitVector);

    float tmin = Math.max(Math.min(min.x, max.x), Math.min(min.y, max.y));
    float tmax = Math.min(Math.max(min.x, max.x), Math.max(min.y, max.y));
    
    if(tmax < 0 || tmin > tmax) {
      return false;
    }

    float t = (tmin < 0.0f) ? tmax : tmin;
    return t > 0.0f && t * t < line.magSquared();
    
  }

  public static boolean lineAndOBB(Line2D line, OBB box) {
    float theta = -1 * box.getRigidBody().getRotation();
    PVector center = box.getRigidBody().getPosition();
    PVector localStart = line.getStart().copy();
    PVector localEnd = line.getEnd().copy();
    PMath.rotate(localStart, theta, center);
    PMath.rotate(localEnd, theta, center);

    Line2D localLine = new Line2D(localStart, localEnd);
    AABB aabb = new AABB(box.getLocalMin().copy(), box.getLocalMax().copy());

    return lineAndAABB(localLine, aabb);
  }

  public static boolean raycast(Circle circle, Ray2D ray, RaycastResult result) {
    RaycastResult.reset(result);


    PVector originToCircle = PVector.sub(circle.getCenter(), ray.getOrigin());
    float radiusSquared = circle.getRadius() * circle.getRadius();
    float originToCircleSquared = originToCircle.magSq();

    //project vector from ray origin to the direction of the ray
    float a = PVector.dot(originToCircle, ray.getDirection());
    float bSq = originToCircleSquared - (a * a);

    if (radiusSquared - bSq < 0.0f) {
      return false;
    }

    float f = (float) Math.sqrt(radiusSquared - bSq);
    float t = 0.0f;
    if (originToCircleSquared < radiusSquared) {
      t = a + f;
    } else {
      t = a - f;
    }
    if(result != null) {
      PVector point = PVector.add(ray.getOrigin(), PVector.mult(ray.getDirection(), t));
      PVector normal = PVector.sub(point, circle.getCenter());
      normal.normalize();

      result.init(point, normal, t, true);
    }

  return true; 
  }

  public static boolean raycast(AABB box, Ray2D ray, RaycastResult result) {
    RaycastResult.reset(result);
    PVector unitVector = ray.getDirection().copy();
    unitVector.normalize();
    unitVector.x = (unitVector.x != 0) ? 1.0f / unitVector.x : 0;
    unitVector.y = (unitVector.y != 0) ? 1.0f / unitVector.y : 0;

    PVector min = box.getMin();
    min.sub(ray.getOrigin().copy()).mult(unitVector);
    PVector max = box.getMax();
    max.sub(ray.getOrigin().copy()).mult(unitVector);

    float tmin = Math.max(Math.min(min.x, max.x), Math.min(min.y, max.y));
    float tmax = Math.min(Math.max(min.x, max.x), Math.max(min.y, max.y));
    
    if(tmax < 0 || tmin > tmax) {
      return false;
    }

    float t = (tmin < 0.0f) ? tmax : tmin;
    boolean hit = t > 0f;
    if(!hit) {
      return false;
    }
    if(result != null) {
      PVector point = PVector.add(ray.getOrigin(), PVector.mult(ray.getDirection(), t));
      PVector normal = PVector.sub(ray.getOrigin(), point);
      normal.normalize();

      result.init(point, normal, t, true);    
    }
    return true;
  }

  public static boolean raycast(OBB box, Ray2D ray, RaycastResult result) {
    RaycastResult.reset(result);

    PVector size = box.getHalfSize().copy();

    PVector xAxis = new PVector(1,0);
    PVector yAxis = new PVector(0,1);

    PMath.rotate(xAxis, -1 * box.getRigidBody().getRotation(), new PVector(0,0));
    PMath.rotate(yAxis, -1 * box.getRigidBody().getRotation(), new PVector(0,0));

    PVector p = PVector.sub(box.getRigidBody().getPosition(), ray.getOrigin());
    //project the direction of the ray onto each axis of the box
    PVector f = new PVector(
      PVector.dot(xAxis, ray.getDirection()), 
      PVector.dot(yAxis, ray.getDirection())
      );
    //next project p onto every axis of the box
    PVector e = new PVector(
      PVector.dot(xAxis, p),
      PVector.dot(yAxis, p)
      );
    
    float[] tArr = {0, 0, 0, 0};

    for(int i = 0; i < 2; i++) {
      if(i == 0) {
        float m = f.x;
        float l = e.x;
        float s = box.getSize().x;
      }
      if(i == 1) {
        float m = f.y;
        float l = e.y;
        float s = box.getSize().y;
      }
       if(PMath.compare(m, 0)){
        //If the ray is parallel to the current axis, and the origin of the ray
        //is not inside, there is no hit
        if(-1 * l - s > 0 || -1 * l + s < 0){
          return false;
        }

      //set to a small value to prevent divide by zero
       if(i == 0){
        f.set(0.00001f, f.y);
       } 
       if(i == 1) {
        f.set(f.x, 0.00001f);
       }
       }


       tArr[i*2 + 0] = (l + s) / m; //tmax for this axis
       tArr[i*2 + 1] = (l - s) / m; //tmin for this axis    
    }

    float tmin = Math.max(Math.min(tArr[0], tArr[1]), Math.min(tArr[2], tArr[3]));
    float tmax = Math.min(Math.max(tArr[0], tArr[1]), Math.max(tArr[2], tArr[3]));

    float t = (tmin < 0.0f) ? tmax : tmin;
    boolean hit = t > 0f;
    if(!hit) {
      return false;
    }
    if(result != null) {
      PVector point = PVector.add(ray.getOrigin(), PVector.mult(ray.getDirection(), t));
      PVector normal = PVector.sub(ray.getOrigin(), point);
      normal.normalize();

      result.init(point, normal, t, true);    
    }
    return true;
  }
  //overloaded method
  public static boolean circleAndLine(Circle circle, Line2D line) {
    return lineAndCircle(line, circle);
  }

  public static boolean circleAndCirlcle(Circle circle1, Circle circle2) {
    PVector vectorBetweenCenters = PVector(circle1.getCenter(), circle2.getCenter());
    float radiusSum = circle1.getRadius() + circle2.getRadius();
    return vectorBetweenCenters.magSq() <= radiusSum * radiusSum;
  }

  public static boolean circleAndAABB (Circle circle, AABB box) {
    PVector min = box.getMin();
    PVector max = box.getMax();

    PVector closestPointToCircle = circle.getCenter().copy();
    if(closestPointToCircle.x < min.x) {
      closestPointToCircle.x = min.x;
    } else if(closestPointToCircle.x > max.x) {
      closestPointToCircle.x = max.x;
    }
    //clamps to closest piece of the box to the center
    if(closestPointToCircle.y < min.y) {
      closestPointToCircle.y = min.y;
    } else if(closestPointToCircle.y > max.y) {
      closestPointToCircle.y = max.y;
    }

    PVector circleToBox = PVector.sub(circle.getCenter(), closestPointToCircle);
    return circleToBox.magSq() <= circle.getRadius() * circle.getRadius();
  }

  public static circleAndOBB (Circle circle, OBB box) {
    //Treat the box just like an AABB after we rotate the stuff
    PVector min = new PVector();
    PVector max = PVector.mult(box.getHalfSize(), 2.0f);

    //Create a circle in boxes local space
    PVector r = new PVector(PVector.sub(circle.getCenter(), box.getRigidBody().getPosition()));
    PMath.rotate(r, -1 * box.getRigidBody().getRotation(), new PVector(0,0));
    PVector localCirclePosition = PVector.add(r, box.getHalfSize());

    PVector closestPointToCircle = localCirclePosition.copy();
    if(closestPointToCircle.x < min.x) {
      closestPointToCircle.x = min.x;
    } else if(closestPointToCircle.x > max.x) {
      closestPointToCircle.x = max.x;
    }
    //clamps to closest piece of the box to the center
    if(closestPointToCircle.y < min.y) {
      closestPointToCircle.y = min.y;
    } else if(closestPointToCircle.y > max.y) {
      closestPointToCircle.y = max.y;
    }

    PVector circleToBox = PVector.sub(localCirclePosition, closestPointToCircle);
    return circleToBox.magSq() <= circle.getRadius() * circle.getRadius();
    
  }
  //overloaded method
  public static boolean AABBAndCircle(AABB box, Circle circle) {
    return circleAndAABB(circle, box);
  }

  public static boolean AABBAndAABB(AABB box1, AABB box2){
    //axis aligned means (1,0) and (0,1)
     PVector[] axisToTest = {
      new PVector(0,1),
      new PVector(1, 0) 
     };

     for(int i = 0; i < axisToTest.length; i++) {
      if(!overlapOnAxis(box1, box2, axisToTest[i])) {
        return false;
      }
     }
      return true;
  }

  public static boolean AABBAndOBB(AABB box1, OBB box2){
    PVector[] axesToTest = {
      new PVector(0, 1),
      new PVector(1, 0),
      new PVector(0, 1),
      new PVector(1, 0)
      };
      PMath.rotate(axesToTest[2], box2.getRigidBody().getRotation(), new PVector(0,0));
      PMath.rotate(axesToTest[3], box2.getRigidBody().getRotation(), new PVector(0,0));
      
      for(int i = 0; i < axisToTest.length; i++) {
      if(!overlapOnAxis(box1, box2, axisToTest[i])) {
        return false;
      }
     }
      return true;
  }



  //================================================================================================
  //========================================SAT HELPER METHODS======================================
  //================================================================================================

  private static boolean overlapOnAxis(AABB box1, AABB box2, PVector axis) {
    //it is expected for the user to make sure that axis is normalized before passing in 
    PVector interval1 = getInterval(box1, axis);
    PVector interval2 = getInterval(box2, axis);
    return (interval2.x <= interval1.y) && (interval1.x <= interval2.y);
  } 
  private static boolean overlapOnAxis(AABB box1, OBB box2, PVector axis) {
    //it is expected for the user to make sure that axis is normalized before passing in 
    PVector interval1 = getInterval(box1, axis);
    PVector interval2 = getInterval(box2, axis);
    return (interval2.x <= interval1.y) && (interval1.x <= interval2.y);
  } 
  private static boolean overlapOnAxis(OBB box1, OBB box2, PVector axis) {
    //it is expected for the user to make sure that axis is normalized before passing in 
    PVector interval1 = getInterval(box1, axis);
    PVector interval2 = getInterval(box2, axis);
    return (interval2.x <= interval1.y) && (interval1.x <= interval2.y);
  } 

  private static PVector getInterval(AABB rectangle, PVector axis) {
    PVector result = new PVector(0, 0);

    PVector min = rectangle.getMin().copy();
    PVector max = rectangle.getMax().copy();

    PVector[] vertices = {
      new PVector(min.x, min.y),
      new PVector(max.x, min.y),
      new PVector(max.x, max.y),
      new PVector(min.x, max.y)
    };


    result.x = PVector.dot(axis, vertices[0]);
    result.y = result.x;

    for(int i = 1; i < vertices.length; i++) {
      float projection = PVector.dot(axis, vertices[i]);
      if(projection < result.x) {
        result.x = projection;
      }
      if(projection > result.y) {
        result.y = projection;
      }
    }
    return result;
  }

  private static PVector getInterval(OBB rectangle, PVector axis) {
    PVector result = new PVector(0, 0);
    PVector[] vertices = rectangle.getVertices();


    result.x = PVector.dot(axis, vertices[0]);
    result.y = result.x;

    for(int i = 1; i < vertices.length; i++) {
      float projection = PVector.dot(axis, vertices[i]);
      if(projection < result.x) {
        result.x = projection;
      }
      if(projection > result.y) {
        result.y = projection;
      }
    }
    return result;
  }
}
