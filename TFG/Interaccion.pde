interface interacciones { //<>// //<>//
}

class Interaccion implements interacciones {
  static final int PPAL_FEELER_LENGTH = 40;
  static final int LATERAL_FEELER_LENGTH = 30;
  static final float FEELER_ANGLE_FACTOR = 2.5;

  void colision(Boid boid, Grid grid) {
    Casilla casillaBoid = new Casilla((int)(boid.pos.x/grid.lado), (int)(boid.pos.y/grid.lado));
    Tile tileBoid = grid.get(casillaBoid);

    colision(boid, tileBoid.vecinos);
    wallAvoidance(boid, tileBoid.vecinos);
  }

  void colision(Boid boid, Casilla[] walls) {
    for (int i = 0; i<8/*longitud de tileBoid.vecinos*/; i++) { //Casilla casillaVecino : tileBoid.vecinos
      Casilla casillaVecino = walls[i];
      if (casillaVecino == null) {
        continue;
      }
      Tile vecino = grid.get(casillaVecino);
      if (vecino.pathable == false) {
        if (abs(boid.pos.x-vecino.centro.x) < vecino.lado/2+Boid.size/2 && abs(boid.pos.y-vecino.centro.y) < vecino.lado/2+Boid.size/2) {
          boolean arriba = boid.pos.y-vecino.centro.y < 0;
          boolean abajo = boid.pos.y-vecino.centro.y > 0;
          boolean derecha = boid.pos.x-vecino.centro.x > 0;
          boolean izquierda = boid.pos.x-vecino.centro.x < 0;

          if (arriba) {
            boid.pos.y = vecino.centro.y - (vecino.lado/2+Boid.size/2);
          }
          if (abajo) {
            boid.pos.y = vecino.centro.y + (vecino.lado/2+Boid.size/2);
          }
          if (derecha) {
            boid.pos.x = vecino.centro.x + (vecino.lado/2+Boid.size/2);
          }
          if (izquierda) {
            boid.pos.x = vecino.centro.x - (vecino.lado/2+Boid.size/2);
          }

          boid.pos.set(boid.prevPos);
        }
      }
    }
  }

  void wallAvoidance(Boid boid, Casilla[] walls) {
    Vector2D[] feelers = setFeelers(boid);
    Vector2D feeler;
    Tile wall;

    float distToThisWall = 0.0;
    float distToNearestWall = Float.MAX_VALUE;
    int closestWall = -1;
    int closestLado = -1;

    Vector2D acc = new Vector2D();
    Vector2D closestPoint = new Vector2D();
    Vector2D auxPoint = new Vector2D();

      for (int f=0; f<feelers.length; f++) {  //LOOP DE FEELERS
      feeler = feelers[f];
      for (int i=0; i<8; i++) {  //LOOP DE MUROS
        if (walls[i] == null){continue;}
        wall = grid.get(walls[i]); //<>//
        if (wall.pathable == true){continue;}
        for (int lado=0; lado<4; lado++) {  //LOOP LADOS DEL MURO
          switch(lado) {
          case 0:
            auxPoint = line_line_p(boid.pos, feeler, wall.up_left, wall.up_right);
            break;
          case 1:
            auxPoint = line_line_p(boid.pos, feeler, wall.up_right, wall.down_right);
            break;
          case 2:
            auxPoint = line_line_p(boid.pos, feeler, wall.down_right, wall.down_left);
            break;
          case 3:
            auxPoint = line_line_p(boid.pos, feeler, wall.down_left, wall.up_left);
            break;
          } //<>//
          if (auxPoint!=null && (distToThisWall=dist2(boid.pos, auxPoint)) < distToNearestWall) {
            distToNearestWall = distToThisWall;
            closestWall = i;
            closestLado = lado;
            closestPoint = new Vector2D(auxPoint);
          }
        }  //FIN LOOP LADOS DEL MURO
      }  //FIN LOOP DE MUROS

      if (closestWall>=0) {
        Vector2D profundidad = new Vector2D(feeler);
        profundidad.substract(closestPoint); //<>//

        switch(closestLado) {
        case 0:
          acc = getNormalToLine(grid.get(walls[closestWall]).up_left, grid.get(walls[closestWall]).up_right);
          break;
        case 1:
          acc = getNormalToLine(grid.get(walls[closestWall]).up_right, grid.get(walls[closestWall]).down_right);
          break;
        case 2:
          acc = getNormalToLine(grid.get(walls[closestWall]).down_right, grid.get(walls[closestWall]).down_left);
          break;
        case 3:
          acc = getNormalToLine(grid.get(walls[closestWall]).down_left, grid.get(walls[closestWall]).up_left);
          break;
        }
        acc.getUnitVector();
        acc.multiply_by(profundidad.getModule());
        acc.multiply_by(-1);
      }
    }  //FIN LOOP DE FILLERS
    
    boid.setSeparMuro(acc);
  }



