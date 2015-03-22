private final float boxLength=300;
private final float boxHeight=3;
private final float ballSize=13;
private final float depth = 200;
private final float gravityConstant=3 ;
private final float cylinderBaseSizeRadius = 18;
private final float cylinderHeight = 35;
private final int resolution = 100;
private final PVector gravity= new PVector(0, gravityConstant, 0);
private final ArrayList<PVector>cylindersMemory=new ArrayList<PVector>();
private final Mover mover=new Mover();
private float speed=0.3;
private boolean shiftPressed=false;
private float rz = 0;
private float rx = 0;
private float ry = 0;
private float oldMouseX=0;
private float oldMouseY=0;
private PShape Cylinder ;
private PVector locBeforeCollision;
void setup() 
{
  size(500, 500, P3D);
  noStroke();
  buildCylinder();
}
void draw() 
{   
  directionalLight(50, 100, 125, 0, -1, 0);
  ambientLight(102, 102, 102);
  background(200);
  translate(width/2, height/2, 0);
  if (!shiftPressed) 
  {
    pushMatrix();
    rotateY(ry);
    rotateZ(rz);
    rotateX(rx);
    fill(0, 50, 200, 200);
    box(boxLength, boxHeight, boxLength);
    mover.update();
    mover.checkEdges();
    mover.display();
    drawCylinders();
    mover.checkCollision();
    popMatrix();
  } else 
  {
    fill(0, 50, 200, 200);
    box(boxLength, boxLength, 0);
    for (PVector p : cylindersMemory)
    {
      pushMatrix();
      translate(p.x, p.y, 0);
      translate(X, Y, 0);
      shape(Cylinder);
      popMatrix();
    }
  }
}
void drawCylinders()
{
  for (PVector p : cylindersMemory)
  {
    pushMatrix();
    translate(p.x, 0, p.y);
    rotateX(PI/2);
    shape(Cylinder);
    popMatrix();
  }
}
void mousePressed() 
{
  if (!shiftPressed) 
  {
    oldMouseX=mouseX;
    oldMouseY=mouseY;
  } else 
  {
    println(mouseX>-boxLength/2);
    println( mouseX<boxLength/2);
    println( mouseY>-boxLength/2);
    println(mouseY < boxLength/2);
    float X= mouseX-250;
    float Y=mouseY-250;
    if (X>-boxLength/2 && X<boxLength/2 && Y>-boxLength/2 && Y<boxLength/2) {
      cylindersMemory.add(new PVector(X, Y, 0));
      println(cylindersMemory.size());
    }
  }
}
void mouseDragged() 
{  
  if (!shiftPressed) 
  {
    float diffZ=((mouseX-oldMouseX)/width)*speed;
    rz=rz+diffZ;
    if (rz>PI/3) 
    {
      rz=PI/3;
    } 
    else if (rz<-PI/3) 
    {
      rz=-PI/3;
    }
    float diffX=((mouseY-oldMouseY)/height)*speed;
    rx=rx-diffX;
    if (rx>PI/3) 
    {
      rx=PI/3;
    } else if (rx<-PI/3) 
    {
      rx=-PI/3;
    }
    oldMouseX=mouseX;
    oldMouseY=mouseY;
  }
}
void mouseWheel(MouseEvent event) 
{
  float e = event.getCount();
  speed=speed+e*0.5;
  if (speed<0) 
  {
    speed=0;
  }
  println("THE ACTUAL SPEED IS x"+speed);
}
void keyPressed() 
{
  if (key == CODED) 
  {
    if (keyCode == LEFT)
    {
      ry=ry-(PI/16)*speed;
    } else if (keyCode == RIGHT) 
    {
      ry=ry+(PI/16)*speed;
    } else if (keyCode == SHIFT) {
      shiftPressed=true;
    }
  }
}
void keyReleased() 
{
  if (key==CODED) 
  {
    if (keyCode == SHIFT) 
    {
      shiftPressed=false;
    }
  }
}
class Mover 
{
  PVector location;
  PVector velocity;
  Mover() 
  {
    location = new PVector(0, 0, 0);
    velocity = new PVector(0, 0, 0);
  }
  void update() 
  {
    PVector gravityForce=new PVector(sin(rz) * gravityConstant, 0, -sin(rx) * gravityConstant);
    float normalForce = 1;
    float mu = 0.01;
    float frictionMagnitude = normalForce * mu;
    PVector friction = velocity.get();
    friction.mult(-1);
    friction.normalize();
    friction.mult(frictionMagnitude);
    velocity.add(gravityForce);
    velocity.add(friction);
    location.add(velocity);
  }
  void display() 
  {
    pushMatrix();
    translate(location.x, location.y-ballSize, location.z);
    fill(0, 200, 0, 230);
    sphere(ballSize);
    popMatrix();
  }
  void checkEdges() 
  {
    if (location.x > boxLength/2)
    {
      velocity.x = velocity.x * -1;
      location.x=boxLength/2;
    }
    if (location.x<-boxLength/2)
    {
      velocity.x = velocity.x * -1;
      location.x=-boxLength/2;
    }
    if ((location.z > boxLength/2)) 
    {
      velocity.z = velocity.z * -1;
      location.z=boxLength/2;
    }
    if (location.z < -boxLength/2)
    {
      velocity.z = velocity.z * -1;
      location.z=-boxLength/2;
    }
  }
  void checkCollision()
  {
       for (PVector p : cylindersMemory)
    { 
      if (sqrt((location.x-p.x)*(location.x-p.x)+(location.z-p.y)*(location.z-p.y))<=ballSize/2+cylinderBaseSizeRadius) 
      {
        PVector locToCyl=new PVector(p.x-location.x, p.y-location.z);
        PVector velocity2D=new PVector(velocity.x, velocity.z);
        float teta=PVector.angleBetween(velocity2D, locToCyl);
        if (teta<PI/2 && teta>-PI/2) 
        {
          //veloctiy normal to the ball at the collision point
          PVector velocityN=locToCyl.get();
          velocityN.normalize();
          velocityN.mult((velocity.mag()*cos(teta)));
          velocityN.mult(-2);
          PVector velocityN3D=new PVector(velocityN.x, 0, velocityN.y);
          velocity.add(velocityN3D);
          location=locBeforeCollision.get();
          return;
        }
      }
    }
    locBeforeCollision=location.get();
  }
}
void buildCylinder()
{
  float angle;
  float[] x = new float[resolution + 1];
  float[] y = new float[resolution + 1];
  //get the x and y position on a circle for all the sides
  for (int i = 0; i < x.length; i++) {
    angle = (TWO_PI / resolution) * i;
    x[i] = sin(angle) * cylinderBaseSizeRadius;
    y[i] = cos(angle) * cylinderBaseSizeRadius;
  }
  Cylinder = createShape();
  Cylinder.beginShape(TRIANGLE);
  //draw the border of the cylinder
  for (int i = 0; i < x.length-1; i++) 
  {
    Cylinder.vertex(x[i], y[i], 0);
    Cylinder.vertex(x[1+i], y[1+i], 0);
    Cylinder.vertex(0, 0, 0);
    Cylinder.vertex(x[i], y[i], cylinderHeight);
    Cylinder.vertex(x[1+i], y[1+i], cylinderHeight);
    Cylinder.vertex(0, 0, cylinderHeight);
    Cylinder.vertex(x[i], y[i], 0);
    Cylinder.vertex(x[1+i], y[1+i], 0);
    Cylinder.vertex(x[i], y[i], cylinderHeight);
    Cylinder.vertex(x[i], y[i], cylinderHeight);
    Cylinder.vertex(x[1+i], y[1+i], cylinderHeight);
    Cylinder.vertex(x[1+i], y[1+i], 0);
  }
  Cylinder.endShape();
}
