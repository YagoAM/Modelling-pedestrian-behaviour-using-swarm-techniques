interface vector {
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
  void substract(Vector2D in);
  void multiply_by(float gain);
  void divide_by(float div);

  /*Funciones polares*/
  float getModule();
  float getAngle();
  Vector2D getUnitVector();
  void setDirection(Vector2D in);  //Cambiar la direccion manteniendo el modulo
  void setMod(float mag);  //Cambiar el modulo manteniendo la direccion
  void limit(float lim);  //Cambiar el modulo a "lim" si es mayor que éste

  /*Depuracion*/
  void print();
}

/*Funciones externas a la clase*/
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

Vector2D substract (Vector2D vect1, Vector2D vect2){
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
    if (mod == 0){
      unit.x = 1; //<>//
      unit.y = 0;
      return unit;
    }
    unit.x = x/mod;
    unit.y = y/mod;
    return unit;
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

  void limit(float lim) {
    if (this.getModule() > lim) {
      this.setMod(lim);
    }
  }

  /*Depuracion*/
  void print() {
    println("[" + str(this.x) + "," + str(this.y) + "]");
  }
}
