public class CollisionDetection {
    
    public void edgeCollision(Rigidbody rigidbody){
      if(rigidbody.getPosition().x < 0){
        rigidbody.getPosition().x = 0;
        rigidbody.getVelocity().x *= -1;
      }
      if(rigidbody.getPosition().x > width){
        rigidbody.getPosition().x = width;
        rigidbody.getVelocity().x *= -1;
      }
      if(rigidbody.getPosition().y < 0){
        rigidbody.getPosition().y = 0;
        rigidbody.getVelocity().y *= -1;
      }
      if(rigidbody.getPosition().y > height){
        rigidbody.getPosition().y = height;
        rigidbody.getVelocity().y *= -1;
      }
    }
}