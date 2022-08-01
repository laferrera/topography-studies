import processing.svg.*;
import java.util.*;

int w = 600;
int h = 600;
int cols, rows;
int scale = 20;
float[][] terrain;
float flying = 0;
boolean bExportSVG = true;


void setup(){
  size(600,600,P3D);
  cols = w/scale;
  rows = h/scale;
  terrain = new float[cols][rows];
  for(int y=0; y<rows; y++){
    for(int x=0; x<cols;x++){
      terrain[x][y] =random(-20,20);
    }
  }
}
  
void draw(){
  translate(width/2, height/2);
  rotateX(PI/3);
  translate(-w/2, -h/2);
  
  if (bExportSVG)
  {
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
  

  if (bExportSVG)
  {
    
    // P3D needs end Raw
    endRaw();
    //endRecord();
    bExportSVG = false;
  }
  
}

String timestamp() 
{
  Calendar now = Calendar.getInstance();
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", now);
}

void keyPressed()
{
  if (key == 'e')
  {
    bExportSVG = true;
  }
}
