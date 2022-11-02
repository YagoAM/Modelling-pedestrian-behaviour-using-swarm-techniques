class Vector2D {
  float x;
  float y;
  
  Vector2D(){
    this.x = 0;
    this.y = 0;
  }
  
  Vector2D(Vector2D vect){
    this.x = vect.x;
    this.y = vect.y;
  }
  
  Vector2D(float x_val, float y_val){
    this.x = x_val;
    this.y = y_val;
  }
  
  void set (float inX, float inY){
    this.x = inX;
    this.y = inY;
  }
  
  void set (Vector2D v){
    this.x = v.x;
    this.y = v.y;
  }
  
  void setRandomPosition (){
    this.x = random(width);
    this.y = random(height);
  }
  
  void setRandom_with_maxMod (float maxMod){
    this.x = random(-1, 1)*maxMod;
    this.y = random(-1, 1)*maxMod;
  }
  
  void setRandom_with_mod (float mod){
    float x = random(-1, 1);
    float y = random(-1, 1);
    Vector2D aux = new Vector2D(x,y);
    this.set(aux.getUnitVector());
    this.multiply_by(mod);
  }
  
  void add (Vector2D vector){
    this.x += vector.x;
    this.y += vector.y;
  }
  
  void substract (Vector2D vector){
    this.x -= vector.x;
    this.y -= vector.y;
  }
  
  Vector2D multiply_by (float gain){
    this.x *= gain;
    this.y *= gain;
    return this;
  }
  
  void divide_by (float div){
    this.x /= div;
    this.y /= div;
  }
  
  float getModule(){
    float mod = sqrt(x*x + y*y);
    return mod;
  }
  
  float getAngle(){
      float angle = atan2(this.y,this.x);
      return angle;
  }
  
  Vector2D getUnitVector(){
    float mod = this.getModule();
    Vector2D unit = new Vector2D();
    unit.x = this.x/mod;
    unit.y = this.y/mod;
    return(unit);
  }
  
  void setDirection(Vector2D unit){  //Change direction, maintain magnitude.
    float mod = this.getModule();
    unit.set(unit.getUnitVector());
    unit.multiply_by(mod);
    this.set(unit);
  }
  
  void setMagnitude(float mag){
    Vector2D v = new Vector2D();
    v = this.getUnitVector();
    v.multiply_by(mag);
    this.set(v);
  }
  
  void limit(float lim){
    if (this.getModule() > lim){
      this.setMagnitude(lim);
    }
  }
  
  void print(){
    println("[" + str(this.x) + "," + str(this.y) + "]");
  }
  
  void cero(){
    x = 0;
    y = 0;
  }
}

//FIN DECLARACION CLASE VECTOR2D

Vector2D add (Vector2D vect1, Vector2D vect2){
  Vector2D sum = new Vector2D(vect1);
  sum.add(vect2);
  return sum;
}

Vector2D substract (Vector2D vect1, Vector2D vect2){
  Vector2D sum = new Vector2D(vect1);
  sum.substract(vect2);
  return sum;
}

float dotProduct(Vector2D vect1, Vector2D vect2){
  float result;
  result = vect1.x * vect2.x + vect1.y * vect2.y;
  return result;
}

float angle_between(Vector2D vect1, Vector2D vect2){
  float num = dotProduct(vect1, vect2);
  float den = vect1.getModule() * vect2.getModule();
  float result = acos(num/den);
  result = degrees(result);
  return result;
}

Vector2D randomPosition(){
  Vector2D vect = new Vector2D(random(width), random(height));
  return vect;
  }
  
Vector2D random_with_maxMod(float maxMod){
  Vector2D vect = new Vector2D(random(-1, 1)*maxMod,random(-1, 1)*maxMod);
  return vect;
}

Vector2D random_with_mod(float mod){
  float x = random(-1, 1);
  float y = random(-1, 1);
  Vector2D aux = new Vector2D(x,y);
  Vector2D vect = new Vector2D(aux.getUnitVector());
  vect.multiply_by(mod);
  return vect;
}
