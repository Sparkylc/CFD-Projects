


class UserInterface {
        int individualControlsGroupBackgroundHeight = 200;
        int individualControlsGroupWidth = 320;
        int paddingX = 30;
        int paddingY = 30;
        int sliderWidth = 200;

        float centerOfMassX;
        float centerOfMassY;

        float globalPaddingX = 50;
        float globalPaddingY = 50;



        //the constructor uses the passed object to make changes, while the methods outside of the constructor use the already created object in the 
        //gravity simulation class

        UserInterface(ControlP5 userInterface){
                // initializes the tabs for the user interface
                Group individualControls = userInterface.addGroup("Controls")
                                .setPosition(screenWidth-individualControlsGroupWidth+paddingX, paddingY)
                                .setBackgroundHeight(300)
                                .setBarHeight(20)
                                .setBackgroundColor(color(255,50))
                                .setWidth(sliderWidth+paddingX*2)
                                .disableCollapse();
                              

                Slider mass = userInterface.addSlider("Mass")
                                .setPosition(10, 20)
                                .setSize(200,20)
                                .setRange(0, 2000)
                                .setValue(1000)
                                .setGroup(individualControls);
                 

                Slider radius = userInterface.addSlider("Radius")
                                .setPosition(10, 50)
                                .setSize(200,20)
                                .setRange(0, 200)
                                .setValue(100)
                                .setGroup(individualControls);
                        

                Button resetSimulation = userInterface.addButton("Reset Simulation")
                                .setPosition(10, 80)
                                .setSize(200,20)
                                .setGroup(individualControls)
                                .onClick(new CallbackListener() {
                                         void controlEvent(CallbackEvent theEvent) {
                                                simulation.resetSimulation();
                                        }
                                });
                        


                Toggle showVelocityVectors = userInterface.addToggle("Show Velocity Vectors")
                                .setPosition(10, 110)
                                .setSize(200,20)
                                .setGroup(individualControls)
                                .setValue(false)
                                ;
                       

                Toggle showAccelerationVectors = userInterface.addToggle("Show Acceleration Vectors")
                                .setPosition(10, 140)
                                .setSize(200,20)
                                .setGroup(individualControls)
                                .setValue(false)
                                ;

                            
                Toggle fixedBody = userInterface.addToggle("Fixed Body")
                                .setPosition(10, 170)
                                .setSize(200,20)
                                .setGroup(individualControls)
                                .setValue(false)
                                ;

                Slider gravityScale = userInterface.addSlider("Gravity Scale")
                                .setPosition(10, 200)
                                .setSize(200,20)
                                .setRange(1, 100)
                                .setValue(25)
                                .setGroup(individualControls)
                                .onChange(new CallbackListener() {
                                        void controlEvent(CallbackEvent theEvent) {
                                                float gravityScaleValue = userInterface.getController("Gravity Scale").getValue();
                                                gravitationalScalingCoefficient = gravityScaleValue;
                                                }
                                        });

                Toggle showCenterOfMass = userInterface.addToggle("Show Center of Mass")
                                .setPosition(10, 230)
                                .setSize(200,20)
                                .setGroup(individualControls)
                                .setValue(false)
                                ;
                Toggle lockViewToCenterOfMass = userInterface.addToggle("Lock View to Center of Mass")
                                .setPosition(10, 260)
                                .setSize(200,20)
                                .setGroup(individualControls)
                                .setValue(false)
                                ;
                              

                userInterface.getController("Show Velocity Vectors").getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER);
                userInterface.getController("Show Acceleration Vectors").getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER);
                userInterface.getController("Fixed Body").getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER);
                userInterface.getController("Reset Simulation").getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER);
                userInterface.getController("Gravity Scale").getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER);
                userInterface.getController("Show Center of Mass").getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER);

        }


        //creates the velocity vector arrow for the body
        void velocityVectorArrow(Body body){
              if(userInterface.get("Show Velocity Vectors").getValue() == 1){
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
                if (userInterface.get("Show Acceleration Vectors").getValue() == 1) {
                        // draw a line representing the acceleration vector of the body
                        stroke(0, 0, 255); // set the color of the line to blue
                        float arrowLength = 20; // length of the arrow
                        float dampeningFactor = 0.002; // dampening factor for scaling the vector

                        float arrowX = body.position.x + body.currentAccelerationVector.x * arrowLength * dampeningFactor;
                        float arrowY = body.position.y + body.currentAccelerationVector.y * arrowLength * dampeningFactor;
                        line(body.position.x, body.position.y, arrowX, arrowY);

                        // add arrow head
                        float arrowHeadSize = 5; // size of the arrow head
                        pushMatrix();
                        translate(arrowX, arrowY);
                        rotate(atan2(arrowY - body.position.y, arrowX - body.position.x));
                        triangle(-arrowHeadSize, arrowHeadSize / 2, -arrowHeadSize, -arrowHeadSize / 2, 0, 0);
                        popMatrix();
                }
        }
        
        void centerOfMass(ArrayList<Body> bodies){
                if(userInterface.get("Show Center of Mass").getValue() == 1){
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
}






                


        