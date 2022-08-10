public void generatePoints(){
  resetArrays();  
  animateCurve();  
  plotLineVertices();
}

public void generateLines(){
      for (int row=0;row<80;row++) {
      noFill();
       for (int col=0;col<51;col++) {
        stroke(lineColor);         
        int x = xRenderOffset + col * 10;
        int x2 = xRenderOffset + (col + 1) * 10;
        
        if(lineVertices[col][row] >= 0 && lineVertices[col+1][row] >= 0){
          line(x, yRenderOffset + lineVertices[col][row], x2, yRenderOffset + lineVertices[col+1][row]);
          //lineEndpoints[x][lineVertices[col][row]][x2] = lineVertices[col+1][row];
        } 
        else if( intersects[col][row] > 0 && lineVertices[col+1][row] >= 0 ) {
         if(green){     
          //if(lineEndpoints[x][intersects[col][row]][x2] != lineVertices[col+1][row]){
            //stroke(128, 255, 0);
            line(x, yRenderOffset + intersects[col][row], x2, yRenderOffset + lineVertices[col+1][row]);
            //lineEndpoints[x][intersects[col][row]][x2] = lineVertices[col+1][row];
          //}
          
         }
        }        
        else if(lineVertices[col][row] >= 0 && intersects[col+1][row] > 0) {
          if(purple){
            //if(lineEndpoints[x][lineVertices[col][row]][x2] != intersects[col+1][row]){
              //stroke(255,0,255); 
              line(x, yRenderOffset + lineVertices[col][row], x2, yRenderOffset + intersects[col+1][row]);
              //lineEndpoints[x][lineVertices[col][row]][x2] = intersects[col+1][row];
            //}
          }
        }
        else if( intersects[col][row] > 0 && intersects[col+1][row] > 0 ) {
         if(red){     
          //if(lineEndpoints[x][intersects[col][row]][x2] != intersects[col+1][row]){
            //stroke(255, 0, 0);
            line(x, yRenderOffset + intersects[col][row], x2, yRenderOffset + intersects[col+1][row]);
            //lineEndpoints[x][intersects[col][row]][x2] = intersects[col+1][row];
          //}
         }
        }        
      } // end col loop
    } // end row
}

public void renderBox(){
  stroke(lineColor);
  line(xRenderOffset, yRenderOffset, xRenderOffset, yRenderOffset+512);
  line(xRenderOffset, yRenderOffset + 512, xRenderOffset + 500, yRenderOffset+512);  
  line(xRenderOffset + 500, yRenderOffset+512, xRenderOffset + 500, yRenderOffset);
  line(xRenderOffset + 500, yRenderOffset, xRenderOffset, yRenderOffset);
}
