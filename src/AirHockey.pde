ball b1;
board b2;

import processing.video.*;

Capture video;

color trackColor; 
float threshold = 1;
float distThreshold = 50;

ArrayList<Blob> blobs = new ArrayList<Blob>();

void setup() {
  size(640,480);
  background(255);
  
  b1 = new ball();
  b2 = new board();
  
  //size(640, 480);
  String[] cameras = Capture.list();
  printArray(cameras);
  video = new Capture(this, 640, 480);
  video.start();
  trackColor = color(255, 0, 0);
  
  blobs.add(new Blob(0, 20));
  blobs.add(new Blob(0, height - 20));
}

void captureEvent(Capture video) {
  video.read();
}

void keyPressed() {
  if (key == 'a') {
    distThreshold+=5;
  } else if (key == 'z') {
    distThreshold-=5;
  }
  if (key == 's') {
    threshold+=5;
  } else if (key == 'x') {
    threshold-=5;
  }


  println(distThreshold);
}


void draw() {
  background(255);
  video.loadPixels();
  image(video, 0, 0);
  
  
  
  //blobs.clear();
  // The co-ordinates of the left and right hands
  // TODO: initialization
  float fx1 = blobs.get(0).minx, cnt1 = 1;
  float fx2 = blobs.get(1).minx, cnt2 = 1;

  blobs.clear();
  // Begin loop to walk through every pixel
  //println(trackColor);
  for (int x = 0; x < video.width && blobs.isEmpty(); x++ ) {
    for (int y = 0; y < video.height; y++ ) {
      int loc = x + y * video.width;
      // What is current color
      color currentColor = video.pixels[loc];
      float r1 = red(currentColor);
      float g1 = green(currentColor);
      float b1 = blue(currentColor);
      float r2 = red(trackColor);
      float g2 = green(trackColor);
      float b2 = blue(trackColor);


      float d = distSq(r1, g1, b1, r2, g2, b2); 
      if (d < threshold*threshold) {
        //println("HERE");
        //boolean found = false;
        //for (Blob b : blobs) {
        //  if (b.isNear(x, y)) {
        //    b.add(x, y);
        //    found = true;
        //    break;
        //  }
        //}
        if (y < height/2) {
          if(cnt1 == 1) { fx1 = 0; cnt1 = 0; }
          fx1  += x;
          cnt1 ++;
        }
        else {
          if(cnt2 == 1) { fx2 = 0; cnt2 = 0; }
          fx2 += x;
          cnt2 ++;
        }
      }
    }
  }

  blobs.add(new Blob(fx1/cnt1, 20));
  blobs.add(new Blob(fx2/cnt2, height-20));
  for(Blob B : blobs)  {
    B.show();
  }
  
  // DRAW of board
  
  rect(width/4,0,300,10);
  rect(width/4,height-10,300,10);
  b1.viewball();
  b2.viewboard(fx1/cnt1, fx2/cnt2);
  b1.move(fx1/cnt1, fx2/cnt2);
  //blobs.clear();
  //Blob leftHand = new Blob(fx1/cnt1, fy1/cnt1);
  //Blob rightHand = new Blob(fx2/cnt2, fy2/cnt2);
  
  //blobs.add(leftHand);
  //blobs.add(rightHand);
  //for (Blob b : blobs) {
    
  //}

  textAlign(RIGHT);
  fill(0);
  
  //text("Tracked Color: " + red(trackColor), width-10, 75);
  //text("CNT!: " + cnt1, width-10, 125);
  //text("CNT2: " + cnt2, width-10, 100);
  //text("CNT3: " + cnt3, width-10, 175);
  //text("BLOB_SIZE!: " + blobs.size(), width-10, 150);
  
  text("distance threshold: " + distThreshold, width-10, 25);
  text("color threshold: " + threshold, width-10, 50);
}


// Custom distance functions w/ no square root for optimization
float distSq(float x1, float y1, float x2, float y2) {
  float d = (x2-x1)*(x2-x1) + (y2-y1)*(y2-y1);
  return d;
}


float distSq(float x1, float y1, float z1, float x2, float y2, float z2) {
  float d = (x2-x1)*(x2-x1) + (y2-y1)*(y2-y1) +(z2-z1)*(z2-z1);
  return d;
}

void mousePressed() {
  // Save color where the mouse is clicked in trackColor variable
  int loc = mouseX + mouseY*video.width;
  trackColor = video.pixels[loc];
  
  //blobs.clear();
  //blobs.add(new Blob(mouseX, 20));
  //blobs.add(new Blob(mouseX, height - 20));
}
