/*
  ======================================================================================================
  ========================================== MOUSE EVENTS ==============================================
  ======================================================================================================
*/

public void mousePressed(){

}

public void mouseClicked(){
  for(Rigidbody rigidbody : rigidbodyArrayList) {
    rigidbody.OnMouseClick();
  }
}

public void mouseReleased(){

}

public void mouseMoved(){
 for(Rigidbody rigidbody : rigidbodyArrayList) {
    rigidbody.OnMouseMove();
  }
}
public void mouseDragged(){
}
public void mouseWheel(MouseEvent event){
}

/*
  ======================================================================================================
  ========================================== KEY EVENTS ================================================
  ======================================================================================================
*/
public void keyPressed(){
  if(key == ' ') {
    PhysicsWorld.IS_SIMULATION_PAUSED = !PhysicsWorld.IS_SIMULATION_PAUSED;
  }
}
