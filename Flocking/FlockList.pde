class FlockList{
  ArrayList <Flock> flocks;
  
  FlockList(){
    flocks = new ArrayList <Flock> ();
  }
  
  void add(Flock flock){
    flocks.add(flock);
  }
  
  void mueve(){
    for(Flock flock : flocks){
      flock.near_flock_boid_calc();
      flock.near_boid_calc(this);
      flock.calc_acc();
      flock.mueve();
      flock.dibuja();
    }
  }
}
