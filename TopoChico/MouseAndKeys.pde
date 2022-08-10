public void keyPressed() {
  if (key=='h' || key=='H') hatch=!hatch;
  if (key == 'e') beginExportSVG = true;
  if (key == 'g') green = !green;
  if (key == 'p') purple = !purple;
  if (key == 'r') red = !red;
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
    generatePoints();
  }
}
