/*
*  Name Satbir Singh
*  Project: Solar System
*  First Version: 2021-12-12
*/

import g4p_controls.*;
import controlP5.*;
import processing.sound.*;

// class for planets
class Planet {
  float alpha = 0;
  float beta = 0;
  
  int size;
  String colour;
  float rotSpeed;
  float revSpeed;
  int distFromSun;
  boolean hasMoon;
  int moonDist;
  float moonRevSpeed;
  int moonSize;
  
  float tmpRotSpeed;
  float tmpRevSpeed;
  float tmpMoonRevSpeed;
  
  // constructor for the Planet class
  Planet(int _size, String _colour, float _rotSpeed, float _revSpeed, int _distFromSun, 
          boolean _hasMoon, int _moonDist, float _moonRevSpeed, int _moonSize) {
    size = _size;
    colour = _colour;
    distFromSun = _distFromSun;
    hasMoon = _hasMoon;
    moonDist = _moonDist;
    moonSize = _moonSize;
    
    if (paused) {
      rotSpeed = 0;
      revSpeed = 0;
      moonRevSpeed = 0;
    } else {
      rotSpeed = _rotSpeed;
      revSpeed = _revSpeed;
      moonRevSpeed = _moonRevSpeed;
    }
    
    tmpRotSpeed = _rotSpeed;
    tmpRevSpeed = _revSpeed;
    tmpMoonRevSpeed = _moonRevSpeed;
  }
  
  /*
  *  Name: drawPlanet
  *  Prameters: none
  *  Returns: none
  *  Description: draws a planet with or without a moon
  */
  void drawPlanet() {
    pushMatrix();
  
    rotate(alpha);
    translate(distFromSun, 0);
    color c = convertColor(colour);
    fill(c);
    ellipse(0, 0, size, size);
    
    if (hasMoon) {
      // draw Moon rotating around the planet
      // pushMatrix() is called to save the transformation state before drawing moon #1. 
      pushMatrix();
      rotate(beta);
      translate(moonDist, 0);
      fill(255);
      ellipse(0, 0, moonSize, moonSize);
      popMatrix();
    }
  
    popMatrix();
    
    alpha += revSpeed;
    beta += revSpeed + moonRevSpeed;
  }
  
  /*
  *  Name: convertColor
  *  Prameters: String colour: the colour to be converted
  *  Returns: color c: the converted color 
  *  Description: converts a string colour to a color object
  */
  color convertColor(String colour) {
    // white by default
    color c = color(255);
    
    if (colour.equals("black")) {
      c = color(0);
    } else if (colour.equals("red")) {
      c = color(255, 0, 0);
    } else if (colour.equals("orange")) {
      c = color(255, 155, 0);
    } else if (colour.equals("yellow")) {
      c = color(255, 255, 0);
    } else if (colour.equals("green")) {
      c = color(0, 255, 0);
    } else if (colour.equals("blue")) {
      c = color(0, 0, 255);
    } else if (colour.equals("purple")) {
      c = color(128,0,128);
    } else if (colour.equals("brown")) {
      c = color(165,42,42);
    }
    
    return c;
  }
  
  /*
  *  Name: pause
  *  Prameters: none
  *  Returns: none
  *  Description: pauses the animation by setting various speeds to 0
  */
  void pause() {
    rotSpeed = 0;
    revSpeed = 0;
    moonRevSpeed = 0;
  }
  
  /*
  *  Name: restart
  *  Prameters: none
  *  Returns: none
  *  Description: restars animation
  */
  void restart() {
    rotSpeed = tmpRotSpeed;
    revSpeed = tmpRevSpeed;
    moonRevSpeed = tmpMoonRevSpeed;
  }
}

// global variables
final int MAX_NUM_STARS = 1000;
ArrayList<Planet> planets = new ArrayList<Planet>();
PImage blurImg;
int imgSize = 400;
int numStars = 100;
int[] randX = new int[MAX_NUM_STARS];
int[] randY = new int[MAX_NUM_STARS];
GCustomSlider earthDistSldr, earthRotSpeedSldr, earthRevSpeedSldr, moonDistSldr, moonRevSpeedSldr;
int textY1 = 420;
int inpY1 = 825;
ControlP5 cp5;
SoundFile file;
boolean paused = false;

/*
  *  Name: setup
  *  Prameters: none
  *  Returns: none
  *  Description: sets up the canvas
  */
