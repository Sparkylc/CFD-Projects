


class UserInterface {
int individualControlsGroupBackgroundHeight = 200;
int individualControlsGroupWidth = 320;
int paddingX = 30;
int paddingY = 30;
int sliderWidth = 200;

UserInterface(ControlP5 userInterface){
    //initializes the tabs for the user interface
    Group individualControls = userInterface.addGroup("Controls")
            .setPosition(screenWidth-individualControlsGroupWidth+paddingX, paddingY)
            .setBackgroundHeight(200)
            .setBarHeight(20)
            .setBackgroundColor(color(255,50))
            .setWidth(sliderWidth+paddingX*2)
            .disableCollapse()
            ;

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
}


}
