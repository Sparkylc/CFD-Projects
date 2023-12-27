/**
 * This class is called Vector and represents a mathematical vector.
 * It contains instance variables i, j, and k to store the components of the vector.
 * It includes a constructor to initialize a Vector object with specific values for its components,
 * as well as methods to perform vector operations
 */
class Vector {

    double i;
    double j;
    double k;


    /**
     * Constructs a new instance of the Vector class with the given components.
     * Inside the constructor, the values of i, j, and k are assigned to the corresponding instance variables.
     * This allows you to initialize a Vector object with specific values for its components.
     *
     * @param i The i-component of the vector.
     * @param j The j-component of the vector.
     * @param k The k-component of the vector.
     */
    Vector(double i, double j, double k) {
        this.i = i;
        this.j = j;
        this.k = k;
    }

    


     /**
     * Adds the current vector to another vector.
     *
     * @param b The other vector.
     * @return The resulting vector after the addition.
     */
The `add` method in the `Vector` class is used to add the current vector to another vector.

    Vector add(Vector b){
        return new Vector(this.i + b.i, this.j + b.j, this.k + b.k);
    }




}
