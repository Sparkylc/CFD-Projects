public static class PhysicsWorld {

  public static final float AIR_DENSITY = 1.225f;
  public static final float GRAVITY_MAG = 9.81f;
  public static final PVector GRAVITY = new PVector(0, GRAVITY_MAG);
  public static final float GRAVITATIONAL_CONSTANT = 6.67408e-11f;
  public static final float DRAG_COEFFIIENT_SCALING_FACTOR = 1.0f;
  public static final float ROPE_RIGIDITY_MULTIPLIER = 50;
  public static final float ROPE_DAMPENING_MULTIPLIER = 0.5f;
  public static final float DT = 0.01f;
  public static boolean IS_SIMULATION_PAUSED = false;

  public static final String[][] shapeTypeVariables = 
  //ShapeType, Drag Coefficient
                    
                          {
                          {"circle", "0.47"},
                          {"square", "1.05"},
                          {"triangle", "1.05"},
                          {"rectangle", "1.28"},
                          {"spring", "1.28"},
                          {"line", "0.47"},
                          {"polygon", "1"}
                          };
  /*
  This list will look like this, it will contain the shape type followed
  by variables specific to that shapetype like density, moment of inertia
  drag coefficient etc
  [Shapetype1, COEFFICIENT_OF_DRAG, GRAVITY, etc.]
  [Shapetype2, COEFFICIENT_OF_DRAG, GRAVITY, etc.]
  [Shapetype3, COEFFICIENT_OF_DRAG, GRAVITY, etc.]
  etc.

  THIS WILL BE IMPLEMENTED LATER ON AND A PROPER ORDER WILL BE OUTLINED 
  AS TO WHERE EACH OF THE PIECE OF INFORMATION IS CONTAINED IN THE ARRAY
  FOR NOW, THE FIRST VALUE WILL BE THE DRAG COEFFICIENT OF THE SHAPE
  
  */



  //TODO: IMPLEMENT A LIST OF ALL NAMES OF FORCETYPES FOR REFERENCE FOR GUI ETC.
  public final String[] forceTypes = {null};


  public static float findShapeTypeVariable(String searchString, int rowIndex){
    if(
      searchString != null 
      || searchString.equals("circle") || searchString.equals("square") 
      || searchString.equals("rectangle") || searchString.equals("spring") 
      || searchString.equals("line") || searchString.equals("polygon")
      )

      {
      for(String[] row : shapeTypeVariables){
        if(row.length > 0 && row[0].equals(searchString) && rowIndex >=0 && rowIndex < row.length){
          return Float.parseFloat(row[rowIndex]);
        } else {
          System.out.println("Row length < 0: " + row.length + "Row index out of bounds: RowIndex: " + rowIndex + "Row length: " + row.length + " Returning -1");
          return -1;
        }
      }
    }
    System.out.println("Search string is null or not a valid shape type, returning -1");
    return -1;
  }

  public static float getDragCoefficient(String shapeType){
    return findShapeTypeVariable(shapeType, 1);
  }
}