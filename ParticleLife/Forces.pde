class Forces {


    Forces(){
        forceMatrix = makeRandomMatrix();
    }

    float force(float distance, float attractionFactor){

        //when the circle is a distance beta away from another circle, it will repel, anything greater will attract or repel
        final float beta = 0.3;
        if(distance < beta){
            return distance / beta - 1;
            

            //check the bounds for distance < 1 to see if maybe it needs to be maximum distance
        } else if (beta < distance && distance < 1){
            return attractionFactor*(1 - Math.abs(2 * distance - 1 - beta)/(1 - beta));
        } else {
            return 0;
        }
    }

    float[][] makeRandomMatrix(){
        float[][] matrix = new float[numberOfParticles][numberOfParticles];
        for(int i = 0; i < numberOfParticles; i++){
            for(int j = 0; j < numberOfParticles; j++){
                matrix[i][j] = (float)(Math.random()*2 - 1);
            }
        }
        return matrix;
    }
}