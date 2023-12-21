import java.math.BigDecimal;
import controlP5.*;
import processing.svg.*;
import garciadelcastillo.dashedlines.*;

float framesPerSecond = 240;
float metersPerPixel = 1;

int screenWidth = 1920;
int screenHeight = 1080; 

int paddingX = 50;
int paddingY = 50;



PVector initialMousePosition = new PVector();
PVector finalMousePosition = new PVector();
PVector centerOfMass = new PVector();



//mouse booleans for mouse interactions
boolean mousePressed = false;
boolean mouseReleased = false;

float panX = 0;
float panY = 0;
float lockedPanX = 0;
float lockedPanY = 0;
float zoom = 1;
float oldZoom = 1;
float zoomFactor = 1.1;
float scale  = 1;

int lockCount = 0;

//declares a user interface object
UserInterface userInterfaceController;;
ControlP5 userInterface;


float gravitationalScalingCoefficient = 25;
//initializes the timestep size and the simulation object
float dt = 0.001;
Simulation simulation = new Simulation();

PImage bg;
// Declare the main DashedLines object

void setup() {
    offset = new PVector(width / 2, height / 2);
    fullScreen();
    frameRate(framesPerSecond);
    userInterface = new ControlP5(this);
    userInterfaceController = new UserInterface(userInterface);
    bg= loadImage("output.png");
    bg.resize(screenWidth, screenHeight);
    
    
}

//adds the zooming functionality

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
    if (!userInterface.isMouseOver() && mouseButton == LEFT) {
       // Adjust initial mouse position based on panning and zooming amount
        float worldMouseX = (mouseX / zoom) - panX;
        float worldMouseY = (mouseY / zoom) - panY;
        initialMousePosition.set(worldMouseX, worldMouseY);
        mousePressed = true;
        mouseReleased = false;
}
}

void mouseDragged() {
    if(mouseButton == RIGHT && !userInterface.isMouseOver() && userInterface.getController("Lock View to Center of Mass").getValue() == 0) {
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
    if (!userInterface.isMouseOver() && mouseButton != RIGHT) {
        //makes the final mouse position relative to the pan amount
        //finalMousePosition.set(mouseX - panX, mouseY - panY);
        
        float worldMouseX = (mouseX / zoom) - panX;
        float worldMouseY = (mouseY / zoom) - panY;
        finalMousePosition.set(worldMouseX, worldMouseY);
        mousePressed = false;
        mouseReleased = true;
        
        float radius = userInterface.getController("Radius").getValue();
        float mass = userInterface.getController("Mass").getValue();
        Body body;
        if (userInterface.getController("Fixed Body").getValue() == 1) {
            //checks if the fixed body checkbox is checked, if it is, creates a different object
            body =new Body(finalMousePosition, mass, radius, true);
        } else {
            body= new Body(finalMousePosition, mass, radius, false);
            body.initialVelocity(initialMousePosition, finalMousePosition);
        }
        
        simulation.addNewBody(body);
        
    }
}


void lockToCenterOfMass() {

      if(userInterface.getController("Lock View to Center of Mass").getValue() == 1) {
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

void draw() {

background(16,18,19);



// Apply zoom and pan transformations

noFill();
strokeWeight(2);
strokeJoin(MITER);
stroke(#3f3f3f);
beginShape();
vertex(paddingX, paddingY);
vertex(width - paddingX, paddingY);
vertex(width - paddingX, height - paddingY);
vertex(paddingX, height - paddingY);
vertex(paddingX, paddingY);
endShape();

    if(userInterface.getController("Lock View to Center of Mass").getValue() == 1) {
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
/*
for (int majorVerticalGridLine = 10; majorVerticalGridLine < (width - paddingX) / zoom; majorVerticalGridLine += 120) {
    fill(#3f3f3f);
    rect(majorVerticalGridLine, paddingY / zoom, 1 / zoom, (height - 2 * paddingY) / zoom);
} 
for (int secondaryMajorVerticalGridline = 70; secondaryMajorVerticalGridline < (width - paddingX) / zoom; secondaryMajorVerticalGridline += 60) {
    fill(#3f3f3f);
    rect(secondaryMajorVerticalGridline, paddingY / zoom, 0.5 / zoom, (height - 2 * paddingY) / zoom);
}
for (int minorVerticalGridLine = 10; minorVerticalGridLine < (width - paddingX) / zoom; minorVerticalGridLine += 30) {
    fill(#3f3f3f);
    rect(minorVerticalGridLine, paddingY / zoom, 0.25 / zoom, (height - 2 * paddingY) / zoom);
}

// Horizontal grid lines
for (int majorHorizontalGridLine = 10; majorHorizontalGridLine < (height - paddingY) / zoom; majorHorizontalGridLine += 120) {
    fill(#3f3f3f);
    rect(paddingX / zoom, majorHorizontalGridLine, (width - 2 * paddingX) / zoom, 1 / zoom);
}
for (int secondaryMajorHorizontalGridline = 70; secondaryMajorHorizontalGridline < (height - paddingY) / zoom; secondaryMajorHorizontalGridline += 60) {
    fill(#3f3f3f);
    rect(paddingX / zoom, secondaryMajorHorizontalGridline, (width - 2 * paddingX) / zoom, 0.5 / zoom);
}
for (int minorHorizontalGridLine = 10; minorHorizontalGridLine < (height - paddingY) / zoom; minorHorizontalGridLine += 30) {
    fill(#3f3f3f);
    rect(paddingX / zoom, minorHorizontalGridLine, (width - 2 * paddingX) / zoom, 0.25 / zoom);
}
*/




// Calculate the screen space position of the corners of the viewport

// Draw the grid
/*
stroke(#3f3f3f);
for (float x = firstLineX; x < width - panX - padding; x += gridSpacing) {
    float screenX = (x + panX);
    line(screenX + padding, padding, screenX + padding, height-padding);
}
for (float y = firstLineY; y < height - panY -  padding; y += gridSpacing) {
    float screenY = (y + panY);
    line(padding, screenY + padding, width - padding, screenY + padding);
}

*/
// Define grid spacing

// Draw vertical grid lines
/*
for (int i = gridStartX; i <= gridEndX; i += 10) {
    float lineWidth = (i % 120 == 0) ? 1 : (i % 60 == 0) ? 0.5 : 0.25;
    rect(i, 0, lineWidth / zoom, height / zoom);
}

// Draw horizontal grid lines
for (int i = gridStartY; i <= gridEndY; i += 10) {
    float lineHeight = (i % 120 == 0) ? 1 : (i % 60 == 0) ? 0.5 : 0.25;
    rect(0, i, width / zoom, lineHeight / zoom);
}
*/


    colorMode(RGB, 255);
    hint(ENABLE_STROKE_PURE);

    
    
    simulation.display();
    simulation.updateVectors();
    userInterfaceController.centerOfMass(simulation.getBodyArray());
    simulation.updateBodies();
    
    
    if (mousePressed == true && mouseReleased == false &&  userInterface.getController("Fixed Body").getValue() == 0) {
        //adjusts current mouse position based on panning amount
        float worldMouseX = (mouseX / zoom) - panX;
        float worldMouseY = (mouseY / zoom) - panY;
        
        stroke(0,0,0);
        strokeWeight(12.5);
        line(initialMousePosition.x, initialMousePosition.y, worldMouseX, worldMouseY);
        strokeWeight(5);
        stroke(255,255,255);
        line(initialMousePosition.x, initialMousePosition.y, worldMouseX, worldMouseY);
        
    }
    
    resetMatrix();
    userInterface.draw();
    
}