void setup() {
  size(700, 700);
  
  file = new SoundFile(this, "sound.mp3");
  file.loop();
  
  smooth(4);
  frameRate(60);
  imageMode(CENTER);
  
  for (int i = 0; i < MAX_NUM_STARS; i++) {
    randX[i] = (int) (Math.random() * (imgSize));
    randY[i] = (int) (Math.random() * (imgSize));
  }
  
  blurImg = blurredCircle();
  
  // create Earth
  Planet earth = new Planet(15, "blue", 0, 0.01, 70, true, 20, 0.04, 7);
  planets.add(earth);
  
  PFont font = createFont("arial", 14);
  cp5 = new ControlP5(this);
  
  // text field for number of stars input
  cp5.addTextfield("numStarsInput")
    .setPosition(22, textY1+5)
      .setSize(100, 20)
        .setFont(font)
          .setLabel("");
            ;
  
  // number of stars submit button
  cp5.addButton("numStarsSub")
      .setPosition(150, textY1+5)
        .updateSize()
          .setLabel("submit");
            ;
            
  // text field for adding a planet
  cp5.addTextfield("planetInput")
    .setPosition(22, textY1+210)
      .setSize(340, 20)
        .setFont(font)
          .setLabel("");
            ;
  
  // add planet button
  cp5.addButton("addPlanet")
      .setPosition(390, textY1+210)
          .setLabel("Add Planet");
            ;
            
  // remove last planet button
  cp5.addButton("removePlanet")
      .setPosition(465, textY1+210)
          .setLabel("Remove Last Planet")
            .setSize(100, 19);
              ;
              
  // pause button
  cp5.addButton("pause")
      .setPosition(420, textY1+5)
          .setLabel("Pause")
              ;
              
  // restart button
  cp5.addButton("restart")
      .setPosition(495, textY1+5)
          .setLabel("Restart")
              ;
              
  // reset program button
  cp5.addButton("reset")
      .setPosition(420, textY1+40)
          .setLabel("reset program")
            .setSize(144, 19);
                ;
                
  // screen shot button
  cp5.addButton("screenShot")
      .setPosition(420, textY1+75)
          .setLabel("screen shot")
            .setSize(144, 19);
                ;
  
  // slider for Earth's distance from Sun
  earthDistSldr = new GCustomSlider(this, 20, 20, 260, inpY1+80, null);
  earthDistSldr.setLimits(80, 40, 170);
  
  // slider for Earth's rotation speed
  //earthRotSpeedSldr = new GCustomSlider(this, 20, 20, 260, inpY1 + 160, null);
  //earthRotSpeedSldr.setLimits(30, 0, 100);
  
  // slider for Earth's revolving speed
  earthRevSpeedSldr = new GCustomSlider(this, 20, 20, 260, inpY1 + 160, null);
  earthRevSpeedSldr.setLimits(0.01, 0.001, 0.1);
  
  // slider for moon's distance from Earth
  moonDistSldr = new GCustomSlider(this, 20, 20, 260, inpY1 + 240, null);
  moonDistSldr.setLimits(20, 15, 100);
  
  // slider for Moon's rotation speed
  moonRevSpeedSldr = new GCustomSlider(this, 20, 20, 260, inpY1 + 320, null);
  moonRevSpeedSldr.setLimits(0.04, 0.001, 0.1);
}

/*
*  Name: draw
*  Prameters: none
*  Returns: none
*  Description: draws the solar system and the gui
*/
void draw() {
  background(200);
  stroke(0);
  
  // draw black background
  fill(0);
  rect(0, 0, imgSize, imgSize);
  
  // draw stars
  fill(255);
  for (int i = 0; i < numStars; i++) {
    ellipse(randX[i], randY[i], 3, 3);
  }

  // translate everything to the center of canvas
  translate(imgSize/2, imgSize/2);
  
  // draw sun
  fill(255, 200, 50);
  image(blurImg, 0, 0);
  
  if (!paused)
    setEarth();
  
  // draw all planets in the planets arraylist
  for (int i = 0; i < planets.size(); i++) {
    planets.get(i).drawPlanet();
  }
  
  translate(-imgSize/2, -imgSize/2);
  
  // text
  fill(0);
  text("Number of Stars: ", 22, textY1);
  text("Earth's Distance from Sun: ", 22, textY1+40);
  //text("Earth's Rotation Speed: ", 22, textY1+80);
  text("Earth's Revolving Speed: ", 22, textY1+80);
  text("Moon's Distance from Earth: ", 22, textY1+120);
  text("Moon's Revolving Speed: ", 22, textY1+160);
  text("Adding a new planet: ", 22, textY1+200);
}

