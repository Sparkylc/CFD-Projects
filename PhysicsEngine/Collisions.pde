public static class Collisions{

    public static float distance;
    public static float radiusSum;
    public static PVector normal;
    public static float depth;


    public static boolean SphereIntersection(PVector rigidBodyCenterA, float rigidBodyRadiusA, PVector rigidBodyCenterB, float rigidBodyRadiusB){
        distance = rigidBodyCenterA.dist(rigidBodyCenterB);
        radiusSum = rigidBodyRadiusA + rigidBodyRadiusB;

        if(distance >= radiusSum){
            return false;
        }

        normal = rigidBodyCenterB.sub(rigidBodyCenterA).normalize();
        depth = radiusSum - distance;
        return true;
    }

    
    public boolean SpherePolygonIntersection(PVector rigidBodyCenterA, float rigidBodyRadiusA, BoundingShape boundingShape){
        return false;
    }

public static boolean polygonIntersection(BoundingShape shapeA, BoundingShape shapeB) {
    depth = Float.MAX_VALUE;
    normal = new PVector(0, 0, 0);

    PVector[][] facesA = shapeA.getFaces();
    PVector[][] facesB = shapeB.getFaces();

    Set<PVector> axes = getPotentialAxes(facesA, facesB);

    for (PVector axis : axes) {
        float[] projectionA = projectVertices(getVertices(facesA), axis);
        float[] projectionB = projectVertices(getVertices(facesB), axis);

        if (!overlaps(projectionA, projectionB)) {
            return false; // Separating axis found, no intersection
        }

        float axisDepth = Math.min(projectionB[1] - projectionA[0], projectionA[1] - projectionB[0]);
        if (axisDepth < depth) {
            depth = axisDepth;
            normal = axis.copy(); // Copy axis to avoid mutating shared axes
        }
    }

    depth /= normal.mag();
    normal = normal.normalize();


    PVector centerA = findArithmeticMean(getVertices(facesA));
    PVector centerB = findArithmeticMean(getVertices(facesB));

    PVector direction = PVector.sub(centerB, centerA);

    if(normal.dot(direction) < 0){
        normal.mult(-1);
    }
    

    return true; // No separating axis found, intersection occurs
}


public static PVector findArithmeticMean(PVector[] vertices){
        
        PVector arithmeticMean = new PVector(0,0,0);

       for(int i = 0; i < vertices.length; i++){
              arithmeticMean = PVector.add(arithmeticMean, vertices[i]);
       }
       return arithmeticMean;
    }

    //Helper methods
    public static Set<PVector> getPotentialAxes(PVector[][] facesA, PVector[][] facesB) {
       Set<PVector> axes = new HashSet<>();
    
        axes.addAll(getNormals(facesA));
        axes.addAll(getNormals(facesB));
    
        PVector[] edgesA = getEdges(getVertices(facesA));
        PVector[] edgesB = getEdges(getVertices(facesB));
    
        for (PVector edgeA : edgesA) {
            for (PVector edgeB : edgesB) {
                PVector crossProduct = edgeA.cross(edgeB).copy();
                if (!isZeroVector(crossProduct)) {
                    axes.add(crossProduct.normalize());
                }
            }
        }
    
        return axes;
    }

    public static ArrayList<PVector> getNormals(PVector[][] faces) {
        ArrayList<PVector> normals = new ArrayList<>();
        for (PVector[] face : faces) {
            PVector edge1 = PVector.sub(face[0], face[1]);
            PVector edge2 = PVector.sub(face[2], face[1]);
            PVector crossProduct = edge1.cross(edge2).copy();
            PVector unitCrossProduct = crossProduct.normalize().copy();
            normals.add(unitCrossProduct.copy());
        }
        return normals;
    }

    public static PVector[] getEdges(PVector[] vertices) {
        ArrayList<PVector> edges = new ArrayList<>();

        for (int i = 0; i < vertices.length; i++) {
            for (int j = i + 1; j < vertices.length; j++) {
                PVector edge = PVector.sub(vertices[i], vertices[j]);
                edges.add(edge.copy());
            }
        }

        return edges.toArray(new PVector[0]);
    }



public static float[] projectVertices(PVector[] vertices, PVector axis) {
    float min = Float.MAX_VALUE;
    float max = -Float.MAX_VALUE;

    for (PVector vertex : vertices) {
        float projection = PVector.dot(vertex, axis);
        if (projection < min) min = projection;
        if (projection > max) max = projection;
    }

    return new float[]{min, max};
}




public static PVector[] getVertices(PVector[][] faces) {
    Set<PVector> vertices = new HashSet<>();

    for (PVector[] face : faces) {
        for (PVector vertex : face) {
            vertices.add(vertex.copy());
        }
    }

    return vertices.toArray(new PVector[0]);
}
public static boolean isZeroVector(PVector vector) {
    final double threshold = 1E-6;
    return (Math.abs(vector.x) < threshold && Math.abs(vector.y) < threshold && Math.abs(vector.z) < threshold);
}



public static boolean overlaps(float[] projection1, float[] projection2) {
    return !(projection1[1] < projection2[0] || projection2[1] < projection1[0]);
}



}