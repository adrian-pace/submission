float depth = 2000;
void setup() {
  size(500, 500, P3D);
  noStroke();
}
void draw() {
  camera(width/2, height/2, depth, 250, 250, 0, 0, 1, 0);
  directionalLight(50, 100, 125, 0, -1, 0);
  ambientLight(102, 102, 102);
  background(200);
  translate(width/2, height/2, 0);
  float rz = map(mouseY, 0, height, 0, PI);
  float ry = map(mouseX, 0, width, 0, PI);
  rotateZ(rz);
  rotateY(ry);
  for (int x = -2; x <= 2; x++) {
    for (int y = -2; y <= 2; y++) {
      for (int z = -2; z <= 2; z++) {
        pushMatrix();
        translate(100 * x, 100 * y, -100 * z);
        box(50);
        popMatrix();
      }
    }
  }
}
void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      depth -= 50;
    } else if (keyCode == DOWN) {
      depth += 50;
    }
  }
}



//
//void draw() {
//  background(255, 255, 255);
//  My3DPoint eye = new My3DPoint(0, 0, -5000);
//  My3DPoint origin = new My3DPoint(0, 0, 0);
//  My3DBox input3DBox = new My3DBox(origin, 100, 150, 300);
//  //rotated around x
//  float[][] transform1 = rotateXMatrix(PI/8);
//  input3DBox = transformBox(input3DBox, transform1);
//  projectBox(eye, input3DBox).render();
//  //rotated and translated
//  float[][] transform2 = translationMatrix(200, 200, 0);
//  input3DBox = transformBox(input3DBox, transform2);
//  projectBox(eye, input3DBox).render();
//  //rotated, translated, and scaled
//  float[][] transform3 = scaleMatrix(2, 2, 2);
//  input3DBox = transformBox(input3DBox, transform3);
//  projectBox(eye, input3DBox).render();
//}

class My2DPoint {
  float x;
  float y;
  My2DPoint(float x, float y) {
    this.x = x;
    this.y = y;
  }
}

class My3DPoint {
  float x;
  float y;
  float z;
  My3DPoint(float x, float y, float z) {
    this.x = x;
    this.y = y;
    this.z = z;
  }
}

float[] homogeneous3DPoint (My3DPoint p) {
  float[] result = {
    p.x, p.y, p.z, 1
  };
  return result;
}

My2DPoint projectPoint(My3DPoint eye, My3DPoint p) {
  float val = -eye.z/(p.z-eye.z);
  return new My2DPoint((p.x-eye.x)*val, (p.y-eye.y)*val);
}

class My2DBox {
  My2DPoint[] s;
  My2DBox(My2DPoint[] s) {
    this.s = s;
  }
  void render() {
    // Complete the code! use only line(x1, y1, x2, y2) built-in function.
    line(s[0].x, s[0].y, s[1].x, s[1].y);
    line(s[0].x, s[0].y, s[4].x, s[4].y);
    line(s[0].x, s[0].y, s[3].x, s[3].y);
    line(s[2].x, s[2].y, s[1].x, s[1].y);
    line(s[5].x, s[5].y, s[1].x, s[1].y);
    line(s[5].x, s[5].y, s[6].x, s[6].y);
    line(s[5].x, s[5].y, s[4].x, s[4].y);
    line(s[7].x, s[7].y, s[4].x, s[4].y);
    line(s[7].x, s[7].y, s[6].x, s[6].y);
    line(s[7].x, s[7].y, s[3].x, s[3].y);
    line(s[2].x, s[2].y, s[3].x, s[3].y);
    line(s[2].x, s[2].y, s[6].x, s[6].y);
  }
}


class My3DBox {
  My3DPoint[] p;
  My3DBox(My3DPoint origin, float dimX, float dimY, float dimZ) {
    float x = origin.x;
    float y = origin.y;
    float z = origin.z;
    this.p = new My3DPoint[] {
      new My3DPoint(x, y+dimY, z+dimZ), 
      new My3DPoint(x, y, z+dimZ), 
      new My3DPoint(x+dimX, y, z+dimZ), 
      new My3DPoint(x+dimX, y+dimY, z+dimZ), 
      new My3DPoint(x, y+dimY, z), 
      origin, 
      new My3DPoint(x+dimX, y, z), 
      new My3DPoint(x+dimX, y+dimY, z)
    };
  }
  My3DBox(My3DPoint[] p) {
    this.p = p;
  }
}

My2DBox projectBox (My3DPoint eye, My3DBox box) {
  My2DPoint[] s= new My2DPoint[8]; 
  for (int i=0; i<8; i++) {
    s[i]=projectPoint(eye, box.p[i]);
  }
  return new My2DBox(s);
}


float[][] rotateXMatrix(float angle) {
  return(new float[][] {
    {
      1, 0, 0, 0
    }
    , 
    {
      0, cos(angle), sin(angle), 0
    }
    , 
    {
      0, -sin(angle), cos(angle), 0
    }
    , 
    {
      0, 0, 0, 1
    }
  }
  );
}
float[][] rotateYMatrix(float angle) {
  return(new float[][] {
    {
      cos(angle), 0, sin(angle), 0
    }
    , 
    {
      0, 1, 0, 0
    }
    , 
    {
      -sin(angle), 0, cos(angle), 0
    }
    , 
    {
      0, 0, 0, 1
    }
  }
  );
}
float[][] rotateZMatrix(float angle) {
  return(new float[][] {
    {
      cos(angle), -sin(angle), 0, 0
    }
    , 
    {
      sin(angle), cos(angle), 0, 0
    }
    , 
    {
      0, 0, 1, 0
    }
    , 
    {
      0, 0, 0, 1
    }
  }
  );
}
float[][] scaleMatrix(float x, float y, float z) {
  return(new float[][] {
    {
      x, 0, 0, 0
    }
    , 
    {
      0, y, 0, 0
    }
    , 
    {
      0, 0, z, 0
    }
    , 
    {
      0, 0, 0, 1
    }
  }
  );
}

float[][] translationMatrix(float x, float y, float z) {
  return(new float[][] {
    {
      1, 0, 0, x
    }
    , 
    {
      0, 1, 0, y
    }
    , 
    {
      0, 0, 1, z
    }
    , 
    {
      0, 0, 0, 1
    }
  }
  );
}

float[] matrixProduct(float[][] a, float[] b) {
  float [] p = new float[b.length];
  for (int ligne=0; ligne<a.length; ligne++) {
    for (int col=0; col<b.length; col++) {
      p[ligne]=p[ligne]+a[ligne][col]*b[col];
    }
  }
  return p;
}

My3DPoint euclidian3DPoint (float[] a) {
  My3DPoint result = new My3DPoint(a[0]/a[3], a[1]/a[3], a[2]/a[3]);
  return result;
}


My3DBox transformBox(My3DBox box, float[][] transformMatrix) {
  My3DPoint[] newPoints = new My3DPoint[8];
  for (int i=0; i<box.p.length; i++) {
    float[] homoPoint= new float[] {
      box.p[i].x, box.p[i].y, box.p[i].z, 1
    };
    float[] product=matrixProduct(transformMatrix, homoPoint);
    newPoints[i]=euclidian3DPoint(product);
  }
  return new My3DBox(newPoints);
}

