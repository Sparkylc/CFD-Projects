


class UserInterface {
        int individualControlsGroupBackgroundHeight = 200;
        int individualControlsGroupWidth = 320;
        int paddingX = 30;
        int paddingY = 30;
        int sliderWidth = 200;

        //the constructor uses the passed object to make changes, while the methods outside of the constructor use the already created object in the 
        //gravity simulation class

        UserInterface(ControlP5 userInterface){
                // initializes the tabs for the user interface
                Group individualControls = userInterface.addGroup("Controls")
                                .setPosition(screenWidth-individualControlsGroupWidth+paddingX, paddingY)
                                .setBackgroundHeight(200)
                                .setBarHeight(20)
                                .setBackgroundColor(color(255,50))
                                .setWidth(sliderWidth+paddingX*2)
                                .disableCollapse();

                userInterface.addSlider("Mass")
                                .setPosition(10, 20)
                                .setSize(200,20)
                                .setRange(0, 2000)
                                .setValue(1000)
                                .setGroup(individualControls);

                userInterface.addSlider("Radius")
                                .setPosition(10, 50)
                                .setSize(200,20)
                                .setRange(0, 200)
                                .setValue(100)
                                .setGroup(individualControls);

                userInterface.addButton("Reset Simulation")
                                .setPosition(10, 80)
                                .setSize(200,20)
                                .setGroup(individualControls)
                                .onClick(new CallbackListener() {
                                         void controlEvent(CallbackEvent theEvent) {
                                                simulation.resetSimulation();
                                        }
                                });

                userInterface.addToggle("Show Velocity Vectors")
                                .setPosition(10, 110)
                                .setSize(200,20)
                                .setGroup(individualControls)
                                .setValue(false)
                                ;

                userInterface.addToggle("Show Acceleration Vectors")
                                .setPosition(10, 140)
                                .setSize(200,20)
                                .setGroup(individualControls)
                                .setValue(false)
                                ;

                userInterface.getController("Show Velocity Vectors").getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER);
                userInterface.getController("Show Acceleration Vectors").getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER);
        }

        
        //creates the velocity vector arrow for the body
        void velocityVectorArrow(Body body){
              if(userInterface.get("Show Velocity Vectors").getValue() == 1){
                // draw a line representing the velocity vector of the body
                stroke(255, 0, 0); // set the color of the line to red
                float arrowLength = 20; // length of the arrow
                float arrowAngle = PI / 4; // angle of the arrow
                float arrowX = body.position.x + body.velocity.x * arrowLength * cos(arrowAngle);
                float arrowY = body.position.y + body.velocity.y * arrowLength * sin(arrowAngle);
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
}

                


        