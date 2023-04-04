// DEM Viewer 
// uses the SRTM .HGT binary format.
// DEM from http://srtm.csi.cgiar.org/
// might be better http://viewfinderpanoramas.org/Coverage%20map%20viewfinderpanoramas_org3.htm

import java.util.*;
import processing.svg.*; 
import drop.*;
import controlP5.*;
public int[] dotMatrixMinY;
public int[] lineVerticesMinY;
public float[][] elev;
 
int[][] elevation; // elevations in meters
float[][] felevation; // scaled to range [0,1] where 1=max
int[][] lineVertices;
int[][] dotMatrix;

int maxheight;
 
// position in the DEM
int offsetx=400;
int offsety=200;
 
boolean hatch=false;
boolean beginExportSVG = false;
boolean exporting = false;
boolean green = true;
boolean purple = true;
boolean red = true;

ControlFrame cf;
SDrop drop;

color bgColor = 255;
color lineColor = 0;

String filepath = "N22W106.hgt";
String filename = "N22W106.hgt";

// cp5 params
float verticalScale=1.0;
float xspace = 1;
float yspace = 1;
boolean shouldDisplayInfo = true;
boolean shouldDisplayBox = false;
boolean displayOffset = false;
boolean shouldRedraw = true;
boolean shouldDrawCurves = false;

int xRenderOffset = 75;
int yRenderOffset = 10;

PFont myFont;
 
public void setup() {
  size(640,640);
  background(bgColor);
  surface.setLocation(10, 250);
  lineVertices = new int[512][512];
  dotMatrix = new int[512][512];
  dotMatrixMinY = new int[512];
  lineVerticesMinY = new int[512];
  myFont = loadFont("04b03-12.vlw");
  loadDEM();
  generatePoints();
  //fx = new PostFX(this);
  cf = new ControlFrame(this, 200, 200, "Controls");
  drop = new SDrop(cf);
}
  
public void draw() {
  if(shouldRedraw || exporting){
    // putting BG on export gives us a bounding box
    background(bgColor);
  }


  if (beginExportSVG){
    println("begining export");
    exporting = true;
    // P3D needs begin Raw
    //beginRaw(SVG, "data/exports/export_"+timestamp()+".svg");
    beginRecord(SVG, "data/exports/export_"+getClass().getName()+"_"+filename+"_"+timestamp()+".svg");
  }

  if(shouldRedraw || exporting ){
    generatePoints();
    //experimentalRenderLines();
    experimentalRenderCurvedLines(); // i think this is the best one?
    //renderCurvedLines();    
    renderBox();
    renderInfo();
    shouldRedraw = false;
  }

      
  
  if (beginExportSVG && exporting){
    println("finished export");
    // P3D needs end Raw
    //endRaw();
    endRecord();
    beginExportSVG = false;
    exporting = false;
  }
 
  mousePosition();
}


public void loadDEM() {
  // some hgt files can be found here:
  // http://viewfinderpanoramas.org/dem3.html
  // http://viewfinderpanoramas.org/Coverage%20map%20viewfinderpanoramas_org3.htm
  // read srtm binary file
  elevation=new int[1201][1201];
  felevation=new float[1201][1201];
  
  byte b[] = loadBytes(filepath); 
  int ix=0;
  maxheight=0;
  for (int row=0;row<1201;row++) {
    for (int col=0;col<1201;col++) {
      // bytes are signed, from -128 to 127, converts to unsigned...
      int hi = b[ix] & 0xff;
      int lo = b[ix+1] & 0xff;
      int el=(int)((hi<<8)|lo); // big endian!
      // 32768 should be max height, but it's not for some reason
      if (el > 32700) { 
        //For voids, we just take the last value on the West
        if(col > 0){
          elevation[row][col]= elevation[row][col -1];
        } else {
          elevation[row][col]=el;
        }
      } else {
        elevation[row][col]=el;
      }
      if (el>maxheight && el<32700) maxheight=el;
      ix+=2;
    }
  }
  // work out scaled values
  for (int row=0;row<1201;row++) {
    for (int col=0;col<1201;col++) {
      felevation[col][row]=255.0*(float)elevation[col][row]/(float)maxheight;
    }
  }
  println("Loaded DEM");
}


public void resetArrays(){
  for (int row = 0; row < 512; row++) {
   dotMatrixMinY[row] = 512;
   lineVerticesMinY[row] = 512;
   for (int col = 0; col < 512; col++) {
      lineVertices[row][col] = -1;
      dotMatrix[row][col] = -1;
   }
  }
}

public void animateCurve() {
  // load part of the DEM into the elevation buffer for display
  elev=new float[52][80];
  for (int x=0;x<52;x++) {
    for (int y=0;y<80;y++) {
      int ax=offsetx+x;
      int ay=offsety-y;
      if (ax<0) ax=1200;
      if (ay<0) ay=1200;
      if (ax>1200) ax=0;
      if (ay>1200) ay=0;
      elev[x][y]=verticalScale*felevation[ay][ax];
    }
  }
}

public void exportSVG(){
  beginExportSVG = true;
}

void plotLineVertices(){
  //79 rows / 49 cols
  for (int col=0;col<51;col++) {  
    //int x=0;
    for (int row=0;row<80;row++) {
      int y = 512-(5*row);
      int x0 = col * 10;
      int y0 = y-(int)elev[col][row];
      int x1 = x0 + 10;
      int y1 = y-(int)elev[col+1][row];
      bresenhamVertices(row,col,x0,y0, x1, y1);
    }
  }
}


void bresenhamVertices(int row, int col, int x0, int y0, int x1, int y1){
  // modified bresenham algorithm
  // Based on algorithm at
  // http://free.pages.at/easyfilter/bresenham.html
 
  int dx =  abs(x1-x0), sx = x0<x1 ? 1 : -1;
  int dy = -abs(y1-y0), sy = y0<y1 ? 1 : -1;
  int err = dx+dy, e2; /* error value e_xy */
  boolean setLineVertices = false;
  
  for(;;){  /* loop */
    if (y0<dotMatrixMinY[x0]) {
      if (y0<0 || y0>511) break;
      dotMatrix[x0][row] = y0;
      dotMatrixMinY[x0]=y0;
    }
    if (!setLineVertices && y0<lineVerticesMinY[col]) {
      if (y0<0 || y0>511) break;
      lineVertices[col][row] = y0;
      lineVerticesMinY[col]=y0;
      setLineVertices = true;
    }
    
    
    if (x0==x1) break;
    e2 = 2*err;
    if (e2 >= dy) { err += dy; x0 += sx; } /* e_xy+e_x > 0 */
    if (e2 <= dx) { err += dx; y0 += sy; } /* e_xy+e_y < 0 */
  }
   
}
