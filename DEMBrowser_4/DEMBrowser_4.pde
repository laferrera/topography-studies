// DEM viewer demo
// Steven Kay, 2011
// allows you to use the mouse to pan over a digital elevation model
// model is shown using
// uses the SRTM .HGT binary format.
// DEM from http://srtm.csi.cgiar.org/
// Move the mouse to an edge or corner to pan in that direction
// demo uses a one-degree square covering the Scottish borders and Edinburgh
// you may spot vertical lines - these are "voids" in the data.
 
import processing.svg.*;
import java.util.*;
 
 
public int[] miny;
public float[][] elev;
 
int[][] elevation; // elevations in meters
float[][] felevation; // scaled to range [0,1] where 1=max
int[][] lineVertices;
int[][] intersects;
int[][][] lineEndpoints;
int maxheight;
 
// position in the DEM
int offsetx=400;
int offsety=200;
 
//tweak these according to map
float V_SCALE=1.0;
 
// optional cross-hatching
boolean hatch=false;

boolean bExportSVG = false;
boolean green = true;
boolean purple = true;
boolean red = true;

 
public void setup() {
  size(1024,512);
  lineVertices = new int[512][512];
  intersects = new int[512][512];
  lineEndpoints = new int[512][512][512];
  resetArrays();
  loadDEM();
  //noLoop();
}
 
 
public void keyPressed() {
  if (key=='h' || key=='H') hatch=!hatch;
  if (key == 'e') bExportSVG = true;
  if (key == 'g') green = !green;
  if (key == 'p') purple = !purple;
  if (key == 'r') red = !red;
}
 

public void resetArrays(){
  for (int row = 0; row < 512; row++) {
   for (int col = 0; col < 512; col++) {
      lineVertices[row][col] = -1;
      intersects[row][col] = -1;
   }
  }
  miny=new int[512];
  //lineEndpoints = new int[512][512][512];
  for (int i=0;i<512;i++) miny[i]=512;
}
 
public void animateCurve() {
  // load part of the DEM into the elevation buffer for display
  elev=new float[51][80];
  for (int x=0;x<51;x++) {
    for (int y=0;y<80;y++) {
      int ax=offsetx+x;
      int ay=offsety-y;
      if (ax<0) ax=1200;
      if (ay<0) ay=1200;
      if (ax>1200) ax=0;
      if (ay>1200) ay=0;
      elev[x][y]=V_SCALE*felevation[ay][ax];
    }
  }
}
 
