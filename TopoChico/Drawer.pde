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
      noFill();      
       for (int col=0;col<50;col++) {                 
        int x = xRenderOffset + col * 10;
        int x2 = xRenderOffset + (col + 1) * 10;        
        if(lineVertices[col][row] >= 0 && lineVertices[col+1][row] >= 0){
          stroke(lineColor);                
          line(x, yRenderOffset + lineVertices[col][row], x2, yRenderOffset + lineVertices[col+1][row]);
        } 
        else {
          if(col < 50){           
            int dotX = col * 10;
            int dotX2 = (col + 1) * 10;  
             while(dotX < dotX2){           
             if( dotMatrix[dotX][row] >= 0 && dotMatrix[dotX + 1][row] >= 0){
              stroke(255,0,0); 
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

public void experimentalRenderCurvedLines(){
    for (int row=0;row<80;row++) {        
      noFill();
      boolean inShape = false;
       for (int col=0;col<51;col++) {                 
        int x = xRenderOffset + col * 10;
        int x2 = xRenderOffset + (col + 1) * 10;        
        stroke(lineColor);
        // need three points to draw a curve
        if(col < 49 && lineVertices[col][row] >= 0 && lineVertices[col+1][row] >= 0 && lineVertices[col+2][row] >= 0){
          if(!inShape){
            beginShape();
            inShape = true;
            // start of curve gets two verices
            curveVertex(x, yRenderOffset + lineVertices[col][row]);
          }
          curveVertex(x, yRenderOffset + lineVertices[col][row]);
        } 
        else {
          boolean justDrewLine = false;
          //are we currently in a curve?
          if(col < 50 && inShape && lineVertices[col][row] >= 0 && lineVertices[col+1][row] >= 0){
            curveVertex(x, yRenderOffset + lineVertices[col][row]);
            justDrewLine = true;
            //endShape();
            //inShape = false;            
          } 
          else if(col < 51 && inShape){
            curveVertex(x, yRenderOffset + lineVertices[col][row]);            
            curveVertex(x, yRenderOffset + lineVertices[col][row]);
            endShape();
            inShape = false;
          } 
          //should we draw line?
          if(!justDrewLine){
            // draw a straight line if we have two points
            if(lineVertices[col][row] >= 0 && lineVertices[col+1][row] >= 0){
              if(green){
              stroke(0,255,0);
              line(x, yRenderOffset + lineVertices[col][row], x2, yRenderOffset + lineVertices[col+1][row]);
              };
            }
            //else see if we can draw from the dot matrix
            else {
              if(col < 50){           
                int dotX = col * 10;
                int dotX2 = (col + 1) * 10;
                int startXCoord = -1;
                int endXCoord = -1;
                while(dotX < dotX2){           
                  if( dotMatrix[dotX][row] >= 0 && dotMatrix[dotX + 1][row] >= 0){
                    if(startXCoord < 0 && dotMatrix[dotX][row] > 0){
                      startXCoord = dotX;
                    }
                    if(dotMatrix[dotX + 1][row] > 0){
                      endXCoord = dotX +1;
                    }
                    
                  }
                  dotX++;
                }
                if(startXCoord > 0 && endXCoord > 0){
                  if(red){
                  stroke(255,0,0); 
                  line((xRenderOffset + startXCoord), (yRenderOffset + dotMatrix[startXCoord][row]), 
                       (xRenderOffset + endXCoord), (yRenderOffset + dotMatrix[endXCoord][row])
                       );                
                  }
                  }
              }
            }
          }

        }
      } // end col loop
      endShape();
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
