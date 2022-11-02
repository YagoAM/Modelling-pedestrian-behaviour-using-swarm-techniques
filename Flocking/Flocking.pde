FlockList flocklist;

void setup(){
  size(1000,200);  
  flocklist = new FlockList();
  flocklist.add(new Flock(30,1));
  flocklist.add(new Flock(30,2));

}

void draw(){
  background(200);
  flocklist.mueve();
}
