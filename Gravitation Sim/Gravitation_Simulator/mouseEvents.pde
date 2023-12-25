//adds the zooming functionality
boolean checkInBounds(){
    if(
        mouseX > userInterfaceController.globalPaddingX 
                && 
        mouseX < width - userInterfaceController.globalPaddingX 
                && 
        mouseY > userInterfaceController.globalPaddingY 
                && 
        mouseY < height - userInterfaceController.globalPaddingY
        ){
            return true;
        } else {
            return false;
    }
}
void mouseWheel(MouseEvent event) {
    oldZoom = zoom;
    float wheelRotation = -event.getCount();
    zoom *= pow(zoomFactor, wheelRotation);

    float zoomX, zoomY;
  
        // Otherwise, zoom relative to the mouse position
    zoomX = mouseX;
    zoomY = mouseY;


    // Adjust pan to keep the point under the zoomX, zoomY fixed
    float zoomWorldX = (zoomX) / oldZoom - panX;
    float zoomWorldY = (zoomY) / oldZoom - panY;
    panX = (zoomX) / zoom - zoomWorldX;
    panY = (zoomY) / zoom - zoomWorldY;
    

    // Adjust initial mouse position to keep it fixed in world space
    scale = zoom / oldZoom;
    initialMousePosition.x = panX + (initialMousePosition.x - panX) * scale;
    initialMousePosition.y = panY + (initialMousePosition.y - panY) * scale;
    }

void mousePressed() {
    //creates a new object at the mouses current coordinaes
    if (!userInterface.isMouseOver() && mouseButton == LEFT && checkInBounds() && userInterface.getController(activeTab + " Generate Orbiting Planet").getValue() == 0) {
       // Adjust initial mouse position based on panning and zooming amount
        PVector currentMousePosition = getMouseWorldCoordinates();
        initialMousePosition.set(currentMousePosition.x, currentMousePosition.y);
        mousePressed = true;
        mouseReleased = false;
    } else if(!userInterface.isMouseOver() && mouseButton == LEFT && checkInBounds() && userInterface.getController(activeTab + " Generate Orbiting Planet").getValue() == 1){
        Body clickedBody = simulation.getClickedBody();
        if(clickedBody != null) {
            float orbitingBodyMass = int(userInterface.get(Textfield.class, activeTab + " Planet Mass").getText());
            float orbitingBodyRadius = int(userInterface.get(Textfield.class, activeTab + " Planet Radius").getText());
            float orbitingBodyDistance = int(userInterface.get(Textfield.class, activeTab + " Planet Distance").getText());

            simulation.spawnOrbitingBody(clickedBody, orbitingBodyMass, orbitingBodyRadius, orbitingBodyDistance);
        }
    }
}




void mouseDragged() {
    if(mouseButton == RIGHT && checkInBounds() && !userInterface.isMouseOver() && userInterface.getController(activeTab + " Lock View to Center of Mass").getValue() == 0) {
        //panX += mouseX - pmouseX;
        //panY += mouseY - pmouseY;
        //initialMousePosition.set(mouseX - panX, mouseY - panY);
        float mouseDeltaX = (mouseX - pmouseX) / zoom;
        float mouseDeltaY = (mouseY - pmouseY) / zoom;
        panX+= mouseDeltaX;
        panY+= mouseDeltaY;
        initialMousePosition.x -= mouseDeltaX;
        initialMousePosition.y -= mouseDeltaY;
        
        // Adjust initial mouse position to keep it fixed in world space
        
}
}

void mouseReleased() {
    if (!userInterface.isMouseOver() && mouseButton != RIGHT && checkInBounds() && userInterface.getController(activeTab + " Generate Orbiting Planet").getValue() == 0) {
        //makes the final mouse position relative to the pan amount
        //finalMousePosition.set(mouseX - panX, mouseY - panY);
        
        float worldMouseX = (mouseX / zoom) - panX;
        float worldMouseY = (mouseY / zoom) - panY;
        finalMousePosition.set(worldMouseX, worldMouseY);
        mousePressed = false;
        mouseReleased = true;

        //gets the current active tab to call to different controller objects based on which tab is active
    
        
        float radius = userInterface.getController(activeTab + " Radius").getValue();
        float mass = userInterface.getController(activeTab + " Mass").getValue();

        if (userInterface.getController(activeTab + " Fixed Body").getValue() == 1) {
            Body body = new FixedBody(finalMousePosition, mass, radius);
             simulation.addNewBody(body);
        } else {
            Body body = new Body (finalMousePosition, mass, radius);
            body.initialVelocity(initialMousePosition, finalMousePosition);
             simulation.addNewBody(body);
        }
        
        
    }
}


void lockToCenterOfMass() {

      if(userInterface.getController(activeTab + " Lock View to Center of Mass").getValue() == 1) {
        float totalMass = 0;
        PVector weightedPosition = new PVector();
        for (Body body : simulation.bodies) {
            totalMass += body.mass;
            weightedPosition.add(PVector.mult(body.position, body.mass));
        }

        // Calculate the center of mass
        centerOfMass = PVector.div(weightedPosition, totalMass);
   
        // Set the pan values to the center of the screen minus the center of mass
        lockedPanX = (width / 2 - centerOfMass.x);
        lockedPanY = (height / 2 - centerOfMass.y);
    }
}


PVector getMouseWorldCoordinates() {
  if(userInterface.getController(activeTab + " Lock View to Center of Mass").getValue() == 1) {
    return new PVector((mouseX - width / 2) / zoom + centerOfMass.x, (mouseY - height / 2) / zoom + centerOfMass.y);
  } else {
    return new PVector((mouseX / zoom) - panX, (mouseY / zoom) - panY);
  }
}
