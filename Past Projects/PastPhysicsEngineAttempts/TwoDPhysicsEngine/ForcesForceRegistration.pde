public class ForceRegistration {
  public ForceGenerator forceGenerator;
  public RigidBody2D rigidBody;

  public ForceRegistration(RigidBody2D rigidBody, ForceGenerator forceGenerator) {
    this.forceGenerator = forceGenerator;
    this.rigidBody = rigidBody;
  }

 @Override
 public boolean equals(Object other){
   if(other == null) return false;
   if(other.getClass() != ForceRegistration.class) return false;

   ForceRegistration forceRegistration = (ForceRegistration)other;
   return forceRegistration.rigidBody == this.rigidBody && forceRegistration.forceGenerator == this.forceGenerator;
 }
  
}
