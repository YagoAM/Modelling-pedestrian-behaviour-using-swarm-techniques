class Boid{
  int flockNum;
  color fillColor;
  
  int num;
  
  float size = 13;
  float maxVel = 2;
  float maxAcc = 1;
  
  float separ_gain = 10;
  float cohes_gain = 0.1;
  float alig_gain = 1;
  
  float radio_vision = 90;
  
  ArrayList <Boid> near_flock_boids;
  ArrayList <Boid> near_boids; //por ahora no lo necesitamos, habria que meterlo en los creadores
  
  Vector2D pos;
  Vector2D vel;
  Vector2D acc;
  
  Vector2D newPos;
  Vector2D newVel;
  
  Boid(){   
    pos = new Vector2D();
    vel = new Vector2D();
    acc = new Vector2D();
    
    newPos = new Vector2D();
    newVel = new Vector2D();
    
    near_flock_boids = new ArrayList <Boid> ();
  }
  
  Boid(int number, Vector2D posIn, Vector2D velIn, int flockNumber, color inColor){   
    num = number;
    flockNum = flockNumber; //auxiliar
    fillColor = inColor;
    
    pos = new Vector2D();
    vel = new Vector2D();
    acc = new Vector2D();
    
    newPos = new Vector2D();
    newVel = new Vector2D();
    
    near_flock_boids = new ArrayList <Boid> ();
    
    pos.set(posIn);
    vel.set(velIn);
    newPos.set(pos);
    newVel.set(vel);
  }
  
  void calc_acc(){
    this.acc.cero();
    
    Vector2D alig_acc;
    alig_acc=this.alig_acc().multiply_by(alig_gain);
    this.acc.add(alig_acc);
    
    Vector2D cohes_acc;
    cohes_acc=this.cohes_acc().multiply_by(cohes_gain);
    this.acc.add(cohes_acc);
    
    Vector2D separ_acc;
    separ_acc=this.separ_acc().multiply_by(separ_gain);
    this.acc.add(separ_acc);
    
  }
  
  void mueve(){
    
    newVel.add(acc);
    newVel.limit(maxVel);
    newPos.add(newVel);
    
    if(newPos.x > width){
      newPos.x = 0;
    }
    else if(newPos.x < 0){
      newPos.x = width;
    }
    if(newPos.y > height){
      newPos.y = height;
    }
    else if(newPos.y < 0){
      newPos.y = 0;
    }
    
  }

  void dibuja(){
    pos.set(newPos);
    vel.set(newVel);
    
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(vel.getAngle());
    fill(fillColor);
    ellipse(0, 0, size, size*2);
    fill(0);
    arc(0,0,size,size,1.0472,5.23599, OPEN);
    noFill();
    arc(0,0,size,size,0,PI*2, OPEN);
    popMatrix();
  }
  
  float dist2(Boid other){
    Vector2D dist = new Vector2D();
    dist.set(this.pos);
    dist.substract(other.pos);
    return(dist.getModule());
  }
  
  void near_boid_calc(FlockList flocklist){
    ArrayList <Boid> near_boids;
    near_boids = new ArrayList <Boid>();
    for(int i=0; i<flocklist.flocks.size(); i++){
      for(int j=0; j<flocklist.flocks.get(i).boids.size(); j++){
        Boid boid = flocklist.flocks.get(i).boids.get(j);
        if(boid==this){continue;}
        if(this.dist2(boid)<=radio_vision){
          near_boids.add(flocklist.flocks.get(i).boids.get(j));
        }
      }
    }
    
    this.near_boids=near_boids;
    //println("El boid " + this.num + " está cerca de " + this.near_flock_boids.size() + " boids del flock");
  }
  void near_flock_boid_calc(Flock flock){
    ArrayList <Boid> near_boids;
    near_boids = new ArrayList <Boid>();
    for(int i=0; i<flock.boids.size(); i++){
      Boid boid = flock.boids.get(i);
      if(boid==this){continue;}
      if(this.dist2(boid)<=radio_vision){
        near_boids.add(flock.boids.get(i));
      }
    }
    this.near_flock_boids=near_boids;
    //println("El boid " + this.num + " está cerca de " + this.near_flock_boids.size() + " boids del flock");
  }
  
  Vector2D alig_acc(){ //LA FORMULA ORIGINAL DE RAYNOLS ES EL SUMATORIO DE LAS VELOCIDADES DEL RESTO/NUMERO DE BOIDS CERCANOS - NUESTRA VELOCIDAD, PERO SE PUDEN CONSEGUIR RESULTADOS SIMILARES 
                       //ENIENDO EN CUENTA NUESTRA VELOCIDAD AL CALCULAR LA VELOCIDAD MEDIA O NO RESTANDO NUESTRA VELOCIDAD. CUANDO ESTEN EL RESTO DE COMPORTAMIENTOS PROBARE LAS MODIFICACIONES SOBRE ESTE

    Vector2D vel_group;
    vel_group = new Vector2D();
    
    if(near_flock_boids.size()>0){
      //vel_group.add(this.vel.multiply_by(1)); //no hace nada pero es para poder jugar un poco y ver que hacer NO ENTIENDO QUE PASA
      for (int i=0; i<this.near_flock_boids.size(); i++){
        vel_group.add(near_flock_boids.get(i).vel);
      }
      vel_group.divide_by(near_flock_boids.size());
      vel_group.substract(this.vel);
    }
    return vel_group;
  }
  
  Vector2D cohes_acc(){
    Vector2D acc;
    acc = new Vector2D();
    
    if(near_flock_boids.size()>0){
      for (int i=0; i<this.near_flock_boids.size(); i++){
        acc.add(near_flock_boids.get(i).pos);
      }
      acc.divide_by(near_flock_boids.size());
      acc.substract(this.pos);
    }    
    return acc;
  }
  
  Vector2D separ_acc(){
    Vector2D acc;
    acc = new Vector2D();
    Vector2D direction;
    direction = new Vector2D();
    float dist_factor = 30;
    float distance;
    
    if(near_boids.size()>0){
      for (int i=0; i<this.near_boids.size(); i++){
        distance = this.dist2(near_boids.get(i));
        direction = substract(this.pos,near_boids.get(i).pos).getUnitVector();
        if (distance > size){
          direction = direction.multiply_by(dist_factor/(distance-size));
        }
        else{
          direction = direction.multiply_by(10000000);
        }
        acc.add(direction);
      }
      acc.divide_by(near_boids.size());
    }    
    return acc;
  }
}
