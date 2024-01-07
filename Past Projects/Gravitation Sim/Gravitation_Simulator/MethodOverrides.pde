import processing.core.PApplet;
import processing.core.PVector;

    // Override the line() method to accept PVector objects
    void line(PVector start, PVector end) {
        line(start.x, start.y, end.x, end.y);
    }
