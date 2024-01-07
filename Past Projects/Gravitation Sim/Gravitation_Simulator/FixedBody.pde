class FixedBody extends Body {

      
    FixedBody(PVector position, float mass, float radius) {
        super(position, mass, radius);
    }

    @Override
    void updateBody(){
        //does nothing
    }

    //just creates a list with the bodies the current body is in contact with, then updates those bodies;
    @Override
    boolean hasCollided(Body body) {
        PVector distanceVector = PVector.sub(body.position, this.position);
        if (distanceVector.mag() < (body.radius + this.radius) / 2) {
            float distanceCorrection = ((body.radius + this.radius) / 2 - distanceVector.mag()) / 2;
            PVector d = distanceVector.copy();
            PVector correctionVector = d.normalize().mult(distanceCorrection);
            if (!(body instanceof FixedBody)) {
                body.position.add(correctionVector);
            }
            return true;
        }
        return false;
    }
    @Override
    void collisionDetection(ArrayList<Body> bodies) {
        ArrayList<Body> collidedBodies = new ArrayList();
        
        //just checks if the current body has collided with the other body, and if that other body is not the current body
        for (int currentBody = 0; currentBody < bodies.size(); currentBody++) {
            if (bodies.get(currentBody) != this && hasCollided(bodies.get(currentBody))) {
                collidedBodies.add(bodies.get(currentBody));
                
            }
        }
        //performs the collision response with every object in the list
        for (int currentBody = 0; currentBody < collidedBodies.size(); currentBody++) {
            this.collisionResponse(collidedBodies.get(currentBody));
       } 
} 
    //creates the collision response based off of a perfectly elastic collision
    @Override
    void collisionResponse(Body body) {
                PVector unitNormalVector = PVector.sub(body.position, position).normalize();
                PVector unitTangentVector = new PVector( - 1 * unitNormalVector.y, unitNormalVector.x);
                float secondaryBodyScalarNormalVelocity = PVector.dot(unitNormalVector, body.velocity) *-  1;
                float secondaryBodyScalarTangentialVelocity = PVector.dot(unitTangentVector, body.velocity);
                PVector newSecondaryBodyNormalVelocity = PVector.mult(unitNormalVector, secondaryBodyScalarNormalVelocity);
                PVector newSecondaryBodyTangentialVelocity = PVector.mult(unitTangentVector, secondaryBodyScalarTangentialVelocity);
                body.velocity = PVector.add(newSecondaryBodyNormalVelocity, newSecondaryBodyTangentialVelocity);
    }
    
}
