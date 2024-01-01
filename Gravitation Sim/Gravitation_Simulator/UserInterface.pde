
class UserInterface {
        ArrayList<Tab> tabs = new ArrayList<Tab>();
        //the active tab

        //the width and height of the groups
        int globalGroupBackgroundHeight = 400;
        int globalGroupWidth = 320;   

        //width and height of the sliders
        int globalSliderWidth = 200;
        int globalSliderHeight = 20;

        //sets the bar height for the tob of the group
        int globalGroupBarHeight = 20;

        //center of mass position variables
        float centerOfMassX;
        float centerOfMassY;

        //the global padding used for the borders and to position the groups
        int globalPaddingX = 50;
        int globalPaddingY = 50;


        //global initial position for the elements of the group
        int globalInitialPositionX = 10;
        int globalInitialPositionY = 20;
        
        //the global padding used to position elements within the groups (this is relative to group coordinates)
        int globalGroupElementPaddingX = 10;
        int globalGrouldElementPaddingY = 10;

        //the control group background color
        int globalGroupColor = color(250, 50);

        //this basically tells you the spacing between the elements of the group
        int globalGroupElementSpacingX = 30;
        int globalGroupElementSpacingY = 30;

        //zero indexed element number to do the spacing based on how many elements there are sequentially
        int elementNumber = 0; 



        //variables for the line  
        int pathLength = 5000;
        float[] xvals = new float[pathLength];
        float[] yvals = new float[pathLength];


        







        //the constructor uses the passed object to make changes, while the methods outside of the constructor use the already created object in the 
        //gravity simulation class

