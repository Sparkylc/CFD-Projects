public class RigidBodyGeneration{

    public RigidBody CreateSphereBody(PVector position, float density, float restitution, float radius, boolean isStatic){
        float volume = 4.0f / 3.0f * (float)Math.PI * radius * radius * radius;

        if(volume < World.MIN_BODY_VOLUME) {
            System.out.println("Dimensions too small. Minimum volume is " + World.MIN_BODY_VOLUME);
            return null;
        }

        if(volume > World.MAX_BODY_VOLUME){
            System.out.println("Dimensions too large. Maximum volume is " + World.MAX_BODY_VOLUME);
            return null;
        }

        if(density < World.MIN_DENSITY){
            System.out.println("Density is too small. Minimum density is " + World.MIN_DENSITY);
            return null;
        }
        if(density > World.MAX_DENSITY){
            System.out.println("Density is too large. Maximum density is " + World.MAX_DENSITY);
            return null;
        }

        restitution = PhysicsMath.Clamp(restitution, 0f, 1f);

        float mass = density * volume;

        return new RigidBody(position, mass, density, volume, restitution, radius, isStatic, 0, 0, 0, 0);

    }

    
    public RigidBody CreateCuboidBody(PVector position, float density, float restitution, boolean isStatic, float width, float height, float depth){
        float volume = width * height * depth;

        if(volume < World.MIN_BODY_VOLUME) {
            System.out.println("Dimensions are too small. Minimum volume is " + World.MIN_BODY_VOLUME);
            return null;
        }

        if(volume > World.MAX_BODY_VOLUME){
            System.out.println("Dimensions are too large. Maximum volume is " + World.MAX_BODY_VOLUME);
            return null;
        }

        if(density < World.MIN_DENSITY){
            System.out.println("Density is too small. Minimum density is " + World.MIN_DENSITY);
            return null;
        }
        if(density > World.MAX_DENSITY){
            System.out.println("Density is too large. Maximum density is " + World.MAX_DENSITY);
            return null;
        }

        restitution = PhysicsMath.Clamp(restitution, 0f, 1f);

        float mass = density * volume;

        return new RigidBody(position, mass, density, volume, restitution, 0, isStatic, width, height, depth, 1);

    }
}