class ControlFrame extends PApplet {

  int w, h;
  PApplet parent;
  ControlP5 cp5;
  CallbackListener cb;

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
       
    cp5.addSlider("xspace")
       .plugTo(parent, "xspace")
       .setRange(0, 0.1)
       .setValue(0.01)
       .setPosition(20, 10)
       .setSize(100, 10);
       
    cp5.addSlider("verticalScale")
       .plugTo(parent, "verticalScale")
       .setRange(0.5, 5.0)
       .setValue(1.0)
       .setPosition(20, 30)
       .setSize(100, 10);
       
       
    cp5.addButton("exportSVG")
       .plugTo(parent, "exportSVG")
       .setValue(0)
       .setPosition(75,125)
       .setSize(50,50);       
   
    cb = new CallbackListener() {
      public void controlEvent(CallbackEvent theEvent) {
        switch(theEvent.getAction()) {
          case(ControlP5.ACTION_BROADCAST): 
            generatePoints();
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
      println("file()\t"+theDropEvent.filePath());
      loadDEM();
    }
  }

  void draw() {
    background(190);
  }
}
