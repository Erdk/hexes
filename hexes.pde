// constants
float sqrt3over2 = 0.8660254037844386; // hardcoded sqrt(3) / 2
float size = 30; // size of hexagon side, in pixels
int hexX = 27;   // number of hexes in grid on X axis
int hexY = 25;   // number of hexes in grid on Z axis

// options
boolean showGrid = true; // with space toggle bottom grid and red dot at origin (0, 0, 0)
boolean animate = true;  // stop/pause animation

// 'variable' globals
Hex h[];        // list of hexagons
color colors[]; // color palette, check setup()
int frame = 0;  // global frame, 0-100

class Hex {
  float size;
  PVector center;
  float newHeight;
  float origHeight;
  PVector verticles[];
  
  public Hex(PVector center, float size) {
    this.center = center;
    origHeight = center.y;
    
    verticles = new PVector[6];    
    verticles[0] = new PVector( size,     0,  0);
    verticles[1] = new PVector( size / 2, 0,  sqrt3over2 * size);
    verticles[2] = new PVector(-size / 2, 0,  sqrt3over2 * size);
    verticles[3] = new PVector(-size,     0,  0);
    verticles[4] = new PVector(-size / 2, 0, -sqrt3over2 * size);
    verticles[5] = new PVector( size / 2, 0, -sqrt3over2 * size);
  }
  
  public void draw(int x, int y) {
    pushMatrix();
    translate(center.x, center.y - newHeight * float(frame) / 100f, center.z);
    noFill();
    strokeWeight(3);
    
    for (int i = 0; i < 6; i++) {
      stroke(colors[i]);
      line(verticles[i].x, 
           verticles[i].y,
           verticles[i].z, 
           verticles[(i + 1) % 6].x, 
           verticles[(i + 1) % 6].y, 
           verticles[(i + 1) % 6].z
       );
    }
    
    // smaller hex
    for (int i = 0; i < 6; i++) {
      stroke(colors[i]);
      line(verticles[i].x * 0.6, 
           verticles[i].y + 5,
           verticles[i].z * 0.6, 
           verticles[(i + 1) % 6].x * 0.6, 
           verticles[(i + 1) % 6].y + 5, 
           verticles[(i + 1) % 6].z * 0.6
       );
    }
    
    // even smaller hex
    for (int i = 0; i < 6; i++) {
      stroke(colors[i]);
      line(verticles[i].x * 0.3, 
           verticles[i].y + 10,
           verticles[i].z * 0.3, 
           verticles[(i + 1) % 6].x * 0.3, 
           verticles[(i + 1) % 6].y + 10, 
           verticles[(i + 1) % 6].z * 0.3
       );
    }
    
     // the smallest hex
    for (int i = 0; i < 6; i++) {
      stroke(colors[i]);
      line(verticles[i].x * 0.1, 
           verticles[i].y + 15,
           verticles[i].z * 0.1, 
           verticles[(i + 1) % 6].x * 0.1, 
           verticles[(i + 1) % 6].y + 15, 
           verticles[(i + 1) % 6].z * 0.1
       );
    }
    
    // trail
    stroke(colors[4]);
    line(0, 20, 0, 0, 40, 0);
    
    popMatrix();
    
    if (frame == 100) {
      center.y = center.y - newHeight;
      newHeight = 10 * noise(x, y);
    }
  }
  
  void resetY() {
    center.y = origHeight;
  }
}

void setup() {
  size(1200, 700, P3D);
  
  colors = new color[6];
  colors[0] = color(138, 229, 242); // blue   0-1
  colors[1] = color(180, 236, 100); // green  1-2
  colors[2] = color(236, 213, 76);  // yellow 2-3
  colors[3] = color(249, 135, 97);  // orange 3-4
  colors[4] = color(249, 84, 175);  // pink   4-5
  colors[5] = color(0, 0, 0);       // black  5-0
  
  h = new Hex[hexX * hexY];
  for (int i = 0; i < hexY; i++) {
    for (int j = 0; j < hexX; j++) {
      //
      //  /--\  |
      //  \--/  | <- height
      //
      float x = j * 3.0 / 2.0 * size;
      float y = -height + i * (2.0 * size);
      if (j % 2 == 1) {
        // odd are "lower"
        y += size;
      }
      System.out.println("x: " + x + " y: " + y);
      h[i * hexX + j] = new Hex(new PVector(x, height * 3 / 4 , y), size);
    }
  }
}

void drawGrid(float size) {
  stroke(255, 0, 0);
  pushMatrix();
  translate(width/2, height/2, 0);
  sphere(2);
  popMatrix();
  
  stroke(230);
  strokeWeight(2);
  pushMatrix();
  for (int i = 0; i < width / size; i++) {
    line(i * size, height/4 * 3,  height, 
         i * size, height/4 * 3, -height);
  }
  
  for (int i = int(-height / size); i < height / size; i++) {
    line(0.0,   height/4 * 3, i * size, 
         width, height/4 * 3, i * size);
  }
  popMatrix();
}

void draw() {
  if (animate) {
    frame += 1;
    if (frame > 100) {
      frame = 1;
    }
  }
  background(255);
  lights();
  
  // TODO: more advanced camera controls
  camera(mouseX, height/2, (height/2) / tan(PI/6), width/2, height/2, 0, 0, 1, 0);
  
  if (showGrid)
    drawGrid(10);
  
  for (int i = 0; i < hexX; i++) {
    for (int j = 0; j < hexY; j++) {
      Hex k = h[i * hexY + j];
      k.draw(i, j);
    }
  }
}

void keyPressed() {
  if(key == ' ') {
    showGrid = !showGrid;
  }
  
  if (key == 'r') {
    resetAnimation();
  }
  
  if (key == 'a') {
    animate = !animate;
  }
  
  if (key == 's') {
    saveFrame("hex-######.png");
  }
}

void resetAnimation() {
  for (Hex i : h) {
    i.resetY();
  }
}