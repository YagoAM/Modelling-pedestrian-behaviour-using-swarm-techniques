class Flock{
  ArrayList <Boid> boids;
  
  Flock(int total){
    boids = new ArrayList <Boid>();
    
    for(int i=0; i<total; i++){
      Boid boid = new Boid(randomPosition(),random_with_maxMod(2));
      boids.add(boid);
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
}