/*
*  Name: blurredCircle
*  Prameters: none
*  Returns: PImage pg: a blurred yellow circle representing the Sun
*  Description: makes a blurred yellow circle representing the Sun
*/
PImage blurredCircle() {
  final PGraphics pg = createGraphics(75*2, 75*2, JAVA2D);
  pg.beginDraw();

  pg.smooth(4);
  pg.fill(255, 140, 0);
  pg.noStroke();

  pg.circle(75, 75, 75);
  pg.filter(BLUR, 10);

  pg.endDraw();
  return pg.get();
}

/*
*  Name: setEarth
*  Prameters: none
*  Returns: none
*  Description: sets the Earth's variables gained from the sliders
*/
void setEarth() {
  planets.get(0).distFromSun = earthDistSldr.getValueI();
  //planets.get(0).rotSpeed = earthRotSpeedSldr.getValueF();
  planets.get(0).revSpeed = earthRevSpeedSldr.getValueF();
  planets.get(0).moonDist = moonDistSldr.getValueI();
  planets.get(0).moonRevSpeed = moonRevSpeedSldr.getValueF();
}

/*
*  Name: numStarsSub
*  Prameters: none
*  Returns: none
*  Description: num stars submit button click handler
*/
public void numStarsSub() {
  int newNumStars = numStars;
  
  try {
    newNumStars = Integer.valueOf(cp5.get(Textfield.class, "numStarsInput").getText());
  } catch (Exception e) {}
  
  if (newNumStars < 0) {
    newNumStars = 0;
  } else if (newNumStars > 1000) {
    newNumStars = 1000;
  }
  
  numStars = newNumStars;
}

/*
*  Name: addPlanet
*  Prameters: none
*  Returns: none
*  Description: Add Planet button click handler
*/
public void addPlanet() {
  int distFromSun, moonDist, size, moonSize;
  float rotSpeed, revSpeed, moonRevSpeed;
  boolean hasMoon = false;
  String colour;
  String input = cp5.get(Textfield.class, "planetInput").getText();
  String tokens[] = input.split(", ");
  
  try {
    size = Integer.parseInt(tokens[0]);
    colour = tokens[1];
    rotSpeed = Float.parseFloat(tokens[2]);
    revSpeed = Float.parseFloat(tokens[3]);
    distFromSun = Integer.parseInt(tokens[4]);
    
    if (tokens[5].equals("true"))
      hasMoon = true;
      
    moonDist = Integer.parseInt(tokens[6]);
    moonRevSpeed = Float.parseFloat(tokens[7]);
    moonSize = Integer.parseInt(tokens[8]);
  } catch (Exception e) {
    println("Error: Invalid input");
    return;
  }
  
  // creating new planets and adding them to the planets arraylist
  Planet planet = new Planet(size, colour, rotSpeed, revSpeed, distFromSun, hasMoon,
                              moonDist, moonRevSpeed, moonSize);
  planets.add(planet);
}

/*
*  Name: removePlanet
*  Prameters: none
*  Returns: none
*  Description: Remove Planet button click handler
*/
public void removePlanet() {
  if (planets.size() > 1)
    planets.remove(planets.size()-1);
}

/*
*  Name: pause
*  Prameters: none
*  Returns: none
*  Description: Pause button click handler
*/
public void pause() {
  for (var planet : planets) {
    planet.pause();
  }
  
  paused = true;
}

/*
*  Name: restart
*  Prameters: none
*  Returns: none
*  Description: Restart button click handler
*/
public void restart() {
  for (var planet : planets) {
    planet.restart();
  }
  
  paused = false;
}

/*
*  Name: reset
*  Prameters: none
*  Returns: none
*  Description: Reset button click handler
*/
public void reset() {
  int j = planets.size()-1;
  for (int i = 0; i < j; i++) {
    planets.remove(planets.size()-1);
  }
  
  restart();
  paused = false;
}

/*
*  Name: screenShot
*  Prameters: none
*  Returns: none
*  Description: screen shot button click handler
*/
public void screenShot() {
  saveFrame();
}