        UserInterface(ControlP5 userInterface){
                //hides the default tab
                // initializes the tabs for the user interface
                
                Tab controlTab = userInterface.addTab("controlTab")
                                .setLabel("Controls")
                                .setId(0);
                        tabs.add(controlTab);
                         

                Tab sunTab = userInterface.addTab("sunTab")
                                .setLabel("Sun")
                                .setId(1);
                        tabs.add(sunTab);

                Tab planetTab = userInterface.addTab("planetTab")
                                .setLabel("Planet");
                  

                Tab moonTab = userInterface.addTab("moonTab")
                                .setLabel("Moon");
                              

                Tab celestialObjectsTab = userInterface.addTab("CelestialObjectsTab")
                                .setLabel("Celestial Objects");
                              
                
               

                //creates the group for the basical controls group
                Group controlsGroup = userInterface.addGroup("Controls")
                                .setPosition(width - globalGroupWidth + globalPaddingX, globalPaddingY)
                                .setBackgroundHeight(globalGroupBackgroundHeight)
                                .setBarHeight(globalGroupBarHeight)
                                .setBackgroundColor(globalGroupColor)
                                .setWidth(globalSliderWidth + globalPaddingX * 2)
                                 //.disableCollapse()
                                .setTab("controlTab")
                                ;



                        Slider controlMass = userInterface.addSlider("controlTab Mass")
                                        .setPosition(globalInitialPositionX, globalInitialPositionY + globalGroupElementSpacingY * elementNumber)
                                        .setSize(globalSliderWidth, globalSliderHeight)
                                        .setLabel("Mass")
                                        .setRange(0, 2000)
                                        .setValue(1000)
                                        .setGroup(controlsGroup)
                                        ;
                                        elementNumber++;

                        Slider controlRadius = userInterface.addSlider("controlTab Radius")
                                        .setPosition(globalInitialPositionX, globalInitialPositionY + globalGroupElementSpacingY * elementNumber)
                                        .setSize(200,20)
                                        .setLabel("Radius")
                                        .setRange(0, 200)
                                        .setValue(100)
                                        .setGroup(controlsGroup)
                                        ;
                                        elementNumber++;

                        Button controlResetSimulation = userInterface.addButton("controlTab Reset Simulation")
                                        .setPosition(globalInitialPositionX, globalInitialPositionY + globalGroupElementSpacingY * elementNumber)
                                        .setSize(200,20)
                                        .setLabel("Reset Simulation")
                                        .setGroup(controlsGroup)
                                        .onClick(new CallbackListener() {
                                                 void controlEvent(CallbackEvent theEvent) {
                                                        simulation.resetSimulation();
                                                }
                                        })
                                        ;
                                        elementNumber++;



                        Toggle controlShowVelocityVectors = userInterface.addToggle("controlTab Show Velocity Vectors")
                                        .setPosition(globalInitialPositionX, globalInitialPositionY + globalGroupElementSpacingY * elementNumber)
                                        .setSize(200,20)
                                        .setLabel("Show Velocity Vectors")
                                        .setGroup(controlsGroup)
                                        .setValue(false)
                                        ;
                                        elementNumber++;


                        Toggle controlShowAccelerationVectors = userInterface.addToggle("controlTab Show Acceleration Vectors")
                                        .setPosition(globalInitialPositionX, globalInitialPositionY + globalGroupElementSpacingY * elementNumber)
                                        .setSize(200,20)
                                        .setLabel("Show Acceleration Vectors")
                                        .setGroup(controlsGroup)
                                        .setValue(false)
                                        ;
                                        elementNumber++;


                        Toggle controlFixedBody = userInterface.addToggle("controlTab Fixed Body")
                                        .setPosition(globalInitialPositionX, globalInitialPositionY + globalGroupElementSpacingY * elementNumber)
                                        .setSize(200,20)
                                        .setLabel("Fixed Body")
                                        .setGroup(controlsGroup)
                                        .setValue(false)
                                        ;
                                        elementNumber++;

                        Slider controlGravityScale = userInterface.addSlider("controlTab Gravity Scale")
                                        .setPosition(globalInitialPositionX, globalInitialPositionY + globalGroupElementSpacingY * elementNumber)
                                        .setSize(200,20)
                                        .setLabel("Gravity Scale")
                                        .setRange(1, 10000000)
                                        .setValue(5000000)
                                        .setGroup(controlsGroup)
                                        .onChange(new CallbackListener() {
                                                void controlEvent(CallbackEvent theEvent) {
                                                        float gravityScaleValue = userInterface.getController(activeTab + " Gravity Scale").getValue();
                                                        gravitationalScalingCoefficient = gravityScaleValue;
                                                        }
                                                })
                                        ;
                                        elementNumber++;

                        Toggle controlShowCenterOfMass = userInterface.addToggle("controlTab Show Center of Mass")
                                        .setPosition(globalInitialPositionX, globalInitialPositionY + globalGroupElementSpacingY * elementNumber)
                                        .setSize(200,20)
                                        .setLabel("Show Center of Mass")
                                        .setGroup(controlsGroup)
                                        .setValue(false)
                                        ;
                                        elementNumber++;

                        Toggle controlLockViewToCenterOfMass = userInterface.addToggle("controlTab Lock View to Center of Mass")
                                        .setPosition(globalInitialPositionX, globalInitialPositionY + globalGroupElementSpacingY * elementNumber)
                                        .setSize(globalSliderWidth,20)
                                        .setLabel("Lock View to Center of Mass")
                                        .setGroup(controlsGroup)
                                        .setValue(false)
                                        ;
                                        elementNumber++;
                        Toggle controlShowTrail = userInterface.addToggle("controlTab Show Trail")
                                        .setPosition(globalInitialPositionX, globalInitialPositionY + globalGroupElementSpacingY * elementNumber)
                                        .setSize(globalSliderWidth,20)
                                        .setLabel("Show Trail")
                                        .setGroup(controlsGroup)
                                        .setValue(false)
                                        ;
                                        elementNumber++;
                        Toggle controlGenerateOrbitingPlanet = userInterface.addToggle("controlTab Generate Orbiting Planet")
                                        .setPosition(globalInitialPositionX, globalInitialPositionY + globalGroupElementSpacingY * elementNumber)
                                        .setSize(globalSliderWidth,20)
                                        .setLabel("Generate Orbiting Planet")
                                        .setGroup(controlsGroup)
                                        .setValue(false)
                                        .onChange(new CallbackListener() {
                                                void controlEvent(CallbackEvent theEvent) {
                                                       userInterface.getController("controlTab Fixed Body").setValue(0);
                                                }
                                        })
                                        ;
                                        elementNumber++;
                        Textfield controlPlanetMass = userInterface.addTextfield("controlTab Planet Mass")
                                        .setPosition(globalGroupElementPaddingX, globalInitialPositionY + globalGroupElementSpacingY * elementNumber)
                                        .setSize(50, 20)
                                        .setText("")
                                        .setGroup(controlsGroup)
                                        .setColor(color(255,255,255))
                                        .setVisible(true)
                                        .setLabel("Mass")
                                        ;
                        Textfield controlPlanetRadius = userInterface.addTextfield("controlTab Planet Radius")
                                        .setPosition(globalGroupElementPaddingX + 70, globalInitialPositionY + globalGroupElementSpacingY * elementNumber)
                                        .setSize(50, 20)
                                        .setText("")
                                        .setColor(color(255,255,255))
                                        .setVisible(true)
                                        .setGroup(controlsGroup)
                                        .setLabel("Radius")
                                        ;
                        Textfield controlPlanetDistance = userInterface.addTextfield("controlTab Planet Distance")
                                        .setPosition(globalGroupElementPaddingX + 140, globalInitialPositionY + globalGroupElementSpacingY * elementNumber)
                                        .setSize(50, 20)
                                        .setText("")
                                        .setColor(color(255,255,255))
                                        .setVisible(true)
                                        .setGroup(controlsGroup)
                                        .setLabel("Distance")
                                        ;
                                        elementNumber = 0;


                //group for sun controls
                Group sunGroup = userInterface.addGroup("sunGroup")
                                .setLabel("Sun Controls")
                                .setPosition(width - globalGroupWidth + globalPaddingX, globalPaddingY)
                                .setBackgroundHeight(globalGroupBackgroundHeight)
                                .setBarHeight(globalGroupBarHeight)
                                .setBackgroundColor(globalGroupColor)
                                .setWidth(globalSliderWidth + globalPaddingX * 2)
                                //.disableCollapse()
                                .setTab("sunTab")
                                ;



                        Slider sunMass = userInterface.addSlider("sunTab Mass")
                                        .setPosition(globalInitialPositionX, globalInitialPositionY + globalGroupElementSpacingY * elementNumber)
                                        .setSize(globalSliderWidth, globalSliderHeight)
                                        .setLabel("Sun Mass")
                                        .setRange(0, 2000000)
                                        .setValue(1000000)
                                        .setGroup(sunGroup)
                                        ;
                                        elementNumber++;

                        Slider sunRadius = userInterface.addSlider("sunTab Radius")
                                        .setPosition(globalInitialPositionX, globalInitialPositionY + globalGroupElementSpacingY * elementNumber)
                                        .setSize(200,20)
                                        .setLabel("Sun Radius")
                                        .setRange(0, 10000)
                                        .setValue(5000)
                                        .setGroup(sunGroup)
                                        ;
                                        elementNumber++;

                        Button sunResetSimulation = userInterface.addButton("sunTab Reset Simulation")
                                        .setPosition(globalInitialPositionX, globalInitialPositionY + globalGroupElementSpacingY * elementNumber)
                                        .setSize(200,20)
                                        .setLabel("Reset Simulation")
                                        .setGroup(sunGroup)
                                        .onClick(new CallbackListener() {
                                                 void controlEvent(CallbackEvent theEvent) {
                                                        simulation.resetSimulation();
                                                }
                                        })
                                        ;
                                        elementNumber++;



                        Toggle sunShowVelocityVectors = userInterface.addToggle("sunTab Show Velocity Vectors")
                                        .setPosition(globalInitialPositionX, globalInitialPositionY + globalGroupElementSpacingY * elementNumber)
                                        .setSize(200,20)
                                        .setLabel("Show Velocity Vectors")
                                        .setGroup(sunGroup)
                                        .setValue(false)
                                        ;
                                        elementNumber++;


                        Toggle sunShowAccelerationVectors = userInterface.addToggle("sunTab Show Acceleration Vectors")
                                        .setPosition(globalInitialPositionX, globalInitialPositionY + globalGroupElementSpacingY * elementNumber)
                                        .setSize(200,20)
                                        .setLabel("Show Acceleration Vectors")
                                        .setGroup(sunGroup)
                                        .setValue(false)
                                        ;
                                        elementNumber++;


                        Toggle sunFixedBody = userInterface.addToggle("sunTab Fixed Body")
                                        .setPosition(globalInitialPositionX, globalInitialPositionY + globalGroupElementSpacingY * elementNumber)
                                        .setSize(200,20)
                                        .setLabel("Fixed Body")
                                        .setGroup(sunGroup)
                                        .setValue(false)
                                        ;
                                        elementNumber++;

                        Slider sunGravityScale = userInterface.addSlider("sunTab Gravity Scale")
                                        .setPosition(globalInitialPositionX, globalInitialPositionY + globalGroupElementSpacingY * elementNumber)
                                        .setSize(200,20)
                                        .setLabel("Gravity Scale")
                                        .setRange(1, 100)
                                        .setValue(1)
                                        .setGroup(sunGroup)
                                        .onChange(new CallbackListener() {
                                                void controlEvent(CallbackEvent theEvent) {
                                                        float gravityScaleValue = userInterface.getController(activeTab + " Gravity Scale").getValue();
                                                        gravitationalScalingCoefficient = gravityScaleValue;
                                                        }
                                                })
                                        ;
                                        elementNumber++;

                        Toggle sunShowCenterOfMass = userInterface.addToggle("sunTab Show Center of Mass")
                                        .setPosition(globalInitialPositionX, globalInitialPositionY + globalGroupElementSpacingY * elementNumber)
                                        .setSize(200,20)
                                        .setLabel("Show Center of Mass")
                                        .setGroup(sunGroup)
                                        .setValue(false)
                                        ;
                                        elementNumber++;

                        Toggle sunlockViewToCenterOfMass = userInterface.addToggle("sunTab Lock View to Center of Mass")
                                        .setPosition(globalInitialPositionX, globalInitialPositionY + globalGroupElementSpacingY * elementNumber)
                                        .setSize(globalSliderWidth, 20)
                                        .setLabel("Lock View to Center of Mass")
                                        .setGroup(sunGroup)
                                        .setValue(false)
                                        ;
                                        elementNumber++;
                        Toggle sunShowTrail = userInterface.addToggle("sunTab Show Trail")
                                        .setPosition(globalInitialPositionX, globalInitialPositionY + globalGroupElementSpacingY * elementNumber)
                                        .setSize(globalSliderWidth,20)
                                        .setLabel("Show Trail")
                                        .setGroup(sunGroup)
                                        .setValue(false)
                                        ;
                                        elementNumber++;
                        Toggle sunGenerateOrbitingPlanet = userInterface.addToggle("sunTab Generate Orbiting Planet")
                                        .setPosition(globalInitialPositionX, globalInitialPositionY + globalGroupElementSpacingY * elementNumber)
                                        .setSize(globalSliderWidth,20)
                                        .setLabel("Generate Orbiting Planet")
                                        .setGroup(sunGroup)
                                        .setValue(false)
                                        .onChange(new CallbackListener() {
                                                void controlEvent(CallbackEvent theEvent) {
                                                       userInterface.getController("sunTab Fixed Body").setValue(0);
                                                }
                                        })
                                        ;
                                        elementNumber++;
                        Textfield sunPlanetMass = userInterface.addTextfield("sunTab Planet Mass")
                                        .setPosition(globalGroupElementPaddingX, globalInitialPositionY + globalGroupElementSpacingY * elementNumber)
                                        .setSize(50, 20)
                                        .setText("")
                                        .setGroup(sunGroup)
                                        .setColor(color(255,255,255))
                                        .setVisible(true)
                                        .setLabel("Mass")
                                        ;
                        Textfield sunPlanetRadius = userInterface.addTextfield("sunTab Planet Radius")
                                        .setPosition(globalGroupElementPaddingX + 70, globalInitialPositionY + globalGroupElementSpacingY * elementNumber)
                                        .setSize(50, 20)
                                        .setGroup(sunGroup)
                                        .setText("")
                                        .setColor(color(255,255,255))
                                        .setVisible(true)
                                        .setLabel("Radius")
                                        ;
                        Textfield sunPlanetDistance = userInterface.addTextfield("sunTab Planet Distance")
                                        .setPosition(globalGroupElementPaddingX + 140, globalInitialPositionY + globalGroupElementSpacingY * elementNumber)
                                        .setSize(50, 20)
                                        .setGroup(sunGroup)
                                        .setText("")
                                        .setColor(color(255,255,255))
                                        .setVisible(true)
                                        .setLabel("Distance")
                                        ;
                                        elementNumber = 0;
                

             
                
                
                
                
                //Formatting
                userInterface.getController("controlTab Show Velocity Vectors").getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER);
                userInterface.getController("controlTab Show Acceleration Vectors").getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER);
                userInterface.getController("controlTab Fixed Body").getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER);
                userInterface.getController("controlTab Reset Simulation").getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER);
                userInterface.getController("controlTab Gravity Scale").getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER);
                userInterface.getController("controlTab Show Center of Mass").getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER);
                userInterface.getController("controlTab Lock View to Center of Mass").getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER);
                userInterface.getController("controlTab Show Trail").getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER);
                userInterface.getController("controlTab Generate Orbiting Planet").getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER);
                        
                        
                        



                userInterface.getController("sunTab Show Velocity Vectors").getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER);
                userInterface.getController("sunTab Show Acceleration Vectors").getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER);
                userInterface.getController("sunTab Fixed Body").getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER);
                userInterface.getController("sunTab Reset Simulation").getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER);
                userInterface.getController("sunTab Gravity Scale").getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER);
                userInterface.getController("sunTab Show Center of Mass").getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER);
                userInterface.getController("sunTab Lock View to Center of Mass").getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER);
                userInterface.getController("sunTab Show Trail").getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER);
                userInterface.getController("sunTab Generate Orbiting Planet").getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER);
        

                userInterface.getTab("default").hide();

                



    
        }

