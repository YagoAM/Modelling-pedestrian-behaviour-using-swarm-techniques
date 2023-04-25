interface boids {
  /*Funciones Set*/
  void setPos(Vector2D in);
  void setVel(Vector2D in);
  void setDirec(Vector2D in);
  void setSepar(Vector2D in);
  void setAlin(Vector2D in);
  void setCohes(Vector2D in);

  /*Funcion de calculo de la aceleracion final*/
  void calcAcc();

  /*Funciones basicas*/
  void mueve();
  void dibuja();
  float dist2(Boid other);
}

class Boid implements boids {
  /*Atributos*/
  Vector2D pos;
  Vector2D vel;
  Vector2D acc;
  Vector2D direccion;  //Aceleración que marca la direccion en la que se tiene que mover para llegar al destino.
  Vector2D separacion;  //Aceleración de la componente de separación.
  Vector2D alineamiento;  //Aceleración de la componente de alineamiento.
  Vector2D cohesion;  //Aceleración de la componente de cohesion.
  color fillColor;  //Color para la representacion del Boid, variará dependiendo de a que Flock pertenezca, para poder diferenciarlos.

  /*Atributos Static*/
  static final float size = 13;
  static final float maxVel = 2;
  static final float maxAcc = 0.6;
  static final float radioVision = 90;
  static final float dirGain = 0.5;
  static final float separGain = 1000;
  static final float alinGain = 0.1;
  static final float cohesGain = 1;

  /*Constructor*/
  Boid(Vector2D posIn, Vector2D velIn, color colorIn) {
    pos = new Vector2D(posIn);
    vel = new Vector2D(velIn);
    acc = new Vector2D();
    
    direccion = new Vector2D();
    separacion = new Vector2D();
    alineamiento = new Vector2D();
    cohesion = new Vector2D();
    
    fillColor = colorIn;
  }

  /*Métodos*/
  /*Funciones Set*/
  void setPos(Vector2D in) {
    pos = in;
  }
  void setVel(Vector2D in) {
    vel = in;
  }
  void setDirec(Vector2D in) {
    in.multiply_by(dirGain);
    direccion = in;
  }
  void setSepar(Vector2D in) {
    in.multiply_by(separGain);
    separacion = in;
  }
  void setAlin(Vector2D in) {
    in.multiply_by(alinGain);
    alineamiento = in;
  }
  void setCohes(Vector2D in) {
    in.multiply_by(cohesGain);
    cohesion = in;
  }

  /*Funcion de calculo de la aceleracion final*/
  void calcAcc() {
    acc.setCero();

    
    acc.add(separacion);
    acc.add(alineamiento);
    acc.add(cohesion);

    acc.limit(maxAcc);
    
    acc.add(direccion);
    acc.limit(maxAcc);
  }

  /*Funciones basicas*/
  void mueve() {
    calcAcc();
    vel.add(acc);
    vel.limit(maxVel);
    pos.add(vel);

    if (pos.x > width) {
      pos.x = width;
    } else if (pos.x < 0) {
      pos.x = 0;
    }
    if (pos.y > height) {
      pos.y = height;
    } else if (pos.y < 0) {
      pos.y = 0;
    }
  }

  void dibuja() {
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(vel.getAngle());
    fill(fillColor);
    ellipse(0, 0, size, size*2);
    fill(0);
    arc(0, 0, size, size, 1.0472, 5.23599, OPEN);
    noFill();
    arc(0, 0, size, size, 0, PI*2, OPEN);
    popMatrix();
  }

  float dist2(Boid other) {
    Vector2D dist = new Vector2D();
    dist.set(pos);
    dist.substract(other.pos);
    return(dist.getModule());
  }
}
