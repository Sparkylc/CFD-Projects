
public static class PhysEngMath {
    public static float Clamp(float value, float min, float max) {
      if(min == max) {
        return min;
      } else if(min > max) {
        throw new IllegalArgumentException("min must be less than max");
      } else if(value < min) {
        return min;
      } else if(value > max) {
        return max;
      } else {
        return value;
      }
    }


    public static PVector Transform(PVector position, float angle) {
      float positionX = position.x;
      float positionY = position.y;
      float sin = sin(angle);
      float cos = cos(angle);

      float rotationX = positionX * cos - positionY * sin;
      float rotationY = positionX * sin + positionY * cos;

      float transformX = rotationX + position.x;
      float transformY = rotationY + position.y;

      return new PVector(transformX, transformY);


    }

    public static PVector Transform(float x, float y, float angle) {
      float positionX = x;
      float positionY = y;
      float sin = sin(angle);
      float cos = cos(angle);
    }

    public static PVector zeroTransform = Transform(0, 0, 0);
}