

public class AddForce {

    public void AddAirReistanceForceToRigidBody(Rigidbody rigidbody) {
        AirResistance ADD_FORCE_AIR_RESISTANCE = new AirResistance();
        rigidbody.addForce(ADD_FORCE_AIR_RESISTANCE);
    }

    public void AddFollowMouseForceToRigidBody(Rigidbody rigidbody) {
        FollowMouse ADD_FORCE_FOLLOW_MOUSE = new FollowMouse();
        rigidbody.addForce(ADD_FORCE_FOLLOW_MOUSE);
    }
    public void AddFrictionForceToRigidBody(Rigidbody rigidbody, float coefficientOfFriction) {
        Friction ADD_FORCE_FOLLOW_MOUSE = new Friction();
        ADD_FORCE_FOLLOW_MOUSE.setCoefficientOfFriction(coefficientOfFriction);
        rigidbody.addForce(ADD_FORCE_FOLLOW_MOUSE);
    }
    public void AddGravityForceToRigidBody(Rigidbody rigidbody, PVector grav) {
        Gravity ADD_FORCE_GRAVITY = new Gravity();
        ADD_FORCE_GRAVITY.setGravity(grav);
        rigidbody.addForce(ADD_FORCE_GRAVITY);
    }

    //TODO: IMPLEMENT CUSTOM SPRING EQUILIBRIUM POSITIONS
    public void AddSpringForceToRigidBody(Rigidbody rigidbody, PVector springAnchor, float springConstant, float springLength) {
        RigidbodySpring ADD_FORCE_SPRING = new RigidbodySpring();
        ADD_FORCE_SPRING.setSpringAnchor(springAnchor);
        ADD_FORCE_SPRING.setSpringConstant(springConstant);
        ADD_FORCE_SPRING.setSpringLength(springLength);
        rigidbody.addForce(ADD_FORCE_SPRING);
    }

    public void AddSpringForceToSpringForce(Rigidbody rigidbody, Rigidbody secondarySpring, float springConstant, float springLength) {
        RigidbodySpring ADD_FORCE_SPRING = new RigidbodySpring();
        RigidbodySpring ADD_FORCE_SPRING_SECONDARY = new RigidbodySpring();

        ADD_FORCE_SPRING.setConnectedToSpring(true);
        ADD_FORCE_SPRING.setAnchorRigidBody(secondarySpring);
        ADD_FORCE_SPRING.setSpringConstant(springConstant);
        ADD_FORCE_SPRING.setSpringLength(springLength);
        ADD_FORCE_SPRING.setSpringVisible(true);

        ADD_FORCE_SPRING_SECONDARY.setConnectedToSpring(true);
        ADD_FORCE_SPRING_SECONDARY.setAnchorRigidBody(rigidbody);
        ADD_FORCE_SPRING_SECONDARY.setSpringConstant(springConstant);
        ADD_FORCE_SPRING_SECONDARY.setSpringLength(springLength);
        ADD_FORCE_SPRING_SECONDARY.setSpringVisible(false);

        rigidbody.addForce(ADD_FORCE_SPRING);
        secondarySpring.addForce(ADD_FORCE_SPRING_SECONDARY);


    }

    public void AddRigidRodForceToRigidBody(Rigidbody rigidbody, PVector anchorPoint, float length, float stiffness) {
        RigidbodyRod ADD_FORCE_ROD = new RigidbodyRod();
        ADD_FORCE_ROD.setAnchorPoint(anchorPoint);
        ADD_FORCE_ROD.setLength(length);
        ADD_FORCE_ROD.setStiffness(stiffness);
        rigidbody.addForce(ADD_FORCE_ROD);
    }

    public void AddRigidRodForceToRigidBody(Rigidbody rigidbody, Rigidbody anchorBody, float length, float stiffness) {
        RigidbodyRod ADD_FORCE_ROD = new RigidbodyRod();
        ADD_FORCE_ROD.setAnchorRigidbody(anchorBody);
        ADD_FORCE_ROD.setLength(length);
        ADD_FORCE_ROD.setStiffness(stiffness);
        ADD_FORCE_ROD.setConnectedToRigidbody(true);
        rigidbody.addForce(ADD_FORCE_ROD);
    }
}
