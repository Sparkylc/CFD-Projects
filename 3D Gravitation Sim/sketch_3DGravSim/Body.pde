class Body {
    PVector position;
    PVector velocity;
    PVector acceleration;
    float mass = 0;
    float radius = 0;

    Body(PVector position, PVector velocity, float mass, float radius){
        this.mass = mass;
        this.radius = radius;
        this.position = position;
        this.velocity = velocity;
    }


}