//gets the name of the current active group (workaround for not being able to find tab name)
String getActiveTab() {
    for (Tab tab : tabs) {
        if (tab.isActive()) {
                if(tab.getId() == 0){
                        return "controlTab";
                }
                if(tab.getId() == 1){
                        return "sunTab";
                }
                if(tab.getId() == 2){
                        return "planetTab";
                }
                if(tab.getId() == 3){
                        return "moonTab";
                }
                if(tab.getId() == 4){
                        return "CelestialObjectsTab";
                }
        }
    }
    //default return for initialization
    return "controlTab";
}
//creates the velocity vector arrow for the body
void velocityVectorArrow(Body body){
      if(userInterface.get(activeTab + " Show Velocity Vectors").getValue() == 1){
        // draw a line representing the velocity vector of the body
        
        // set the color of the line to red
        float arrowLength = 20; // length of the arrow
        float arrowAngle = PI / 4; // angle of the arrow
        float arrowX = body.position.x + body.velocity.x * arrowLength * cos(arrowAngle);
        float arrowY = body.position.y + body.velocity.y * arrowLength * sin(arrowAngle);
        stroke(0,0,0);
        strokeWeight(12.5);
        line(body.position.x, body.position.y, arrowX, arrowY);
        strokeWeight(5);
        stroke(255,255,255);
        line(body.position.x, body.position.y, arrowX, arrowY);
        // add arrow head
        float arrowHeadSize = 5; // size of the arrow head
        pushMatrix();
        translate(arrowX, arrowY);
        rotate(atan2(arrowY - body.position.y, arrowX - body.position.x));
        stroke(0, 0, 0);
        strokeWeight(12.5);
        triangle(-arrowHeadSize, arrowHeadSize / 2 , -arrowHeadSize, -arrowHeadSize / 2, 0, 0);
        stroke(255,255,255);
        strokeWeight(5);
        triangle(-arrowHeadSize, arrowHeadSize / 2, -arrowHeadSize, -arrowHeadSize / 2 , 0, 0);
        popMatrix();
        }
       
}


