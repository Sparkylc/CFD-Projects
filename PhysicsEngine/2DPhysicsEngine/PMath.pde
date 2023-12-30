public class PMath {

  public static void(PVector point, float angleRad, PVector origin) {
    float x = point.x - origin.x;
    float y = point.y - origin.y;

    float cos = (float)cos(angleRad);
    float sin = (float)sin(angleRad);

    float xPrime = (x * cos) - (y * sin);
    float yPrime = (x * sin) + (y * cos);

    xPrime += origin.x;
    yPrime += origin.y;


    point.x = xPrime;
    point.y = yPrime;
  }

  //floating point comparison operator 
  public static boolean compare(float x, float y) {
    return Math.abs(x - y) <= Float.MIN_VALUE * Math.max(1.0f, Math.max(Math.abs(x), Math.abs(y)));
  }
  
  //floating point comparison operator with a vector
  public static boolean compare(PVector vec1, PVector vec2) {
     return compare(vec1.x, vec2.x) && compare(vec1.y, vec2.y);
  }
}