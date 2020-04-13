
int etat = 0;
int nEtat = 2;

ArrayList <PVector> pt = new ArrayList<PVector>();
int nm = 50;
int pCercle = 36;


void setup() {
  size(700, 700);
  nReseau(nm, width/2.5);
}


void draw() {
}


void mousePressed() {
  if (mouseButton == LEFT) {
    nReseau(nm, width/2.5);
  } else {
    nReseauMain();
  }
}


void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  etat += e;
  if (etat < 0) {
    etat = nEtat-1;
  }
  etat = etat%nEtat;
}


void nReseauMain() {
  background(255);
  pt.add(new PVector(mouseX, mouseY));

  if (pt.size() >= 3) {
    PVector po [] = new PVector[pt.size()];
    for (int m = 0; m < pt.size(); m ++) {
      po[m] = pt.get(m);
    }
    PVector trgl[][] = triangles(po);
    affichage(trgl);
  }
}


void nReseau(int npp, float rayon) {

  PVector points[];
  if (etat ==0) {
    points = new PVector[npp];
  } else if (etat == 1) {
    points = new PVector[npp+pCercle];
  } else {
    points = new PVector[npp];
  }
  for (int i = 0; i < npp; i ++) {
    float xm = random(width/2-rayon, width/2+rayon);
    float ym = random(height/2-rayon, height/2+rayon);
    while ( (xm-width/2)*(xm-width/2)+(ym-height/2)*(ym-height/2) > rayon*rayon) {
      xm = random(width/2-rayon, width/2+rayon);
      ym = random(height/2-rayon, height/2+rayon);
    }
    points[i] = new PVector(xm, ym);
  }
  if (etat == 1) {
    for (int i = npp; i < npp+pCercle; i ++) {
      points[i] = new PVector(width/2+rayon*cos((i-npp)*2*PI/pCercle), height/2+rayon*sin((i-npp)*2*PI/pCercle));
    }
  }
  background(255);
  stroke(0);

  for (int i = 0; i < npp; i ++) {
    point(points[i].x, points[i].y);
  }

  PVector trgl[][] = triangles(points);
  affichage(trgl);
}


void affichage(PVector trgl[][]) {
  for (int i = 0; i < trgl.length; i ++) {
    if (etat == 0) {
      fill(color(random(0, 255), random(0, 255), random(0, 255)));
    } else if (etat == 1) {
      noFill();
      stroke(0);
      strokeWeight(3);
    }
    triangle(trgl[i][0].x, trgl[i][0].y, trgl[i][1].x, trgl[i][1].y, trgl[i][2].x, trgl[i][2].y);
  }
}


PVector[][] triangles (PVector pts[]) {
  int np = pts.length;
  ArrayList <PVector[]> ts = new ArrayList<PVector[]>();
  for (int i = 0; i < np-2; i ++) {
    for (int j = i+1; j < np-1; j ++) {
      for (int k = j+1; k < np; k ++) {
        PVector result[] = TC(pts[i], pts[j], pts[k]);
        boolean dedans = false;

        for (int l = 0; l < np; l ++) {
          if (l != i && l != j && l != k ) {
            if ( (pts[l].x-result[1].x)*(pts[l].x-result[1].x) + (pts[l].y-result[1].y)*(pts[l].y-result[1].y) < result[0].x) {
              dedans = true;
            }
          }
        }

        if (dedans == false) {
          PVector g[] = {pts[i], pts[j], pts[k]};
          ts.add(g);
        }
      }
    }
  }
  PVector[][]result = new PVector[ts.size()][3];
  for (int i = 0; i < ts.size(); i ++) {
    result[i] = ts.get(i);
  }
  return result;
}


PVector[] TC (PVector p1, PVector p2, PVector p3) {
  PVector centre  = new PVector(0, 0);

  float a = p1.x-p3.x;
  float b = p1.y-p3.y;
  float c = (p3.x-p1.x)*(p1.x+p3.x)/2 + (p3.y-p1.y)*(p1.y+p3.y)/2;

  float ap = p1.x-p2.x;
  float bp = p1.y-p2.y;
  float cp = (p2.x-p1.x)*(p1.x+p2.x)/2 + (p2.y-p1.y)*(p1.y+p2.y)/2;

  float xC= 0, yC = 0;
  if (a == 0) {
    xC = (c*bp-b*cp)/(b*ap);
    yC = -c/b;
  } else {
    yC = (ap*c-a*cp)/(a*bp-ap*b);
    xC = -(b*yC+c)/a;
  }

  centre.x = xC;
  centre.y = yC;


  float dist = (p1.x-centre.x)*(p1.x-centre.x)+(p1.y-centre.y)*(p1.y-centre.y);
  PVector d = new PVector(dist, dist);
  PVector result[] = {d, centre};
  return result;
}
