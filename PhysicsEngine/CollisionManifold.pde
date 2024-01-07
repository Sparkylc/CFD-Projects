public class CollisionManifold {
    private final Rigidbody rigidbodyA;
    private final Rigidbody rigidbodyB;
    private final PVector normal;
    private final float depth;

    private final PVector[] pointsOfContact;
    private final int contactCount;

    public CollisionManifold(Rigidbody rigidbodyA, Rigidbody rigidbodyB,
                             CollisionResult collisionResult) {

        this.rigidbodyA = rigidbodyA;
        this.rigidbodyB = rigidbodyB;
        this.normal = collisionResult.getNormal();
        this.depth = collisionResult.getDepth();
        this.pointsOfContact = collisionResult.getPointsOfContact();
        this.contactCount = pointsOfContact.length;
    }
    

    public Rigidbody getRigidbodyA() {
        return rigidbodyA;
    }

    public Rigidbody getRigidbodyB() {
        return rigidbodyB;
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


}