//creates the acceleration vector arrow for the body
void accelerationVectorArrow(Body body) {
        if (userInterface.get(activeTab + " Show Acceleration Vectors").getValue() == 1) {
                // draw a line representing the acceleration vector of the body
                stroke(0, 0, 255); // set the color of the line to blue
                float arrowLength = 20; // length of the arrow
                float dampeningFactor = 0.002; // dampening factor for scaling the vector                
                float arrowX = body.position.x + body.currentAccelerationVector.x * arrowLength * dampeningFactor;
                float arrowY = body.position.y + body.currentAccelerationVector.y * arrowLength * dampeningFactor;
                line(body.position.x, body.position.y, arrowX, arrowY);                // add arrow head
                float arrowHeadSize = 5; // size of the arrow head
                pushMatrix();
                translate(arrowX, arrowY);
                rotate(atan2(arrowY - body.position.y, arrowX - body.position.x));
                triangle(-arrowHeadSize, arrowHeadSize / 2, -arrowHeadSize, -arrowHeadSize / 2, 0, 0);
                popMatrix();
        }
}
        
void centerOfMass(ArrayList<Body> bodies){
        if(userInterface.get(activeTab + " Show Center of Mass").getValue() == 1){
                float totalMass = 0;
                float totalX = 0;
                float totalY = 0;
                for(int i = 0; i < bodies.size(); i++){
                        totalMass += bodies.get(i).mass;
                        totalX += bodies.get(i).position.x * bodies.get(i).mass;
                        totalY += bodies.get(i).position.y * bodies.get(i).mass;
                }
                float centerOfMassX = totalX / totalMass;
                float centerOfMassY = totalY / totalMass;
                stroke(255,0,0);
                strokeWeight(100);
                point(centerOfMassX, centerOfMassY);
       
        }
}



