
import ddf.minim.*;
import ddf.minim.analysis.*;

Minim minim;
AudioPlayer song;
BeatDetect beat;

PShape s;
int[] order = {4, 3, 2, 6, 5, 1, 0, 8, 7, 10, 9}; //oder of shapes within the svg, so that I know which one I'm turning on and off
void setup() { 
  //size(500, 500);
  size(1000, 1000);
  frameRate(4);
  colorMode(HSB, 360, 100, 100);
  randomSeed(1);

  minim = new Minim(this);
  song = minim.loadFile("kashmir-bloop-ed.mp3", 2048);
  song.loop();

  beat = new BeatDetect(song.bufferSize(), song.sampleRate());
  beat.setSensitivity(100);

  stroke(0, 0, 100);

  s = loadShape("planter.svg");
  //println(s.getChild(0).getChildCount());
  s.scale(width/500);

  s.disableStyle();
}

int ind=0;
int counter=0;
int shapeHue=0, backHue=0;
void draw() {
  background(255);
  fill(backHue, 50, 100);
  rect(0, 0, width, height);
  
  
  //resetting
  for (int i=0; i<s.getChild(0).getChildCount(); i++) {
    s.getChild(0).getChild(i).setVisible(false);
  }

  beat.detect(song.mix);
  //int numBands = beat.dectectSize(); //gives the number of freq bands in use

  //setting 
  if (beat.isKick()) {
    s.getChild(0).getChild(order[0]).setVisible(true);
    s.getChild(0).getChild(order[1]).setVisible(true);
    s.getChild(0).getChild(order[2]).setVisible(true);
    shapeHue = int(random(200, 360));
  }
  if (beat.isSnare()) {
    s.getChild(0).getChild(order[3]).setVisible(true);
    s.getChild(0).getChild(order[4]).setVisible(true);
    s.getChild(0).getChild(order[5]).setVisible(true);
    s.getChild(0).getChild(order[6]).setVisible(true);
  }
  if (beat.isHat()) {
    s.getChild(0).getChild(order[7]).setVisible(true);
    s.getChild(0).getChild(order[8]).setVisible(true);
    s.getChild(0).getChild(order[9]).setVisible(true);
    s.getChild(0).getChild(order[10]).setVisible(true);
    backHue = int(random(0, 60));
  }

  //displaying
  fill(shapeHue, 50, 100);
  shape(s, 0, 0);
}