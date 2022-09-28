class Boid{
  int size = 15;
  int maxVel = 5;
  int maxAcc = 1;
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
  }
  
  Boid(Vector2D posIn, Vector2D velIn){   
    pos = new Vector2D();
    vel = new Vector2D();
    acc = new Vector2D();
    
    newPos = new Vector2D();
    newVel = new Vector2D();
    
    pos.set(posIn);
    vel.set(velIn);
    newPos.set(pos);
    newVel.set(vel);
  }
  
  void mueve(){
    
    newVel.add(acc);
    newVel.limit(maxVel);
    newPos.add(newVel);
    
  }

  void dibuja(){
    pos.set(newPos);
    vel.set(newVel);
    
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(vel.getAngle());
    fill(255);
    ellipse(0, 0, size, size*2);
    fill(0);
    arc(0,0,size,size,1.0472,5.23599, OPEN);
    noFill();
    arc(0,0,size,size,0,PI*2, OPEN);
    popMatrix();
  }
}
