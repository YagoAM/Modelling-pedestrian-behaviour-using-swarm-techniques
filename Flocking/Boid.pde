class Boid{
  int size = 15;
  int previousFrame;
  Vector2D pos;
  Vector2D vel;
  Vector2D acc;
  
  Vector2D newPos;
  Vector2D newVel;
  
  Boid(){
    previousFrame = frameCount;
    
    pos = new Vector2D();
    vel = new Vector2D();
    acc = new Vector2D();
    
    newPos = new Vector2D();
    newVel = new Vector2D();
    
    //pos.setRandomPosition();              //temporal
    //vel.setRandom_with_mod(1);            //temporal
    //acc.setRandom_with_maxMod(0.01);      //temporal
  }
  
  void update(){
    newVel.x = vel.x + (acc.x * (frameCount - previousFrame));
    newVel.y = vel.y + (acc.y * (frameCount - previousFrame));
    
    newPos.x = pos.x + (vel.x * (frameCount - previousFrame));
    newPos.y = pos.y + (vel.y * (frameCount - previousFrame));
    previousFrame = frameCount;
  }
  
  void dibuja(){
    translate(pos.x, pos.y);
    rotate(vel.getAngle());
    fill(255);
    ellipse(0, 0, size, size*2);
    fill(0);
    arc(0,0,size,size,1.0472,5.23599, OPEN);
    noFill();
    arc(0,0,size,size,0,PI*2, OPEN);
    translate(-1*pos.x, -1*pos.y);
    rotate(-1*vel.getAngle());
  }
  
  void draw(){
    pos.set(newPos);
    vel.set(newVel);
    this.dibuja();
  }
}
