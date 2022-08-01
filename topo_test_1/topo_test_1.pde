int w = 1800;
int h = 1800;
int cols, rows;
int scale = 20;
float[][] terrain;
float flying = 0;


void setup(){
  size(600,600,P3D);
  cols = w/scale;
  rows = h/scale;
  terrain = new float[cols][rows];
  //for(int y=0; y<rows; y++){
  //  for(int x=0; x<cols;x++){
  //    terrain[x][y] =random(-20,20);
  //  }
  //}
}
  
void draw(){
  stroke(255);
  noFill();
  background(0);
  
  flying -= 0.1;
  float yOff = flying;
  for(int y=0; y< rows; y++){
    float xOff = 0;
    for(int x=0;  x<cols; x++) {
      terrain[x][y] = map(noise(xOff,yOff), 0, 1, -100, 100);
      xOff+= 0.2;
    }
    yOff += 0.2;
  }
  
  
  
  
  translate(width/2, height/2);
  rotateX(PI/3);
  translate(-w/2, -h/2);
  for(int y=0; y<rows-1; y++){
    beginShape(TRIANGLE_STRIP);
    for(int x=0; x<cols;x++){
      vertex(x*scale, y*scale, terrain[x][y]);
      vertex(x*scale, (y+1)*scale, terrain[x][y+1]);
    }
    endShape();
  }

  
}
