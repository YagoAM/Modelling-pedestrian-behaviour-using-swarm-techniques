interface vector { //<>// //<>// //<>// //<>// //<>//
  /*Funciones set*/
  void set(float in_x, float in_y);
  void set(Vector2D in);
  void setCero();

  /*Funciones set random*/
  void setRandomPosition();
  void setRandomWithMod(float mod);  //Un vector que va a tener de modulo "mod"
  void setRandomWithMaxMod(float mod);  //Un vector que va a tener de modulo entre 0 y "mod"

  /*Funciones básicas*/
  void add(Vector2D in);
  void addScaled(Vector2D in, float porcentaje, float base);
  void substract(Vector2D in);
  void multiply_by(float gain);
  void divide_by(float div);
  float getX();
  float getY();

  /*Funciones polares*/
  float getModule();
  float getAngle();
  Vector2D getUnitVector();
  void setUnitVector();
  void setDirection(Vector2D in);  //Cambiar la direccion manteniendo el modulo
  void setMod(float mag);  //Cambiar el modulo manteniendo la direccion
  Vector2D limit(float lim);  //Cambiar el modulo a "lim" si es mayor que éste

  /*Depuracion*/
  void print();
}

/*Funciones externas a la clase*/
float distSq(Vector2D uno, Vector2D dos) {
  float dx = dos.x - uno.x;
  float dy = dos.y - uno.y;
  return dx*dx + dy*dy;
}
Vector2D get_perpendicular(Vector2D in) {
  return new Vector2D(in.y, -in.x);
}

Vector2D getNormalToLine(Vector2D p1, Vector2D p2) { //Te devuelve la normal hacia la izquierda desde el punto de vista del primer punto
  float dx = p2.getX() - p1.getX();
  float dy = p2.getY() - p1.getY();
  float nx = -dy;
  float ny = dx;
  return new Vector2D(nx, ny);
}

Vector2D line_line_p(Vector2D v0, Vector2D v1, Vector2D v2, Vector2D v3) {
  Vector2D intercept = null;

  float f1 = (v1.x - v0.x);
  float g1 = (v1.y - v0.y);
  float f2 = (v3.x - v2.x);
  float g2 = (v3.y - v2.y);
  float f1g2 = f1 * g2;
  float f2g1 = f2 * g1;
  float det = f2g1 - f1g2;

  if (abs(det) > 1E-30) {
    float s = (f2*(v2.y - v0.y) - g2*(v2.x - v0.x))/ det;
    float t = (f1*(v2.y - v0.y) - g1*(v2.x - v0.x))/ det;
    if (s >= 0 && s <= 1 && t >= 0 && t <= 1)
      intercept = new Vector2D(v0.x + f1 * s, v0.y + g1 * s);
  }
  return intercept;
}

float angleBetween(Vector2D vect1, Vector2D vect2) {
  float num = dotProduct(vect1, vect2);
  float den = vect1.getModule() * vect2.getModule();
  float result = acos(num/den);
  result = degrees(result);
  return result;
}

float dist2(Vector2D uno, Vector2D dos) {
  Vector2D dist = new Vector2D();
  dist.set(uno);
  dist.substract(dos);
  return(dist.getModule());
}

Vector2D randomPosition() {
  Vector2D vect = new Vector2D();
  vect.setRandomPosition();
  return vect;
}

Vector2D randomWithMod(float mod) {
  Vector2D vect = new Vector2D();
  vect.setRandomWithMod(mod);
  return vect;
}

Vector2D randomWithMaxMod(float mod) {
  Vector2D vect = new Vector2D();
  vect.setRandomWithMaxMod(mod);
  return vect;
}

float dotProduct(Vector2D vect1, Vector2D vect2) {
  float result;
  result = vect1.x * vect2.x + vect1.y * vect2.y;
  return result;
}

Vector2D calcProjection(Vector2D vect1, Vector2D vect2){
  float escalar = dotProduct(vect1, vect2);
  float x = escalar * vect2.x;
  float y = escalar * vect2.y;
  return new Vector2D(x,y);
}

