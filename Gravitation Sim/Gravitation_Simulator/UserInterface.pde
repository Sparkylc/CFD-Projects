


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
        
        float centerOfMassX;
        float centerOfMassY;
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

         
}






                


        