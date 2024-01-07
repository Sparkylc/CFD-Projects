

public class InteractivityListener {
  public PVector position;
  public float zoom;

  public InteractivityListener() {
    position = new PVector(0, -50);
    zoom = 10f;
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

  public float[] getCameraExtents(float padding) {

  float left = screenToWorld(padding, padding).x;
  float right = screenToWorld(width - padding, padding).x;
  float top = screenToWorld(padding, padding).y;
  float bottom = screenToWorld(width - padding, height - padding).y;

  return new float[] {left, right, top, bottom};
}
//Overloaded method that returns the camera extents as PVector coordinates
public PVector[] getWorldBoundsWithPadding(float padding) {
  PVector topLeft = screenToWorld(padding, padding);
  PVector topRight = screenToWorld(width - padding, padding);
  PVector bottomLeft = screenToWorld(padding, height - padding);
  PVector bottomRight = screenToWorld(width - padding, height - padding);

  return new PVector[] {topLeft, topRight, bottomLeft, bottomRight};
}
}

public void mouseWheel(MouseEvent event) {
    float e = -event.getCount();
    interactivityListener.zoom(pow(1.1f, e), mouseX, mouseY);
}

public void mouseDragged() {
  interactivityListener.move(pmouseX - mouseX, pmouseY - mouseY);
}

public void mouseClicked() {
  for(Rigidbody rigidbody : rigidbodyList) {
    rigidbody.mouseInteraction();
  }
    if(mouseButton == LEFT) {

    float width = random(0.1, 3); //0.1m to 3m
    float height = random(0.1, 3);
    float rotation = random(0, 3);

    Rigidbody rigidbody = RigidbodyGenerator.CreateBoxBody(width, height,
                                                           0.1f, 0.1f,
                                                           false, true,
                                                           true, 0.05,
                                                           new PVector(0, 0, 0),
                                                           new PVector(255, 255, 255));


    rigidbody.SetInitialPosition(interactivityListener.screenToWorld(mouseX, mouseY));

    //rigidbody.Rotate(rotation);
    rigidbody.addForceToForceRegistry(new Gravity());
    AddBodyToBodyEntityList(rigidbody);
  
  }
  if(mouseButton == RIGHT) {

    float radius = random(0.1, 2); //0.1m to 2m

    Rigidbody rigidbody = RigidbodyGenerator.CreateCircleBody(radius, 0.5f, 0.5f,
                                                              false, true, true,
                                                              0.05, new PVector(0, 0, 0),
                                                              new PVector(255, 255, 255));
    rigidbody.SetInitialPosition(interactivityListener.screenToWorld(mouseX, mouseY));
    rigidbody.setAngularVelocity(random(-0.5f, 0.5f));

    
    rigidbody.addForceToForceRegistry(new Gravity());
    AddBodyToBodyEntityList(rigidbody);

  }
}