Vector2D product(Vector2D vectorIn, float floatIn) {
  Vector2D result = new Vector2D(vectorIn);
  result.multiply_by(floatIn);
  return result;
}

Vector2D substract (Vector2D vect1, Vector2D vect2) {
  Vector2D sum = new Vector2D(vect1);
  sum.substract(vect2);
  return sum;
}

/*Declaración de la clase*/
class Vector2D implements vector {
  float x;
  float y;

  /*Constructores*/
  Vector2D() {
    x=0;
    y=0;
  }
  Vector2D(float in_x, float in_y) {
    x=in_x;
    y=in_y;
  }
  Vector2D(Vector2D in) {
    x=in.x;
    y=in.y;
  }

  /*Funciones set*/
  void set(float in_x, float in_y) {
    x=in_x;
    y=in_y;
  }
  void set(Vector2D in) {
    x=in.x;
    y=in.y;
  }
  void setCero() {
    x=0;
    y=0;
  }

  /*Funciones set random*/
  void setRandomPosition() {
    x = random(width);
    y = random(height);
  }

  void setRandomWithMod(float mod) {
    float aux_x = random(-1, 1);
    float aux_y = random(-1, 1);
    Vector2D aux = new Vector2D(aux_x, aux_y);
    this.set(aux.getUnitVector());
    this.multiply_by(mod);
  }

  void setRandomWithMaxMod(float mod) {
    x = random(-1, 1)*mod;
    y = random(-1, 1)*mod;
  }

  /*Funciones básicas*/
  void add(Vector2D in) {
    x+=in.x;
    y+=in.y;
  }
  void addScaled(Vector2D in, float porcentaje, float base) {
    Vector2D v = in.getUnitVector();
    v.multiply_by(porcentaje*base);
    x += v.x;
    y += v.y;
  }
  void addLimited(Vector2D in, float maxMod) {
    float mag = sqrt(pow(this.getX() + in.getX(), 2) + pow(this.getY() + in.getY(), 2));
    if (mag > maxMod) {
      float ratio = maxMod / mag;
      Vector2D limitedVector = new Vector2D(in);
      limitedVector.multiply_by(ratio);
      this.add(limitedVector);
    } else {
      this.add(in);
    }
  }
  
  void substract(Vector2D in) {
    x-=in.x;
    y-=in.y;
  }
  void multiply_by(float gain) {
    x*=gain;
    y*=gain;
  }
  void divide_by(float div) {
    x/=div;
    y/=div;
  }
  float getX() {
    return x;
  }
  float getY() {
    return y;
  }

  /*Funciones polares*/
  float getModule() {
    return sqrt(x*x + y*y);
  }

  float getAngle() {
    return atan2(y, x);
  }
  Vector2D getUnitVector() {
    float mod = this.getModule();
    Vector2D unit = new Vector2D();
    if (mod == 0) {
      return unit;
    }
    unit.x = x/mod;
    unit.y = y/mod;
    return unit;
  }

  void setUnitVector() {
    Vector2D v = this.getUnitVector();
    this.set(v);
  }

  void setDirection(Vector2D in) {
    float mod = this.getModule();
    Vector2D unit = in.getUnitVector();
    unit.multiply_by(mod);
    this.set(unit);
  }

  void setMod(float mag) {
    Vector2D v = this.getUnitVector();
    v.multiply_by(mag);
    this.set(v);
  }

  Vector2D limit(float lim) {
    if (this.getModule() == 0) {
    } else if (this.getModule() > lim) {
      this.setMod(lim);
    }
    return this;
  }
  
  Vector2D minimum(float min){
    if (this.getModule() == 0) {
    } else if (this.getModule() < min) {
      this.setMod(min);
    }
    return this;
  }

  /*Depuracion*/
  void print() {
    println("[" + str(this.x) + "," + str(this.y) + "]");
  }
}
