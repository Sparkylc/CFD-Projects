public static class PhysicsMath {
    public static float Clamp(float value, float min, float max){
        
        if(min == max){

            return min;
        }

        if(min > max) {

            throw new IllegalArgumentException("min is greater than max");
        }


        if(value < min){

            return min;
        }

        if(value > max){
            
            return max;
        }

        return value;
    }
}