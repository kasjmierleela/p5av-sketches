import ddf.minim.*;
import ddf.minim.analysis.*;

Minim minim;
AudioPlayer song;
BeatDetect beat;

PShape s;
int sz = 250; 
int hue = 0;

void setup() {
  size(500, 500);
  //size(1000, 1000);
  frameRate(10);
  colorMode(HSB, 360, 100, 100);

  s = loadShape("lines-ar2.svg");
  shapeMode(CENTER);

  randomSeed(1);

  minim = new Minim(this);
  song = minim.loadFile("white-rabbit-loop.mp3", 2048);
  song.loop();

  beat = new BeatDetect(song.bufferSize(), song.sampleRate());
  beat.setSensitivity(2);

  s.disableStyle();
  s.scale(sz/250.0); //because svg was made at 250x250, and the grid size we want is 250 (1:1)
}

void draw() {
  background(255);

  //makes backdrop with this setup
  fill(hue, 50, 100);
  noStroke();
  rect(0, 0, width, height);

  //draws svg with this setup
  noFill();
  stroke(0, 0, 100);

  beat.detect(song.mix);

  int size = sz;
  float cols = width/float(size);
  float rows = height/float(size);

  for (int j=0; j<rows; j++) {
    for (int i=0; i<cols; i++) {

      pushMatrix();
      translate(i*size + size/2.0, j*size + size/2.0);

      if (i==0 && j==0) { //kick
        if (beat.isKick()) {
          rotate(int(random(2)) * (PI/2.0));
          hue = int(random(298, 360)); //new hue on kick
        }
      }
      if (i==0 && j==1) { //snare
        if (beat.isSnare()) {
          rotate(int(random(2)) * (PI/2.0));
          //rotate(floor(random(TWO_PI)/(PI/2.0)) * (PI/2.0));
        }
      }
      if (i==1 && j==0) { //hat
        if (beat.isSnare()) {
          rotate(int(random(2)) * (PI/2.0));
        }
      }
      if (i==1 && j==1) { //kick2
        if (beat.isKick()) {
          hue = int(random(280, 320)); //new hue on kick
          rotate(int(random(2)) * (PI/2.0));
        }
      }

      shape(s, 0, 0);

      popMatrix();
    }
  }
}