/**
 * This class is called Vector and represents a mathematical vector.
 * It contains instance variables x, y, and z to store the components of the vector.
 * It includes a constructor to initialize a Vector object with specific values for its components,
 * as well as methods to perform vector operations
 */
public class Vector {

    public float x;
    public float y;
    public float z;

    /**
     * Constructs a new instance of the Vector class with the given components.
     * Inside the constructor, the values of i, j, and k are assigned to the corresponding instance variables.
     * This allows you to initialize a Vector object with specific values for its components.
     *
     * @param x The x-component of the vector.
     * @param y The y-component of the vector.
     * @param z The z-component of the vector.
     */
    Vector(float x, float y, float z) {
        this.x = x;
        this.y = y;
        this.z = z;
    }

    /**
    * Zero parameter constructor. Constructs a new instance of the Vector class with the values of i, j, k set to 0.    
    */
    Vector(){
        this.x = 0;
        this.y = 0;
        this.z = 0;
    }

     /**
     * Adds the current vector to another vector.
     *
     * @param other The other vector. If other is null, returns a new vector with the same components as the current vector. 
     * @return The resulting vector after the addition.
     */
     Vector add(Vector other){
        if(other == null){
            return new Vector(this.x, this.y, this.z);
        }
        return new Vector(this.x + other.x, this.y + other.y, this.z + other.z);
    }


    /**
     * Subtracts another vector from the current vector. Note, the order of operations is: this - other.
     *
     * @param other The other vector. If other is null, returns a new vector with the same components as the current vector. 
     * @return The resulting vector after the subtraction.
     */
    Vector subtract(Vector other){
        
        if(other == null){
            return new Vector(this.x, this.y, this.z);
        }

        return new Vector(this.x - other.x, this.y - other.y, this.z - other.z);
    }

    /**
    * Multiplies the current vector by a scalar.
    * @param scalar The scalar to multiply the current vector by.
    * @return The resulting vector after the multiplication.
     */
    Vector multiply(float scalar){
        return new Vector(this.x * scalar, this.y * scalar, this.z * scalar);
    }

    /**
    * Divides the current vector by a scalar.
    * @param scalar The scalar to divide the current vector by. If the scalar is 0, returns a zero vector.
    * @return The resulting vector after the division. 
     */
    Vector divide(float scalar){
        if(scalar == 0){
            return new Vector(0, 0, 0);
        }
        return new Vector(this.x / scalar, this.y / scalar, this.z / scalar);
    }

    /**
    * Calculates the magnitude of the current vector.
    *
    * @return The magnitude of the current vector. If the current vector is the zero vector, returns 0.
    */
    float magnitude(){
        if(this.x == 0 && this.y == 0 && this.z == 0){
            return 0;
        }
        return (float)(Math.sqrt(Math.pow(this.x, 2) + Math.pow(this.y, 2) + Math.pow(this.z, 2)));
    }

    /**
    * Calculates the square of the magnitude of the current vector.
    * @return The square of the magnitude of the current vector. If the current vector is the zero vector, returns 0.
     */
    float magnitudeSq(){

        if(this.x == 0 && this.y == 0 && this.z == 0){
            return 0;
        }
        return (float)(Math.pow(this.x, 2) + Math.pow(this.y, 2) + Math.pow(this.z, 2));
    }

    /**
    * Calculates the distance between the current vector and another vector.
    * @param other The other vector. If the other vector is null, returns Float.NaN. If the current vector and the other vector are zero vectors, returns 0.
    * @return The distance between the current vector and the other vector.
    */
    float distance(Vector other){
        if(other == null){
            return Float.NaN;
        }
        if(other.x == 0 && other.y == 0 && other.z == 0 && this.x == 0 && this.y == 0 && this.z == 0){
            return 0;
        }
        return (float)(Math.sqrt(Math.pow(other.x - this.x, 2) + Math.pow(other.y - this.y, 2) + Math.pow(other.z - this.z, 2)));
    }
    
    /**
    * Calculates the square of the distance between the current vector and another vector.
    * @param other The other vector. If the other vector is null, returns Float.NaN. If the current vector and the other vector are zero vectors, returns 0.
    * @return The square of the distance between the current vector and the other vector.
     */
    float distanceSq(Vector other){
        if(other == null){
            return Float.NaN;
        }
        if(other.x == 0 && other.y == 0 && other.z == 0 && this.x == 0 && this.y == 0 && this.z == 0){
            return 0;
        }
        return (float)(Math.pow(other.x - this.x, 2) + Math.pow(other.y - this.y, 2) + Math.pow(other.z - this.z, 2));
    }
    /**
    *Calculates the unit vector that points in the same direction as the current vector.
    * @return The unit vector that points in the same direction as the current vector. If the current vector is the zero vector, returns a new vector with the same components as the current vector.
     */
    Vector normalize(){
        if(this.x == 0 && this.y == 0 && this.z == 0){
            return new Vector(0, 0, 0);
        }
        return new Vector(this.x / this.magnitude(), this.y / this.magnitude(), this.z / this.magnitude());
    }

    /**
    * Calculates the dot product of the current vector and another vector.
    * @param other The other vector. If the other vector is null, returns Float.NaN.
    * @return The dot product of the current vector and the other vector.
     */
    float dot(Vector other){
        if(other == null){
            return Float.NaN;
        }
        return (this.x * other.x + this.y * other.y + this.z * other.z);
    }
    /**
    * Calculates the cross product of the current vector and another vector.
    * @param other The other vector. If the other vector is null, returns null.
    * @return The cross product of the current vector and the other vector.
     */
    Vector cross(Vector other){
        if(other == null){
            return null;
        }
        return new Vector(this.y * other.z - this.z * other.y, this.z * other.x - this.x * other.z, this.x * other.y - this.y * other.x);
    }

}
