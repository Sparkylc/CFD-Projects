public class CollisionResult {
 
  private boolean isColliding;
  private PVector normal;
  private float depth;

  private float distanceSquared;

  private PVector[] pointsOfContact;

  private int contactCount;



/*
====================================================================================================
================================ PointSegmentDistance Constructor ==================================
====================================================================================================
*/
  public CollisionResult(float distanceSquared, PVector pointOfContact) {

    this.distanceSquared = distanceSquared;

    this.pointsOfContact = new PVector[] {pointOfContact};
  }



  public CollisionResult(PVector[] pointsOfContact) {
    this.isColliding = true;

    this.pointsOfContact = pointsOfContact;
    this.contactCount = pointsOfContact.length;
  }

  public CollisionResult(boolean isColliding, PVector normal, float depth, PVector[] pointsOfContact) {
    this.isColliding = isColliding;
    this.normal = normal;
    this.depth = depth;

    this.pointsOfContact = pointsOfContact;
    this.contactCount = pointsOfContact.length;
  }

  
  public CollisionResult(boolean isColliding, PVector normal, float depth) {
    this.isColliding = isColliding;
    this.normal = normal;
    this.depth = depth;
    this.pointsOfContact = new PVector[0];
    this.contactCount = 0;
  }
 
  /*
  =====================================================================================================
  =========================================== Getters/Setters =========================================
  =====================================================================================================
  */

  public boolean getIsColliding() {
    return isColliding;
  }
  public PVector getNormal() {
    return normal;
  }
  public float getDepth() {
    return depth;
  }
  public PVector[] getPointsOfContact() {
    return pointsOfContact;
  }
  public int getContactCount() {
    return contactCount;
  }
  public float getDistanceSquared() {
    return distanceSquared;
  }


  public void setIsColliding(boolean isColliding) {
    this.isColliding = isColliding;
  }

  public void setNormal(PVector normal) {
    this.normal = normal;
  }

  public void setDepth(float depth) {
    this.depth = depth;
  }
  public void setDistanceSquared(float distanceSquared) {
    this.distanceSquared = distanceSquared;
  }

  //Overloaded Methods
  public void setPointsOfContact(PVector[] pointsOfContact) {
    this.pointsOfContact = pointsOfContact;
  }
  public void setPointsOfContact(PVector pointOfContact) {
    this.pointsOfContact = new PVector[] {pointOfContact};
  }
  public void setPointsOfContact(PVector pointOfContactA, PVector pointOfContactB) {
    this.pointsOfContact = new PVector[] {pointOfContactA, pointOfContactB};
  }

  public void setContactCount(int contactCount) {
    this.contactCount = contactCount;
  }

}