class Flock{
  int flockNum;
  color flockColor;
  ArrayList <Boid> boids;
  
  Flock(int total, int flockNumber){
    flockNum = flockNumber;
    flockColor = color(random(255),random(255),random(255));
    boids = new ArrayList <Boid>();
    
    for(int i=0; i<total; i++){
      Boid boid = new Boid(i, randomPosition(),random_with_maxMod(2), flockNum, flockColor);
      boids.add(boid);
    }
  }
  
  void calc_acc(){
    for(Boid boid : boids){
      boid.calc_acc();
    }
  }
  
  void mueve(){
    for(Boid boid : boids){
      boid.mueve();
    }
  }
  
  void dibuja(){
    for(Boid boid : boids){
      boid.dibuja();
    }
  }
  
  //Funciones de prueba. No tendran utilidad real, es para ver como hacer la logica
  void distancia(Flock otherFlock){
    for(Boid boidA : this.boids){
      for(Boid boidB : otherFlock.boids){
        if(boidA.dist2(boidB) <= 60 && boidA!=boidB) {
          println("El boid " + boidA.num + " del flock " + this.flockNum + " esta cerca del boid " + boidB.num + " del flock " + otherFlock.flockNum);
        }
      }
    }
  }
  
  //Este tipo de funcion no tiene sentido que esté aqui, ya que da igual desde que flock se llame siempre analiza todos
  /*void distancia(ArrayList <Flock> FList){
    for(int i=0; i<FList.size(); i++){
      Flock flock1 = FList.get(i);
      for(int g=0; g<FList.size(); g++){
        if(g==i){continue;}
        Flock flock2 = FList.get(g);
        flock1.distancia(flock2);
      }
    }
  }*/
  
  void distancia(ArrayList <Flock> FList){
    Flock flock1 = this;    
    for(int g=0; g<FList.size(); g++){
      //if(FList.get(g)==this){continue;} //Puedes comprobar la igualdad de dos objetos
      Flock flock2 = FList.get(g);
      flock1.distancia(flock2);
    }
  }
  
  void near_boid_calc(FlockList flocklist){
    for (int i=0; i<this.boids.size(); i++){
      this.boids.get(i).near_boid_calc(flocklist);
    }
  }
  void near_flock_boid_calc(){
    for (int i=0; i<this.boids.size(); i++){
      this.boids.get(i).near_flock_boid_calc(this);
      //println("Boid " + i + " tiene cerca " + this.boids.get(i).near_flock_boids.size());
    }
  }
  
  
}
