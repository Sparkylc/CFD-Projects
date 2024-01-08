public class CollisionManifold {

    private final Rigidbody RigidbodyA;
    private final Rigidbody RigidbodyB;
    private final PVector Normal;
    private final float Depth;

    private final PVector[] PointsOfContact;
    private final int ContactCount;

    public CollisionManifold(Rigidbody rigidbodyA, Rigidbody rigidbodyB,
                             CollisionResult collisionResult) {

        this.RigidbodyA = rigidbodyA;
        this.RigidbodyB = rigidbodyB;
        this.Normal = collisionResult.getNormal();
        this.Depth = collisionResult.getDepth();
        this.PointsOfContact = collisionResult.getPointsOfContact();
        this.ContactCount = collisionResult.getContactCount();
    }
    

    public Rigidbody getRigidbodyA() {
        return RigidbodyA;
    }

    public Rigidbody getRigidbodyB() {
        return RigidbodyB;
    }

    public PVector getNormal() {
        return Normal;
    }

    public float getDepth() {
        return Depth;
    }

    public PVector[] getPointsOfContact() {
        return PointsOfContact;
    }

    public int getContactCount() {
        return ContactCount;
    }


}