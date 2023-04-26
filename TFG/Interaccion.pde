interface interacciones { //<>// //<>// //<>// //<>// //<>//
}

class Interaccion implements interacciones {
  void colision(Boid boid, Grid grid) {
    Vector2D acc;
    acc = new Vector2D();
    Vector2D direction;
    direction = new Vector2D();
    float dist_factor = 30;
    float distance;
    Casilla casillaBoid = new Casilla((int)(boid.pos.x/grid.lado), (int)(boid.pos.y/grid.lado));
    Tile tileBoid = grid.get(casillaBoid);
    
    if (tileBoid.pathable == false){
      direction = substract(boid.pos, tileBoid.centro).getUnitVector();
      direction.multiply_by(1000);
      acc.add(direction);
    }
    
    for (Casilla casillaVecino : tileBoid.vecinos) {
      if (casillaVecino == null) {
        continue;
      }
      Tile vecino = grid.get(casillaVecino);
      if (vecino.pathable == false) {
        distance = dist2(boid.pos, tileBoid.centro);
        direction = substract(boid.pos, tileBoid.centro).getUnitVector();
        if (distance <= (vecino.lado+TFG.Boid.size)) {
          direction.multiply_by(dist_factor/(distance));
          acc.add(direction);
        }
      }
    }
    
    boid.setSeparMuro(acc); //<>//
  }

  void colision(Flock flock, Grid grid) {
    for (Boid boid : flock.boids) {
      colision(boid, grid);
    }
  }

  void flow(Flock flock, Grid grid) {
    for (Boid boid : flock.boids) {
      Casilla casillaAux = new Casilla((int)(boid.pos.x/grid.lado), (int)(boid.pos.y/grid.lado));
      Casilla casillaBoid = grid.get(casillaAux).casilla;
      if (casillaBoid == flock.flowfield.target) {
        //boid.setDirec(new Vector2D(-boid.vel.x, -boid.vel.y)); //POSIBLE FORMA, QUE SE PARE EL BOID AL LLEGAR
        flock.generarPathing();
      } else {
        Vector2D direc = new Vector2D(flock.flowfield.tiles.get(casillaBoid).direccion);
        boid.setDirec(direc); //<>//
      }
    }
  }

  void alig_acc(Boid boid, ArrayList <Boid> near_flock_boids) { //LA FORMULA ORIGINAL DE RAYNOLS ES EL SUMATORIO DE LAS VELOCIDADES DEL RESTO/NUMERO DE BOIDS CERCANOS - NUESTRA VELOCIDAD, PERO SE PUDEN CONSEGUIR RESULTADOS SIMILARES
    //ENIENDO EN CUENTA NUESTRA VELOCIDAD AL CALCULAR LA VELOCIDAD MEDIA O NO RESTANDO NUESTRA VELOCIDAD. CUANDO ESTEN EL RESTO DE COMPORTAMIENTOS PROBARE LAS MODIFICACIONES SOBRE ESTE

    Vector2D vel_group;
    vel_group = new Vector2D();

    if (near_flock_boids.size()>0) {
      //vel_group.add(this.vel.multiply_by(1)); //no hace nada pero es para poder jugar un poco y ver que hacer NO ENTIENDO QUE PASA
      for (int i=0; i<near_flock_boids.size(); i++) {
        vel_group.add(near_flock_boids.get(i).vel);
      }
      vel_group.divide_by(near_flock_boids.size());
      vel_group.substract(boid.vel);
    }
    boid.setAlin(vel_group);
  }

  void cohes_acc(Boid boid, ArrayList <Boid> near_flock_boids) {
    Vector2D acc;
    acc = new Vector2D();

    if (near_flock_boids.size()>0) {
      for (int i=0; i<near_flock_boids.size(); i++) {
        acc.add(near_flock_boids.get(i).pos);
      }
      acc.divide_by(near_flock_boids.size());
      acc.substract(boid.pos);
    }
    boid.setCohes(acc);
  }

  void separ_acc(Boid boid, ArrayList <Boid> near_boids) {
    Vector2D acc; //<>//
    acc = new Vector2D(); //<>//
    Vector2D direction; //<>//
    direction = new Vector2D(); //<>//
    float dist_factor = 30; //<>//
    float distance; //<>//

    if (near_boids.size()>0) { //<>//
      for (int i=0; i<near_boids.size(); i++) { //<>//
        if(boid == near_boids.get(i)); //<>//
        distance = boid.dist2(near_boids.get(i)); //<>//
        direction = substract(boid.pos, near_boids.get(i).pos).getUnitVector(); //<>//
        if (distance > Boid.size) { //<>//
          direction.multiply_by(dist_factor/(distance-Boid.size)); //<>//
        } else { //<>//
          direction.multiply_by(10000); //<>//
        } //<>//
        acc.add(direction); //<>//
      } //<>//
      acc.divide_by(near_boids.size());
    }
 //<>//
    boid.setSepar(acc);
  }

  void flocking(FlockList lista) {
    ArrayList <Boid> near_flock_boids;
    near_flock_boids = new ArrayList <Boid>();
    for (Flock flock : lista.lista) {
      for (Boid boid : flock.boids) {
        for (Boid boid2 : flock.boids) {
          if (boid2 == boid) {
            continue;
          }
          float aux = dist2(boid.pos, boid2.pos);
          if (aux<=Boid.radioVision) {
            near_flock_boids.add(boid2);
          }
        }
        alig_acc(boid, near_flock_boids);
        cohes_acc(boid, near_flock_boids);
        for (Boid boid2 : lista.listaBoid) {
          if (dist2(boid.pos, boid2.pos)<=Boid.radioVision) {
            near_flock_boids.add(boid2);
          }
        }
        separ_acc(boid, near_flock_boids);
      }
    }
  }
}
