class Path  {
   ArrayList<ArrayList<PVector>> path;
   
   Path(int numberBodies) {
     for (int i = 0; i < numberBodies; i++){
       path.add(new ArrayList<PVector>());
     }
   }
   
}