public void draw() {
  background(255);
  stroke(0);
  resetArrays();
  animateCurve();
  plotLineVertices();

  if (bExportSVG){
    println("begining export");
    // P3D needs begin Raw
    //beginRaw(SVG, "data/exports/export_"+timestamp()+".svg");
    beginRecord(SVG, "data/exports/export_"+timestamp()+".svg");
  }
      

    
  //for (int row=0;row<512;row++) {
  //  beginShape();        
  //  boolean inShape = true;
  //  boolean drewLine = false;
  //  noFill();
  //  int col=0;
  //  while (col<509) {
  //    int x = col * 10;    
  //    int x2 = (col + 1) * 10;
  //    int x3 = (col + 2) * 10;                  
  //    //if(lineVertices[col][row] >= 0 && lineVertices[col+1][row] >= 0){
  //    if(lineVertices[col][row] >= 0 && lineVertices[col+1][row] >= 0 && lineVertices[col+2][row] >= 0){          
  //      if(!inShape){
  //        stroke(0);
  //        beginShape();        
  //        inShape = true;
  //      }
  //      drewLine = true;          
  //      curveVertex(x, lineVertices[col][row]);
  //      curveVertex(x2, lineVertices[col+1][row]);
  //      curveVertex(x3, lineVertices[col+2][row]);
  //      col = col + 3;
  //    } else {
  //      if(inShape){
  //        //curveVertex(x, col);
  //        //if(row > 0) curveVertex(x, lineVertices[col][row-1]);
  //        endShape();        
  //        inShape = false;
  //      }
  //      col = col + 1;
  //      drewLine = false;
  //    }
        
        
  //    if(!drewLine){
  //      if(lineVertices[col][row] >= 0 && lineVertices[col+1][row] >= 0){
  //        stroke(0);
  //        line(x, lineVertices[col][row], x2, lineVertices[col+1][row]);
  //      } 
  //      else if(intersects[col][row] > 0 && lineVertices[col+1][row] >= 0 ) {
  //       if(green){     
  //        stroke(0, 255, 0);
  //        line(x, intersects[col][row], x2, lineVertices[col+1][row]);
  //       }
  //      }
  //      else if(lineVertices[col][row] >= 0 && intersects[col+1][row] > 0) {
  //        if(purple){
  //          stroke(255,0,255);
  //          line(x, lineVertices[col][row], x2,intersects[col+1][row]);
  //        }
  //      } 
  //      else if(intersects[col][row] > 0 && intersects[col+1][row] > 0 ) {
  //       if(red){     
  //        stroke(255, 0, 0);
  //        line(x, intersects[col][row], x2, intersects[col+1][row]);
  //       }
  //      }            
  //    }
        
        
  
  //    }
  //  }
    
    
    
    
    
    
    
    

    for (int row=0;row<512;row++) {      
      noFill();
       for (int col=0;col<510;col++) {
        //int x = 512+ col * 10;
        //int x2 = 512 + (col + 1) * 10;                 
        int x = col * 10;
        int x2 = (col + 1) * 10;        
        if(lineVertices[col][row] >= 0 && lineVertices[col+1][row] >= 0){
          stroke(0);
          line(x, lineVertices[col][row], x2, lineVertices[col+1][row]);
          //lineEndpoints[x][lineVertices[col][row]][x2] = lineVertices[col+1][row];
        } 
        else if( intersects[col][row] > 0 && lineVertices[col+1][row] >= 0 ) {
         if(green){     
          //if(lineEndpoints[x][intersects[col][row]][x2] != lineVertices[col+1][row]){
            stroke(0, 255, 0);
            line(x, intersects[col][row], x2, lineVertices[col+1][row]);
            lineEndpoints[x][intersects[col][row]][x2] = lineVertices[col+1][row];
          //}
          
         }
        }        
        else if(lineVertices[col][row] >= 0 && intersects[col+1][row] > 0) {
          if(purple){
            //if(lineEndpoints[x][lineVertices[col][row]][x2] != intersects[col+1][row]){
              stroke(255,0,255);
              lineEndpoints[x][lineVertices[col][row]][x2] = intersects[col+1][row];
              line(x, lineVertices[col][row], x2,intersects[col+1][row]);
            //}
          }
        }
        else if( intersects[col][row] > 0 && intersects[col+1][row] > 0 ) {
         if(red){     
          //if(lineEndpoints[x][intersects[col][row]][x2] != intersects[col+1][row]){
            stroke(255, 0, 0);
            lineEndpoints[x][intersects[col][row]][x2] = intersects[col+1][row];
            line(x, intersects[col][row], x2, intersects[col+1][row]);
          //}
         }
        }        
      } // end col loop
    }
    


  
  if (bExportSVG){
    println("finished export");
    // P3D needs end Raw
    //endRaw();
    endRecord();
    bExportSVG = false;
  }
 
  mousePosition();
}

void mousePosition(){
    // pan according to mouse position
   if (mousePressed == true) {  
     offsetx=offsetx+((mouseX-256)/64);
     offsety=offsety+((mouseY-256)/64);
     offsetx=offsetx + 1;
     offsety=offsety + 1;
   
    // prevent going off the model edges
    if (offsetx>1201-50) offsetx=1201-50;
    if (offsetx<0) offsetx=0;
    if (offsety>1201-80) offsety=1201-80;
    if (offsety<80) offsety=80; 
  }
}

void plotLineVertices(){
  //79 rows / 49 cols
    for (int col=3;col<49;col++) {  
    //for (int row=0;row<79;row++) {
    int x=0;
    //for (int col=2;col<49;col++) {
    for (int row=0;row<79;row++) {
      int y=511-(5*row);
      //x=10*col;
      x=col;
      int tx=x+10;
      int ty=y;
      //plotLine(x,y-(int)elev[col][row],tx,ty-(int)elev[col+1][row]);
       bresenhamVertices(row,col,x,y-(int)elev[col][row],tx,ty-(int)elev[col+1][row]);
      // optional crosshatch..
      //if (hatch) plotLine(x,y-(int)elev[col][row],tx,ty-5-(int)elev[col+1][row+1]);
      x=tx;
      y=ty;
    }
  }
}