void drawPadding(){
        fill(16, 18, 19);
        noStroke();
        rect(0,0, globalPaddingX, height);
        rect(0,0, width, globalPaddingY);
        rect(width - globalPaddingX, 0, globalPaddingX, height);
        rect(0, height - globalPaddingY, width, globalPaddingY);
        stroke(#3f3f3f);
        strokeWeight(1);
        line(globalPaddingX, globalPaddingY, width - globalPaddingX, globalPaddingY);
        line(globalPaddingX, globalPaddingY, globalPaddingX, height - globalPaddingY);
        line(width - globalPaddingX, globalPaddingY, width - globalPaddingX, height - globalPaddingY);
        line(globalPaddingX, height - globalPaddingY, width - globalPaddingX, height - globalPaddingY);

}
void drawGrid(){

  float majorGridSize = 120;
  float secondaryMajorGridSize = 60;
  float minorGridSize = 30;

  // Calculate the number of grid lines based on the screen size and grid size
  int majorNumVerticalLines = min(ceil(width / majorGridSize), 1000);
  int secondaryMajornumVerticalLines = min(ceil(width / secondaryMajorGridSize), 1000);
  int minorNumVerticalLines = min(ceil(width / minorGridSize), 1000);

  int majorNumHorizontalLines = min(ceil(height / majorGridSize), 1000);
  int secondaryMajornumHorizontalLines = min(ceil(height / secondaryMajorGridSize), 1000);
  int minorNumHorizontalLines = min(ceil(height / minorGridSize), 1000);

  float majorOffsetX = ((panX-width/2) * zoom) % majorGridSize;
  float majorOffsetY = ((panY-height/2) * zoom) % majorGridSize;

  float secondaryMajorOffsetX = ((panX-width/2)* zoom) % secondaryMajorGridSize;
  float secondaryMajorOffsetY = ((panY-height/2) * zoom) % secondaryMajorGridSize;

  float minorOffsetX = ((panX-width/2) * zoom) % minorGridSize;
  float minorOffsetY = ((panY-height/2) * zoom) % minorGridSize;

// Draw the major vertical gridlines
for (int i = 0; i <= majorNumVerticalLines; i++) {
    float x = i * majorGridSize + majorOffsetX;
    fill(#3f3f3f);
    rect(x, 0, 1, height);
}

// Draw the major horizontal grid lines
for (int i = 0; i <= majorNumHorizontalLines; i++) {
    float y = i * majorGridSize + majorOffsetY;
    fill(#3f3f3f);
    rect(0, y, width, 0.25);
}

// Draw the secondary major vertical gridlines
for (int i = 0; i <= secondaryMajornumVerticalLines; i++) {
    float x = i * secondaryMajorGridSize + secondaryMajorOffsetX;
    fill(#3f3f3f);
    rect(x, 0, 0.5, height);
}

// Draw the secondary major horizontal grid lines
for (int i = 0; i <= secondaryMajornumHorizontalLines; i++) {
    float y = i * secondaryMajorGridSize + secondaryMajorOffsetY;
    fill(#3f3f3f);
    rect(0, y, width, 0.25);
}

//Draw the minor vertical gridlines
for (int i = 0; i <= minorNumVerticalLines; i++) {
    float x = i * minorGridSize + minorOffsetX;
    fill(#3f3f3f);
    rect(x, 0, 0.25, height);
}

// Draw the minor horizontal grid lines
for (int i = 0; i <= minorNumHorizontalLines; i++) {
    float y = i * minorGridSize + minorOffsetY;
    fill(#3f3f3f);
    rect(0, y, width, 0.25);
}
         
}




void drawPath(){
if(userInterface.get(activeTab + " Show Trail").getValue() == 1){
ArrayList<Body> bodies = simulation.bodies;

for(int body = 0; body < bodies.size(); body++){
    if(!(bodies.get(body) instanceof FixedBody)){
    for (int i = 1; i < pathLength; i++) { 
        xvals[i-1] = xvals[i]; 
        yvals[i-1] = yvals[i];

    } 
    xvals[pathLength-1] = bodies.get(body).position.x;
    yvals[pathLength-1] = bodies.get(body).position.y;

    // Draw a point at each coordinate
    for(int i = 0; i < pathLength; i++) {
        fill(#ffffff);
        stroke(#ffffff);
        strokeWeight(1/zoom);
        point(xvals[i], yvals[i]);
    }
    }
}
}
}
}

        