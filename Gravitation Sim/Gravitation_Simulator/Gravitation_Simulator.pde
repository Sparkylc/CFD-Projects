


void setup() {
    offset = new PVector(width / 2, height / 2);
    fullScreen();
    frameRate(framesPerSecond);
    userInterface = new ControlP5(this);
    userInterfaceController = new UserInterface(userInterface);
}

void draw() {
    activeTab = userInterfaceController.getActiveTab();
    background(16, 18, 19);
    noStroke();
    userInterfaceController.drawGrid();
// Apply zoom and pan transformations

    if(userInterface.getController(activeTab + " Lock View to Center of Mass").getValue() == 1) {
        this.lockToCenterOfMass();
        translate(width/2, height/2);
        scale(zoom);
        translate(-width/2, -height/2);
        translate(lockedPanX, lockedPanY);
        panX = lockedPanX;
        panY = lockedPanY;
    } else{
        scale(zoom);
        translate(panX, panY);
    }






    colorMode(RGB, 255);
    hint(ENABLE_STROKE_PURE);

    
    
    simulation.display();
    simulation.updateVectors();
    userInterfaceController.centerOfMass(simulation.getBodyArray());
    userInterfaceController.drawPath();
    simulation.updateBodies();
    
    
    if (mousePressed == true && mouseReleased == false &&  userInterface.getController(activeTab + " Fixed Body").getValue() == 0) {
        //adjusts current mouse position based on panning amount
        
        PVector currentMousePosition = getMouseWorldCoordinates();
        float worldMouseX = (mouseX / zoom) - panX;
        float worldMouseY = (mouseY / zoom) - panY;

        
        stroke(0,0,0);
        strokeWeight(12.5);
        line(initialMousePosition.x, initialMousePosition.y, currentMousePosition.x, currentMousePosition.y);
        strokeWeight(5);
        stroke(255,255,255);
        line(initialMousePosition.x, initialMousePosition.y, currentMousePosition.x, currentMousePosition.y);
        
    }
    
    resetMatrix();
    userInterface.draw();
    userInterfaceController.drawPadding();

}










