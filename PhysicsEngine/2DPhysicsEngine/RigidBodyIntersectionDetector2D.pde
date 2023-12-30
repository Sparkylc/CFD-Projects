public class IntersectionDetector2D {
  

  public static boolean pointOnLIne(PVector point, Line2D line){
    float dy = line.getEnd().y - line.getStart().y;
    float dx = line.getEnd().x - line.getStart().x;
    if(dx == 0f){
      return PMath.compare(point, line.getStart().x);
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
    PVector min = box.getMin();
    PVector max = box.getMax();

    return localPoint.x <= max.x && localPoint.x >= min.x && localPoint.y <= max.y && localPoint.y >= min.y;

  }

  public static boolean lineAndCircle(Line2D line, Circle circle) {
    if(pointInCircle(line.getStart(), circle) || pointInCircle(line.getEnd(), circle)) {
      return true;
    }

    PVector ab = PVector.sub(line.getEnd(), line.getStart());

    //Project point (circle position) ont ab (line segment)
    PVector circleCenter = circle.getCenter();
    float t = PVector.dot(PVector.sub(circleCenter, line.getStart()), ab) / ab.dot(ab);

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

    PVector min = box.getMin();
    min.sub(line.getStart()).mult(unitVector);
    PVector max = box.getMax();
    max.sub(line.getStart()).mult(unitVector);

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
    AABB aabb = new AABB(box.getMin(), box.getMax());

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

    Vector size = box.getHalfSize();

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
    return true

  }
}
