public class BoundingShape {
    PVector origin;
    float width, height, depth;
    PVector rotation;
    final int TypeID;
    PVector[][] faces;

    public BoundingShape(PVector origin, float width, float height, float depth, int typeID) {
        this.origin = origin;
        this.width = width;
        this.height = height;
        this.depth = depth;
        this.TypeID = typeID;
        }


    public PVector[][] getFaces() {
        if(TypeID == 1){
        
        faces = new PVector[6][4];
        this.origin = origin.copy();
        // Front Face
        faces[0][0] = origin;
        faces[0][1] = new PVector(origin.x + width, origin.y, origin.z);
        faces[0][2] = new PVector(origin.x + width, origin.y + height, origin.z);
        faces[0][3] = new PVector(origin.x, origin.y + height, origin.z);

        // Back Face
        faces[1][0] = new PVector(origin.x, origin.y, origin.z + depth);
        faces[1][1] = new PVector(origin.x + width, origin.y, origin.z + depth);
        faces[1][2] = new PVector(origin.x + width, origin.y + height, origin.z + depth);
        faces[1][3] = new PVector(origin.x, origin.y + height, origin.z + depth);

        // Left Face
        faces[2][0] = origin;
        faces[2][1] = new PVector(origin.x, origin.y, origin.z + depth);
        faces[2][2] = new PVector(origin.x, origin.y + height, origin.z + depth);
        faces[2][3] = new PVector(origin.x, origin.y + height, origin.z);

        // Right Face
        faces[3][0] = new PVector(origin.x + width, origin.y, origin.z);
        faces[3][1] = new PVector(origin.x + width, origin.y, origin.z + depth);
        faces[3][2] = new PVector(origin.x + width, origin.y + height, origin.z + depth);
        faces[3][3] = new PVector(origin.x + width, origin.y + height, origin.z);

        // Top Face
        faces[4][0] = new PVector(origin.x, origin.y + height, origin.z);
        faces[4][1] = new PVector(origin.x + width, origin.y + height, origin.z);
        faces[4][2] = new PVector(origin.x + width, origin.y + height, origin.z + depth);
        faces[4][3] = new PVector(origin.x, origin.y + height, origin.z + depth);

        // Bottom Face
        faces[5][0] = new PVector(origin.x, origin.y, origin.z);
        faces[5][1] = new PVector(origin.x + width, origin.y, origin.z);
        faces[5][2] = new PVector(origin.x + width, origin.y, origin.z + depth);
        faces[5][3] = new PVector(origin.x, origin.y, origin.z + depth);
        }
        return faces;
}
}