void bresenhamVertices(int row, int col, int x0, int y0, int x1, int y1){
  // modified bresenham algorithm
  // lines are drawn from frontmost to backmost, and a point is only shown IF
  // its y coordinate is closer to the top of the screen than any pixel drawn in this column.
  // This implements a very simpleform of hidden line removal.pri
  // Based on algorithm at
  // http://free.pages.at/easyfilter/bresenham.html
 
  int dx =  abs(x1-x0), sx = x0<x1 ? 1 : -1;
  int dy = -abs(y1-y0), sy = y0<y1 ? 1 : -1;
  int err = dx+dy, e2; /* error value e_xy */
  
  for(;;){  /* loop */
    
    //if(y0 > miny[x0]) intersects[col][row] = y0;
    if(y0 == miny[x0]) intersects[col][row] = y0;
    if (y0<miny[x0]) {
      if (y0<0 || y0>511) break;
      lineVertices[col][row] = y0;
      miny[x0]=y0;
    }
    if (x0==x1 && y0==y1) break;
    e2 = 2*err;
    if (e2 >= dy) { err += dy; x0 += sx; } /* e_xy+e_x > 0 */
    if (e2 <= dx) { err += dx; y0 += sy; } /* e_xy+e_y < 0 */
  }
}

String timestamp() {
  Calendar now = Calendar.getInstance();
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", now);
}

void printArray(int[][] arrayint){
  println(Arrays.deepToString(arrayint));
  println();
  println(Arrays.deepToString(arrayint)
    .replace("[[", "")
    .replace("], [", "\n")
    .replace("]]", "")
    .replace(" ", "  "));
}


public void loadDEM() {
  // read srtm binary file
  elevation=new int[1201][1201];
  felevation=new float[1201][1201];
  
  byte b[] = loadBytes("N22W106.hgt"); // sample data - scottish borders, with edinburgh near top-right corner
  //byte b[] = loadBytes("brooklyn_maybe.hgt");
  int ix=0;
  maxheight=0;
  for (int row=0;row<1201;row++) {
    for (int col=0;col<1201;col++) {
      // bytes are signed, from -128 to 127, converts to unsigned...
      int hi = b[ix] & 0xff;
      int lo = b[ix+1] & 0xff;
      int el=(int)((hi<<8)|lo); // big endian!
      //if (el==32768) {
      if (el > 32000) {
        //TODO - handle voids (missing satellite data)
        //probably average the neighbours in a second pass?
        if(col > 0){
          elevation[row][col]= elevation[row][col -1 ];
        } else {
          elevation[row][col]=el;
        }
      } else {
        elevation[row][col]=el;
      }
      if (el>maxheight && el<32000) maxheight=el;
      ix+=2;
    }
  }
  // work out scaled values
  for (int row=0;row<1201;row++) {
    for (int col=0;col<1201;col++) {
      felevation[col][row]=255.0*(float)elevation[col][row]/(float)maxheight;
    }
  }
  print ("Loaded DEM");
}


//boolean lineIntersect(float x1, float y1, float x2, float y2, float x3, float y3, float x4, float y4) {

//  // calculate the distance to intersection point
//  float uA = ((x4-x3)*(y1-y3) - (y4-y3)*(x1-x3)) / ((y4-y3)*(x2-x1) - (x4-x3)*(y2-y1));
//  float uB = ((x2-x1)*(y1-y3) - (y2-y1)*(x1-x3)) / ((y4-y3)*(x2-x1) - (x4-x3)*(y2-y1));

//  // if uA and uB are between 0-1, lines are colliding
//  if (uA >= 0 && uA <= 1 && uB >= 0 && uB <= 1) {

//    // optionally, draw a circle where the lines meet
//    float intersectionX = x1 + (uA * (x2-x1));
//    float intersectionY = y1 + (uA * (y2-y1));
//    fill(255,0,0);
//    noStroke();
//    ellipse(intersectionX,intersectionY, 20,20);

//    return true;
//  }
//  return false;
//}
