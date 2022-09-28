class Flock{
  ArrayList <Boid> boids;
  
  Flock(int total){
    boids = new ArrayList <Boid>();
    
    for(int i=0; i<total; i++){
      Boid boid = new Boid();
      boid.pos.setRandomPosition();
      boid.vel.setRandom_with_maxMod(2);
      boids.add(boid);
    }
  }
  
  void update(){
    for(Boid boid : boids){
      boid.update();
    }
  }
  
  void draw(){
    for(Boid boid : boids){
      boid.draw();
    }
  }
}