  Vector2D[] setFeelers(Boid boid) {
    Vector2D[] feelers = new Vector2D[3];
    Vector2D auxFeeler = new Vector2D(boid.vel);
    auxFeeler.getUnitVector();
    feelers[0] = new Vector2D(auxFeeler);
    feelers[0].multiply_by(PPAL_FEELER_LENGTH);
    feelers[0].add(boid.pos);  //FEELER CENTRAL
    
    //line(boid.pos.x, boid.pos.y, feelers[0].x, feelers[0].y);
    
    feelers[1] = new Vector2D(auxFeeler);
    Vector2D aux=get_perpendicular(feelers[1]);
    aux.divide_by(FEELER_ANGLE_FACTOR);//define el angulo de separacion, si es 1 son 45º, si es 2 son aprox 25º
    feelers[1].add(aux);
    feelers[1].getUnitVector();
    feelers[1].multiply_by(LATERAL_FEELER_LENGTH);
    feelers[1].add(boid.pos); //FEELER DERECHA (30 grados)
    
    //line(boid.pos.x, boid.pos.y, feelers[1].x, feelers[1].y);
    
    feelers[2] = new Vector2D(auxFeeler);
    feelers[2].substract(aux); //<>//
    feelers[2].getUnitVector();
    feelers[2].multiply_by(LATERAL_FEELER_LENGTH);
    feelers[2].add(boid.pos); //FEELER IZQUIERDA (30 grados)
    
    //line(boid.pos.x, boid.pos.y, feelers[2].x, feelers[2].y);
    
    /*
    feelers[3] = new Vector2D();
    feelers[3].add(aux);
    feelers[3].getUnitVector();
    feelers[3].multiply_by(LATERAL_FEELER_LENGTH);
    feelers[3].add(boid.pos);
    
    feelers[4] = new Vector2D();
    feelers[4].substract(aux);
    feelers[4].getUnitVector();
    feelers[4].multiply_by(LATERAL_FEELER_LENGTH);
    feelers[4].add(boid.pos);
    /**/
    return feelers;
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
        boid.setDirec(direc);
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
      vel_group.substract(boid.vel); //<>//
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
      acc.substract(boid.pos); //<>//
    }
    boid.setCohes(acc);
  }

  void separ_acc(Boid boid, ArrayList <Boid> near_boids) {
    Vector2D acc;
    acc = new Vector2D();
    Vector2D direction;
    direction = new Vector2D();
    float dist_factor = 30;
    float distance;

    if (near_boids.size()>0) {
      for (int i=0; i<near_boids.size(); i++) {
        if (boid == near_boids.get(i));
        distance = boid.dist2(near_boids.get(i));
        direction = substract(boid.pos, near_boids.get(i).pos).getUnitVector();
        if (distance > Boid.size) {
          direction.multiply_by(dist_factor/(distance-Boid.size));
        } else {
          direction.multiply_by(10000);
        }
        acc.add(direction);
      }
      acc.divide_by(near_boids.size());
    }

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
          if (aux<=Boid.VISION_RADIO) {
            near_flock_boids.add(boid2);
          }
        }
        alig_acc(boid, near_flock_boids);
        cohes_acc(boid, near_flock_boids);
        for (Boid boid2 : lista.listaBoid) {
          if (dist2(boid.pos, boid2.pos)<=Boid.VISION_RADIO) {
            near_flock_boids.add(boid2);
          }
        }
        separ_acc(boid, near_flock_boids);
      }
    }
  }
}
