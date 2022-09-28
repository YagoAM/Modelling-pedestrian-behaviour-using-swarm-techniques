Flock flock;

void setup(){
  size(1000,1000);
  flock = new Flock(10);

}

void draw(){
  background(200);
  flock.mueve();
  flock.dibuja();
}
