import processing.svg.*;
import java.util.*;
import controlP5.*;
import peasy.*;

PeasyCam cam;
ControlP5 cp5;


int w = 1200;
int h = 1200;
int cols, rows;
int scale = 10;
int[][] elevation; // elevations in meters
float[][] terrain;
int maxheight;
float flying = 0;
boolean bExportSVG = false;

float depth = 0;
float rotate_x_denom = 3.0;
float space = 5.0;


PGraphics pg;

void setup(){
 //cam = new PeasyCam(this, 100);
 // cam.setMinimumDistance(50);
 // cam.setMaximumDistance(500);
  size(600,600,P3D);
  cols = w/scale;
  rows = h/scale;
  
 pg = createGraphics(width, height, P2D);
  
  elevation=new int[1201][1201];
  //terrain = new float[cols][rows];
  terrain = new float[1201][1201];
  
  //byte b[] = loadBytes("N22W106.hgt"); // sample data - scottish borders, with edinburgh near top-right corner
  byte b[] = loadBytes("brooklyn_maybe.hgt");
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
          elevation[row][col]= elevation[row][col -1];
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
      terrain[col][row]=255.0*(float)elevation[col][row]/(float)maxheight;
    }
  }
  
  
  println ("Loaded DEM");
  cp5 = new ControlP5(this);
  setupControls();
  
  
}
  
void draw(){
  meshDraw();
  //camera();
  gui();
  image(pg, 0, 0);
}



void meshDraw(){
  camera(mouseX*2, mouseY*2, (height/2) / tan(PI/6), // eyeX, eyeY, eyeZ 
        width/2, height/2, 0, // centerX, centerY, centerZ 
        0, 1, 0);  // upX, upY, upZ
  translate(width/2, height/2);
  rotateX(PI/rotate_x_denom);
  translate(-w/2, -h/2);
  
  if (bExportSVG)
  {
    println("begining export");
    // P3D needs begin Raw
    beginRaw(SVG, "data/exports/export_"+timestamp()+".svg");
    //beginRecord(SVG, "data/exports/export_"+timestamp()+".svg");
  }
  
  
  
  stroke(0);
  noFill();
  background(255);

  for(int y=0; y<rows-1; y++){
    beginShape(TRIANGLE_STRIP);
    for(int x=0; x<cols;x++){
      vertex(x*scale, y*scale, terrain[x][y]);
      vertex(x*scale, (y+1)*scale, terrain[x][y+1]);
    }
    endShape();
  }
   //end triangle_strip
    
    ////curvevertex
    //for(int y=0; y<h; y++){
    //  beginShape();
    //  for(int x=0; x<w-1;x++){
    //    curveVertex(x*scale, y*scale, terrain[x][y]);
    //    //curveVertex((x+1)*scale, y*scale, terrain[x][y+1]);
    //  }
    //  endShape();
    //}
    ////end curvevertex
  

  if (bExportSVG){
    println("finished export");
    
    // P3D needs end Raw
    endRaw();
    //endRecord();
    bExportSVG = false;
  }
}


String timestamp() {
  Calendar now = Calendar.getInstance();
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", now);
}

void keyPressed(){
  if (key == 'e')
  {
    bExportSVG = true;
  }
}

void setupControls(){
  println("setting up controls");
  cp5.addSlider("scale")
    .setRange(1, 20)
    .setValue(10)
    .setPosition(20, height-30)
    .setSize(100, 10)
    ;
  cp5.setAutoDraw(false);
  
  
  cp5.addSlider("space")
    .setRange(2.0, 10.0)
    .setValue(5.0)
    .setPosition(20, height-20)
    .setSize(100, 10)
    ;
  cp5.setAutoDraw(false);
  
  cp5.addSlider("rotate_x_denom")
    .setRange(1.0, 5.0)
    .setValue(3.0)
    .setPosition(20, height-10)
    .setSize(100, 10)
    ;
  cp5.setAutoDraw(false);
  
  cp5.setGraphics( pg , 0 , 0 );
  
}

void gui() {
  cp5.draw();
}
