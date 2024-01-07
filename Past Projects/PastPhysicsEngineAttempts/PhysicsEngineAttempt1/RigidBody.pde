public class RigidBody {
    
    public PVector position;
    public PVector rotation = new PVector(0,0,0);

    public PVector linearVelocity;

    public ArrayList<RigidBody> bodies;
    public Collisions collisionObject;


    public float angularVelocity;

    public final float Mass;
    public final float Density;
    public final float Restitution;
    public final float Volume;
    
    public final boolean IsStatic;

    public final float Radius;
    public final float Width;
    public final float Height;
    public final float Depth;

    public final int TypeID;
    public int colour;
    public PVector[][] faces;


    public RigidBody(PVector position, float mass, float density, float volume, float restitution, float radius, boolean isStatic, float width, float height, float depth, int TypeID){
        this.position = position;
        this.Mass = mass;
        this.Density = density;
        this.Restitution = restitution;
        this.IsStatic = isStatic;
        this.Width = width;
        this.Height = height;
        this.Depth = depth;
        this.Radius = radius;
        this.Volume = volume;
        this.TypeID = TypeID;
    }

    public void Move(PVector amount){
        position = position.add(amount);
    }
    public void Rotate(PVector amount){
        rotation = rotation.add(amount);
    }

    public void MoveTo(PVector position){
        this.position = position.copy();
    }
    
    

    
   
}