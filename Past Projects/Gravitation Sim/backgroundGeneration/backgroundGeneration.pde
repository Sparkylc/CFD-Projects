import processing.svg.*;

void setup(){
  //size(1920,1080, SVG, "background.svg");
  size(1920,1080, SVG, "background.svg");
  
}

int paddingX = 0;
int paddingY = 0;
void draw(){
  
  background(#101213);
  noStroke();
  

for (int majorVerticalGridLine = 0; majorVerticalGridLine < width-paddingX; majorVerticalGridLine += 120) {
    fill(#3f3f3f);
    rect(majorVerticalGridLine, paddingY, 1, height-2*paddingY);
} 
for (int secondaryMajorVerticalGridline = 60; secondaryMajorVerticalGridline < width - paddingX; secondaryMajorVerticalGridline += 60) {
    fill(#3f3f3f);
    rect(secondaryMajorVerticalGridline, paddingY , 0.5 , height-2*paddingY);
}
for (int minorVerticalGridLine = 30; minorVerticalGridLine < (width - paddingX) ; minorVerticalGridLine += 30) {
    fill(#3f3f3f);
    rect(minorVerticalGridLine, paddingY , 0.25 , (height - 2 * paddingY) );
}

// Horizontal grid lines
for (int majorHorizontalGridLine = 0; majorHorizontalGridLine < (height - paddingY) ; majorHorizontalGridLine += 120) {
    fill(#3f3f3f);
    rect(paddingX , majorHorizontalGridLine, (width - 2 * paddingX), 1 );
}
for (int secondaryMajorHorizontalGridline = 60; secondaryMajorHorizontalGridline < (height - paddingY) ; secondaryMajorHorizontalGridline += 60) {
    fill(#3f3f3f);
    rect(paddingX , secondaryMajorHorizontalGridline, (width - 2 * paddingX) , 0.5 );
}
for (int minorHorizontalGridLine = 0; minorHorizontalGridLine < (height - paddingY) ; minorHorizontalGridLine += 30) {
    fill(#3f3f3f);
    rect(paddingX , minorHorizontalGridLine, (width - 2 * paddingX) , 0.25 );
}
exit();

}
