public void generatePoints(){
  resetArrays();  
  animateCurve();  
  plotLineVertices();
}

public void renderLines(){
      for (int row=0;row<80;row++) {
    //for (int row=0;row<80;row = row + 10) {        
      noFill();
       for (int col=0;col<500;col++) {
        stroke(lineColor);         
        int x = xRenderOffset + col;
        int x2 = xRenderOffset + (col + 1);
        if(dotMatrix[col][row] >= 0 && dotMatrix[col+1][row] >= 0){
          line(x, yRenderOffset + dotMatrix[col][row], x2, yRenderOffset + dotMatrix[col+1][row]);
        } 
      } // end col loop
    } // end row
}


public void renderCurvedLines(){
      for (int row=0;row<80;row++) {
    //for (int row=0;row<80;row = row + 10) {        
      noFill();
      boolean inShape = true;
      beginShape();      
       for (int col=0;col<500;col++) {
        stroke(lineColor);         
        int x = xRenderOffset + col;
        int x2 = xRenderOffset + (col + 1);
        if(dotMatrix[col][row] >= 0 && dotMatrix[col+1][row] >= 0){
          if(!inShape){
            beginShape();
            inShape = true;
          }
          curveVertex(x, yRenderOffset + dotMatrix[col][row]);
          //line(x, yRenderOffset + lineVertices[col][row], x2, yRenderOffset + lineVertices[col+1][row]);
        } 
        else {
          if(inShape){
            endShape();
            inShape = false;
          }
        }

      } // end col loop
      endShape();
    } // end row
}  


public void experimentalRenderLines(){
      for (int row=0;row<80;row++) {
      //int row = drawRow;
      noFill();      
       for (int col=0;col<50;col++) {                 
        //int x = xRenderOffset + col * 10 + 10;
        //int x2 = xRenderOffset + (col + 1) * 10 + 10;        
        int x = xRenderOffset + col * 10;
        int x2 = xRenderOffset + (col + 1) * 10;        

        //if(false){
        if(lineVertices[col][row] >= 0 && lineVertices[col+1][row] >= 0){
          stroke(lineColor);                
          line(x, yRenderOffset + lineVertices[col][row], x2, yRenderOffset + lineVertices[col+1][row]);
        } 
        else {
         //if(red && col < 50){
          if(col < 50){           
            int dotX = col * 10;
            int dotX2 = (col + 1) * 10;  
             while(dotX < dotX2){           
             if( dotMatrix[dotX][row] >= 0 && dotMatrix[dotX + 1][row] >= 0){
              //stroke(255,0,0); 
              line((xRenderOffset + dotX), (yRenderOffset + dotMatrix[dotX][row]), 
                  (xRenderOffset + dotX + 1), (yRenderOffset + dotMatrix[dotX+1][row])
                  );
              }
              dotX++;
            }
          }
        }
      } // end col loop
    } // end row
}

public void renderBox(){
  if(shouldDisplayBox){
    stroke(lineColor);
    line(xRenderOffset, yRenderOffset, xRenderOffset, yRenderOffset+512);
    line(xRenderOffset, yRenderOffset + 512, xRenderOffset + 500, yRenderOffset+512);  
    line(xRenderOffset + 500, yRenderOffset+512, xRenderOffset + 500, yRenderOffset);
    line(xRenderOffset + 500, yRenderOffset, xRenderOffset, yRenderOffset);
  }
}

public void renderInfo(){
  if(shouldDisplayInfo){
    fill(lineColor);
    textFont(myFont,12);
    text(filename, 75, 540);
    text("X Offset: " + offsetx, 75, 560);
    text("Y Offset: " + offsety, 75, 580);
  }
}
