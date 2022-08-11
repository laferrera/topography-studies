class ControlFrame extends PApplet {

  int w, h;
  PApplet parent;
  ControlP5 cp5;
  CallbackListener cb;
  Textlabel filenameLabel;


  public ControlFrame(PApplet _parent, int _w, int _h, String _name) {
    super();   
    parent = _parent;
    w=_w;
    h=_h;
    PApplet.runSketch(new String[]{this.getClass().getName()}, this);
  }

  public void settings() {
    size(w, h);
  }

  public void setup() {
    surface.setLocation(10, 10);
    cp5 = new ControlP5(this);

    filenameLabel = cp5.addTextlabel("label")
                    .setText(filename)
                    .setPosition(20, 10)
                    .setColorValue(0xffffff00)
                    ;
       
    cp5.addSlider("xspace")
       .plugTo(parent, "xspace")
       .setRange(0, 0.1)
       .setValue(0.01)
       .setPosition(20, 30)
       .setSize(100, 10)
       ;
       
    cp5.addSlider("verticalScale")
       .plugTo(parent, "verticalScale")
       .setRange(0.5, 2.0)
       .setValue(1.0)
       .setPosition(20, 50)
       .setSize(100, 10)
       ;
       
    cp5.addToggle("Box?")
       .plugTo(parent, "shouldDisplayBox")
       .setPosition(20, 70)
       .setSize(100, 10)
       .setValue(true)
       .setMode(ControlP5.SWITCH)
     ;
     
     // cp5.addToggle("Curves?")
     //  .plugTo(parent, "shouldDrawCurves")
     //  .setPosition(20, 90)
     //  .setSize(100, 10)
     //  .setValue(false)
     //  .setMode(ControlP5.SWITCH)
     //;
       
    cp5.addButton("exportSVG")
       .plugTo(parent, "exportSVG")
       .setPosition(50,125)
       .setSize(100,10)
       ;
       
   
    cb = new CallbackListener() {
      public void controlEvent(CallbackEvent theEvent) {
        switch(theEvent.getAction()) {
          case(ControlP5.ACTION_BROADCAST): 
            shouldRedraw = true;
            break;
        }
      }
    };
    
    cp5.addCallback(cb);
       
  }

  void gui() {
    cp5.draw();
  }
  
  void dropEvent(DropEvent theDropEvent) {
    // docs
    // https://transfluxus.github.io/drop/
    println("dropTargetDropEvent()\t"+theDropEvent.dropTargetDropEvent());
    if(theDropEvent.isFile()){
      filepath = theDropEvent.filePath();
      println("loading file:\t"+theDropEvent.filePath());
      
      loadDEM();
      shouldRedraw = true;
      String[] fileList = split(filepath,"/");
      filename = fileList[fileList.length - 1];
      filenameLabel.setText(filename);
    }
  }

  void draw() {
    background(190);
  }
}
