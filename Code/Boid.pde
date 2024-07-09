interface boids { //<>//
  /*Funciones Set*/
  void setPos(Vector2D in);
  void setVel(Vector2D in);
  void setDirec(Vector2D in);
  //void setSepar(Vector2D in);
  //void setAlin(Vector2D in);
  //void setCohes(Vector2D in);
  void setFlocking(Vector2D in);
  void setSeparMuro(Vector2D in);
  void setBoidSepar(Vector2D in);

  /*Funcion de calculo de la aceleracion final*/
  void calcAcc();

  /*Funciones basicas*/
  void mueve();
  void dibuja();
  float dist2(Boid other);
}

class Boid implements boids {
  /*Atributos*/
  Vector2D heading, lateral;
  Vector2D pos;
  Vector2D futurePos;
  Vector2D prevPos;
  Vector2D vel;
  Vector2D acc;
  Vector2D direccion;  //Aceleración que marca la direccion en la que se tiene que mover para llegar al destino.
  //Vector2D separacion;  //Aceleración de la componente de separación.
  //Vector2D alineamiento;  //Aceleración de la componente de alineamiento.
  //Vector2D cohesion;  //Aceleración de la componente de cohesion.
  Vector2D flocking;  //Aceleración de la componente del flocking.
  Vector2D separacionMuro;  //Aceleración de la componente de separación del muro.
  Vector2D separacionBoid;
  Vector2D separacionObstacle;
  color fillColor;  //Color para la representacion del Boid, variará dependiendo de a que Flock pertenezca, para poder diferenciarlos.
  Casilla casillaFLock;

  /*Atributos Static*/
  static final float size = 13;
  static final float MAX_VEL = 1.7;
  static final float MAX_ACC = 0.17;
  static final float FUTURE_FRAMES_PROJECTION = 5;
  static final float VISION_RADIO = 90;
  static final float OTHER_FLOCK_VISION_RADIO = 100;
  static final float DIRECTION_GAIN = 0.1;
  static final float FLOCKING_GAIN = 0.7;
  static final float WALL_SEPARATION_GAIN = 0.2;
  static final float BOID_SEPARATION_GAIN = 1;
  static final float OBSTACLE_SEPARATION_GAIN = 1;
  //float percentDirection = 0.175;
  //float percentFlocking = 0.125;
  //float percetnWallSeparation = 0.5;
  //float percetnBoidSeparation = 0.2;

  /*Constructor*/
  Boid(Vector2D posIn, Vector2D velIn, color colorIn) {
    pos = new Vector2D(posIn);
    futurePos = new Vector2D(posIn);
    prevPos = new Vector2D(posIn);
    vel = new Vector2D(velIn);
    acc = new Vector2D();
    heading = vel.getUnitVector();
    lateral = get_perpendicular(heading);

    direccion = new Vector2D();
    //separacion = new Vector2D();
    //alineamiento = new Vector2D();
    //cohesion = new Vector2D();
    flocking = new Vector2D();
    separacionMuro = new Vector2D();
    separacionBoid = new Vector2D();
    separacionObstacle = new Vector2D();
    casillaFLock = new Casilla();

    fillColor = colorIn;
  }

  /*Métodos*/
  /*Funciones Set*/
  void setPos(Vector2D in) {
    Vector2D aux = new Vector2D(in);
    pos = aux;
  }
  void setVel(Vector2D in) {
    Vector2D aux = new Vector2D(in);
    vel = aux;
  }
  void setDirec(Vector2D in) {
    Vector2D aux = new Vector2D(in);
    aux.multiply_by(DIRECTION_GAIN);
    direccion = aux;
  }
  //void setSepar(Vector2D in) {
  //  Vector2D aux = new Vector2D(in);
  //  aux.multiply_by(SEPARATION_GAIN);
  //  separacion = aux;
  //}
  //void setAlin(Vector2D in) {
  //  Vector2D aux = new Vector2D(in);
  //  aux.multiply_by(ALIGNMENT_GAIN);
  //  alineamiento = aux;
  //}
  //void setCohes(Vector2D in) {
  //  Vector2D aux = new Vector2D(in);
  //  aux.multiply_by(COHESION_GAIN);
  //  cohesion = aux;
  //}
  void setFlocking(Vector2D in) {
    Vector2D aux = new Vector2D(in);
    aux.multiply_by(FLOCKING_GAIN);
    flocking = aux;
  }
  void setSeparMuro(Vector2D in) {
    Vector2D aux = new Vector2D(in);
    aux.multiply_by(WALL_SEPARATION_GAIN);
    separacionMuro = aux;
  }
  void setBoidSepar(Vector2D in){
    Vector2D aux = new Vector2D(in);
    aux.multiply_by(BOID_SEPARATION_GAIN);
    separacionBoid = aux;
  }
  void setObstacleSepar(Vector2D in){
    Vector2D aux = new Vector2D(in);
    aux.multiply_by(OBSTACLE_SEPARATION_GAIN);
    separacionObstacle = aux;
  }

  /*Funcion de calculo de la aceleracion final*/
  void calcAcc() {
    acc.setCero();
        //Metodo de suma de aceleraciones por porcentaje de la aceleracion máxima
    //percentDirection = 0.6;
    //percentFlocking = 0.4;
    //percetnWallSeparation = 0;
    //if (separacionMuro == null || (separacionMuro.x!=0 && separacionMuro.y!=0)) {
    //  percentDirection = 0.15;
    //  percentFlocking = 0.25;
    //  percetnWallSeparation = 0.6;
    //}
    //acc.addScaled(flocking, percentFlocking, MAX_ACC);
    //acc.addScaled(direccion, percentDirection, MAX_ACC);
    //acc.addScaled(separacionMuro, percetnWallSeparation, MAX_ACC);
    //acc.addScaled(separacionBoid, percetnBoidSeparation, MAX_ACC);
    
    
        //Metodo de suma de aceleraciones por suma simple y truncacion por aceleracion maxima
    acc.add(flocking);
    acc.add(direccion);
    acc.add(separacionMuro);
    acc.add(separacionBoid);
    acc.add(separacionObstacle);
    
    if (separacionBoid == null || (separacionBoid.x!=0 && separacionBoid.y!=0)){
      println("Hola");
    }
    
        //Metodo suma prioritaria hasta completar MAX_ACC
    //float modulo_acc;
    //acc.addLimited(separacionMuro, MAX_ACC);
    //acc.addLimited(separacionBoid, MAX_ACC);
    //acc.addLimited(flocking, MAX_ACC);
    //acc.addLimited(direccion, MAX_ACC); //<>// //<>// //<>// //<>//
    
    
    acc.limit(MAX_ACC);
  }

  /*Funciones basicas*/
  void mueve() {
    calcAcc();
    vel.add(acc);
    vel.limit(MAX_VEL);
    prevPos.set(pos);
    pos.add(vel);
    futurePos.set(pos);
    futurePos.add(product(vel,FUTURE_FRAMES_PROJECTION));
    heading = vel.getUnitVector();
    lateral = get_perpendicular(heading);

    if (pos.x >= width) {
      pos.x = width;
    } else if (pos.x <= 0) {
      pos.x = 0;
    }
    if (pos.y >= height) {
      pos.y = height;
    } else if (pos.y <= 0) {
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
  
  float dist2future(Boid other) {
    Vector2D dist = new Vector2D();
    dist.set(futurePos);
    dist.substract(other.futurePos);
    return(dist.getModule());
  }

  public boolean equals(Object obj) {
    if (!(obj instanceof Boid)) {
      return false;
    }
    Boid boid = (Boid)obj;
    return this == boid;
  }
}
