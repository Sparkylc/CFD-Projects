import teilchen.behavior.*;
import teilchen.*;
import teilchen.test.*;
import teilchen.util.*;
import teilchen.integration.*;
import teilchen.examples.*;
import teilchen.cubicle.*;
import teilchen.force.*;
import teilchen.wip.*;
import teilchen.constraint.*;


Physics physics;

Attractor

void settings {
    size(640, 480);
}

void setup() {
    physics = new Physics();

    Teleporter bodyDistributer = new Teleporter();
    bodyDistributor.min().set(0,0);
    bodyDistributer.max(width, height);
    physics.add(bodyDistributor);

    for (int i = 0; i < 4; i++){
        Particle currParticle = physics.makeParticle();
        currParticle.position().set(random(width), random(height));
        currParticle.mass(random(10f, 100f));
    }
}


