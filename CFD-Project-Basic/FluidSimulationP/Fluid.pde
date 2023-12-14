//Variables to set size of display box
final int N = 216;
final int iter = 10;

//A function to convert coordinates to an index, ie (x, y, z) to 
int IX(int x, int y, int z) {
   /* This is read as x + y*width + z*width*depth
   however as I am doing this as a cube, these values are all the same.
   If I want to have different values for width and depth, I need to 
   add new variables and ensure I change sizes as well.
   Problem you'll get to at a later time haha
   */
   
  return x + y*N + z*N*N;
}

class Fluid {
    //screen size/block size
    int size;
    //controls timestep of the 
    float dt;
    //diff controls how the dye vectors diffuse through the liquid
    float diff;
    //visc controls the thickness of the liquid
    float visc;
    
    //previous density
    float[] s;
    
    //density
    float[] density;
    
    //current velocity vectors
    float[] Vx;
    float[] Vy;
    float[] Vz;
    
    /*previous velocity vector arrays, these store previous velocities while
    new ones are being calculated*/
    float[] Vx0;
    float[] Vy0;
    float[] Vz0;
    
    
    Fluid(float dt, float diffusion, float viscosity) { 
      
    //Assigns constructor parameters
    this.size = N;
    this.dt = dt;
    this.diff = diffusion;
    this.visc = viscosity;
    
    //Initializes density array
    this.s = new float[N*N*N];
    //Initializes old density array
    this.density = new float[N*N*N];
    
    //Initializes vector array
    this.Vx = new float[N*N*N];
    this.Vy = new float[N*N*N];
    this.Vz = new float[N*N*N];
    
    //Initializes old vector array
    this.Vx0 = new float[N*N*N];
    this.Vy0 = new float[N*N*N];
    this.Vz0 = new float[N*N*N];;
    }
    //adds dye density at a specific coordinate and a specific amount
    void addDensity(int x, int y, int z, int amount) {
      int index = IX(x, y, z);
      this.density[index] += amount; 
    }
    //adds velocity at a specific coordinate by a specific amount
    void addVelocity(int x, int y, int z, float amountX, float amountY, float amountZ) {
      int index = IX(x, y, z);
      
      //adds velocity to coordinate
      this.Vx[index] += amountX; 
      this.Vy[index] += amountY;
      this.Vz[index] += amountZ;
    }
}


/*equation to control the diffusion of the dye and the velocity
Can add an int N term at the end, but as it is currently being used as a 
global variable, it does not need to be passed into the function.
Same applies to iter as this is also a global value, but this can be
later changed so that it can also be passed individually into this function
This would also need to be added to the input of lin_solve
*/

void diffuse (int b, float []x, float []x0, float diff, float dt)
{
    float a = dt * diff * (N - 2) * (N - 2);
    lin_solve(b, x, x0, a, 1 + 6 * a);
}

//linear solve function
//iter and N can also be passed as parameters, so this can be added later
void lin_solve(int b, float[] x, float[] x0, float a, float c)
{
  
   //Basically what this does is says that a new value of a particular cell
   //is based on a function of itself and all of its neighbours
    float cRecip = 1.0 / c;
    //loop for the number of iterations
    for (int m = 0; m < iter; m++) {
      //loop for z values (k)
        for (int k = 1; k < N - 1; k++) {
          //loop for y values (j)
            for (int j = 1; j < N - 1; j++) {
              //loop for x values (i)
                for (int i = 1; i < N - 1; i++) {
                    x[IX(i, j, k)] =
                        (x0[IX(i, j, k)]
                            + a*(    x[IX(i+1, j  , k  )]
                                    +x[IX(i-1, j  , k  )]
                                    +x[IX(i  , j+1, k  )]
                                    +x[IX(i  , j-1, k  )]
                                    +x[IX(i  , j  , k+1)]
                                    +x[IX(i  , j  , k-1)]
                           )) * cRecip;
                }
            }
        }
        //set_bnd(b, x, N);
    }
}

/*Tied to the fact that a fluid is incompressible and the same amount of fluid
must always be in the same place. iter and N would also need to be added in here
as a seperate paramater input
*/

void project(float[] velocX, float[] velocY, float[] velocZ, float[] p, float[] div)
{
    //for z coordinate (k)
    for (int k = 1; k < N - 1; k++) {
      //for y coordinate (j)
        for (int j = 1; j < N - 1; j++) {
          //for x coordinate (i)
            for (int i = 1; i < N - 1; i++) {
                div[IX(i, j, k)] = -0.5f*(
                         velocX[IX(i+1, j  , k  )]
                        -velocX[IX(i-1, j  , k  )]
                        +velocY[IX(i  , j+1, k  )]
                        -velocY[IX(i  , j-1, k  )]
                        +velocZ[IX(i  , j  , k+1)]
                        -velocZ[IX(i  , j  , k-1)]
                    )/N;
                p[IX(i, j, k)] = 0;
            }
        }
    }
    set_bnd(0, div); //add back N
    set_bnd(0, p); //add back N
    lin_solve(0, p, div, 1, 6); //add back iter and N
    
    for (int k = 1; k < N - 1; k++) {
        for (int j = 1; j < N - 1; j++) {
            for (int i = 1; i < N - 1; i++) {
                velocX[IX(i, j, k)] -= 0.5f * (  p[IX(i+1, j, k)]
                                                -p[IX(i-1, j, k)]) * N;
                velocY[IX(i, j, k)] -= 0.5f * (  p[IX(i, j+1, k)]
                                                -p[IX(i, j-1, k)]) * N;
                velocZ[IX(i, j, k)] -= 0.5f * (  p[IX(i, j, k+1)]
                                                -p[IX(i, j, k-1)]) * N;
            }
        }
    }
    set_bnd(1, velocX, N); //add back N later
    set_bnd(2, velocY, N); //add back N later
    set_bnd(3, velocZ, N); //add back N later
}
