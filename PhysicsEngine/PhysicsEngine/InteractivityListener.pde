Rigidbody movingRigidbody;

public class InteractivityListener {
  PVector position;
  float zoom;

  public InteractivityListener() {
    position = new PVector(0, 0);
    zoom = 1;
  }

  public void zoom(float amount, float mouseX, float mouseY) {
    PVector mouseBeforeZoom = screenToWorld(mouseX, mouseY);
    zoom *= amount;
    PVector mouseAfterZoom = screenToWorld(mouseX, mouseY);
    PVector shift = PVector.sub(mouseBeforeZoom, mouseAfterZoom);
    position.add(shift);
}

  public void applyTransform() {
    translate(width/2, height/2);
    scale(zoom);
    translate(-position.x, -position.y);
  }

  public void resetTransform() {
    translate(position.x, position.y);
    scale(1/zoom);
    translate(-width/2, -height/2);
  }
  
   public PVector screenToWorld(float x, float y) {
    float worldX = (x - width/2) / zoom + position.x;
    float worldY = (y - height/2) / zoom + position.y;
    return new PVector(worldX, worldY);
  }

  public void zoom(float amount) {
    zoom *= amount;
  }

  void move(float dx, float dy) {
    position.x += dx / zoom;
    position.y += dy / zoom;
  }
}

public void mouseWheel(MouseEvent event) {
    float e = event.getCount();
    interactivityListener.zoom(pow(1.1f, e), mouseX, mouseY);
}

public void mouseDragged() {
  interactivityListener.move(pmouseX - mouseX, pmouseY - mouseY);
}

public void mouseClicked() {
  for(Rigidbody rigidbody : rigidbodyArrayList) {
    rigidbody.mouseInteraction();
  }
}

public void mouseMoved(){
  for(Rigidbody rigidbody : rigidbodyArrayList) {
    rigidbody.updateMouseInteraction();
  }
}

int currentObject = 0;

public void keyPressed(){
  if(keyCode >= 0 && keyCode <= 9){
    currentObject = keyCode;
  } 
  if(key == 'w'){
      rigidbodyArrayList.get(currentObject).Move(new PVector(0, -10f));
      rigidbodyArrayList.get(currentObject).setTransformUpdateRequired(true);
  }
  if(key == 's'){
      rigidbodyArrayList.get(currentObject).Move(new PVector(0, 10f));
      rigidbodyArrayList.get(currentObject).setTransformUpdateRequired(true);
  }
  if(key == 'a'){
      rigidbodyArrayList.get(currentObject).Move(new PVector(-10f, 0));
      rigidbodyArrayList.get(currentObject).setTransformUpdateRequired(true);
  }
  if(key == 'd'){
      rigidbodyArrayList.get(currentObject).Move(new PVector(10f, 0));
      rigidbodyArrayList.get(currentObject).setTransformUpdateRequired(true);
  }
  if(keyCode == LEFT) {
    rigidbodyArrayList.get(currentObject).Rotate(-0.1f);
    rigidbodyArrayList.get(currentObject).setTransformUpdateRequired(true);
  }
  if(keyCode == RIGHT) {
    rigidbodyArrayList.get(currentObject).Rotate(0.1f);
    rigidbodyArrayList.get(currentObject).setTransformUpdateRequired(true);
  }
}

