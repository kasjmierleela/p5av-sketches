import ddf.minim.*;
import ddf.minim.analysis.*;

Minim minim;
AudioPlayer song;
BeatDetect beat;

float radius = 200, radiusRange=100;
int hueSpread = 20;
float lerpFactor = 0.0;
PVector hueRangeOuter = new PVector(100, 120);
PVector hueRangeInner = new PVector(150, 255);
PVector centre = new PVector(width/2, height/2);
PVector nPos = new PVector();

void setup() {
  //size(500, 500);
  size(1000, 1000);
  colorMode(HSB, 255, 100, 100);

  minim = new Minim(this);
  song = minim.loadFile("danielnorgren-climbthetrees-loop.mp3", 2048);
  song.loop();

  beat = new BeatDetect();
  beat.setSensitivity(10);
  //beat.detectMode(BeatDetect.SOUND_ENERGY); //default
}

void draw() {
  background(30);
  randomize();
  
  beat.detect(song.mix);

  PVector cPos = centre; 
  
  if ( beat.isOnset() ) {
    nPos.x = random(width);
    nPos.y = random(height);
    lerpFactor = 0.0;
  } 

  cPos = PVector.lerp(nPos, centre, lerpFactor);
  //note: lerp doesn't really  work smoothly, because the idea was to lerp between
  //nPos (generated at beat onset) and centre, and I couldn't figure out how
  //to lerp all the way from a start pos to an end pos with variable number of frames to do so each time. 
  //I therefore ended up keeping the lerping rather slow, so that it atleast isn't overshooting.
  lerpFactor += 0.005; 
  println(lerpFactor);

  loadPixels();
  for (int i=0; i<(width * height); i++) {

    //y*wd + x = arrLocso, 
    //so arrLoc/wd quotient gives y and remainder gives x
    int y = floor(i / width); 
    int x = i % width;

    PVector thisLoc = new PVector(x, y);
    if (cPos.dist(thisLoc) < radius) {
      pixels[i] = color(random(hueRangeInner.x, hueRangeInner.y), 
        random(10, 50), 
        random(80, 100));
    } else {
      pixels[i] = color(random(hueRangeOuter.x, hueRangeOuter.y), 
        random(10, 50), 
        random(80, 100));
    }
  }
  updatePixels();
}

void randomize(){
  if(random(1) > 0.97) {
    hueRangeOuter.x = random(255);
    hueRangeOuter.y = random(hueRangeOuter.x, hueRangeOuter.x + hueSpread);

    hueRangeInner.x = random(255);
    hueRangeInner.x = random(hueRangeInner.x, hueRangeInner.x + hueSpread);
  } 
  if(random(1) > 0.9) {
    if(random(1) > 0.5 ) {
      radius += random(radiusRange);
    } else {
      radius -= random(radiusRange);
    }
  }
}