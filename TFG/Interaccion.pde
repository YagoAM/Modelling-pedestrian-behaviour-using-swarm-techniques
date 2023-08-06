interface interacciones { //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>//
}

class Interaccion implements interacciones {
  //WALL SEPARATION CONSTANTS
  static final int PPAL_FEELER_LENGTH = 40;
  static final int LATERAL_FEELER_LENGTH = 40;
  static final float FEELER_ANGLE_FACTOR = 2.5;
  static final boolean SHOW_FEELERS = false;

  //FLOCKING CONSTANTS
  static final float COHESION_GAIN = 0.015;
  static final float SEPARATION_GAIN = 30;//3;//
  static final float ALIGNMENT_GAIN = 0;

  //BOID SEPARATION CONSTANTS
  static final float BOID_SEPARATION_GAIN = 13;
  static final float MAX_BACKWARD_ACC = 0.3;

  void colision(Boid boid, Grid grid) {
    Casilla casillaBoid = new Casilla((int)(boid.pos.x/grid.lado), (int)(boid.pos.y/grid.lado));
    Tile tileBoid = grid.get(casillaBoid);

    colision(boid, tileBoid.vecinos);
    wallAvoidance(boid, tileBoid.vecinos);
  }

  void obstacleAvoidance(Flock flock, ObstacleList lista) {
    for (Boid boid : flock.boids) {
      obstacleAvoidance(boid, lista);
    }
  }

  void obstacleAvoidance(Boid boid, ObstacleList lista) {
    if (!lista.lista.isEmpty()) {
      float dist = Boid.OTHER_FLOCK_VISION_RADIO;
      int contador = -1;
      int ganador = 0;
      Vector2D direccion = new Vector2D();

      for (Obstacle obstacle : lista.lista) {
        contador++;
        float auxDist = dist2(boid.futurePos, obstacle.futurePos);
        if (auxDist < dist) {
          dist = auxDist;
          ganador = contador;
        }
      }
      if (dist < Boid.OTHER_FLOCK_VISION_RADIO) {
        if (dist > Boid.size+Obstacle.size) {
          Obstacle obstacle = lista.get(ganador);
          direccion = substract(boid.futurePos, obstacle.futurePos).getUnitVector();
          direccion.divide_by((dist-(Boid.size+Obstacle.size))/5);
        } else {
          direccion.multiply_by(5000);
        }
      }
      boid.setObstacleSepar(direccion);
    }
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
    int trigeredFeeler = -1;

    boolean backwardAcc = false, feelerIzquierda = false, feelerDerecha = false;

    Vector2D acc = new Vector2D();
    Vector2D closestPoint = new Vector2D();
    Vector2D auxPoint = new Vector2D();

    for (int f=0; f<feelers.length; f++) {  //LOOP DE FEELERS
      feeler = feelers[f];
      for (int i=0; i<8; i++) {  //LOOP DE MUROS
        if (walls[i] == null) {
          continue;
        }
        wall = grid.get(walls[i]);
        if (wall.pathable == true) {
          continue;
        }
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
          }
          if (auxPoint!=null && (distToThisWall=dist2(boid.pos, auxPoint)) < distToNearestWall) {
            if (f==0) {
              feelerDerecha = true;
            }
            if (f==1) {
              feelerIzquierda = true;
            }
            if (feelerDerecha == true && feelerIzquierda == true) {
              backwardAcc = true;
              println("buen ass");
            }
            distToNearestWall = distToThisWall;
            closestWall = i;
            closestPoint = new Vector2D(auxPoint);
            trigeredFeeler = f;
            feeler = feelers[trigeredFeeler];
          }
        }  //FIN LOOP LADOS DEL MURO
      }  //FIN LOOP DE MUROS

      if (closestWall>=0) {
        Vector2D profundidad = new Vector2D(feeler);
        profundidad.substract(closestPoint);
        //MODO DERECHA O IZQUIERDA
        if (backwardAcc == true) {
          acc = new Vector2D(boid.vel.getUnitVector());
          acc.multiply_by(-1);
        } else {
          switch(trigeredFeeler) {
          case 0:  //FEELER DERECHA
            acc = get_perpendicular(boid.vel.getUnitVector());
            acc.multiply_by(-1);
            break;
          case 1:  //FEELER IZQUIERDA
            acc = get_perpendicular(boid.vel.getUnitVector());
            acc.multiply_by(1);
            break;
          case 2:  //FEELER DERECHA
            acc = get_perpendicular(boid.vel.getUnitVector());
            acc.multiply_by(-1);
            break;
          case 3:  //FEELER IZQUIERDA
            acc = get_perpendicular(boid.vel.getUnitVector());
            acc.multiply_by(1);
            break;
          }
        }

        //acc = get_perpendicular(feeler);
        //if(trigeredFeeler == 1 || trigeredFeeler == 3){acc.multiply_by(-1);}

        acc.getUnitVector();
        acc.multiply_by(profundidad.getModule());
      }
    }  //FIN LOOP DE FILLERS

    boid.setSeparMuro(acc);
  }



  Vector2D[] setFeelers(Boid boid) {
    Vector2D[] feelers = new Vector2D[4];
    Vector2D auxFeeler = new Vector2D(boid.vel);
    auxFeeler.getUnitVector();
    Vector2D aux=get_perpendicular(auxFeeler);

    feelers[0] = new Vector2D(auxFeeler);
    aux.divide_by(FEELER_ANGLE_FACTOR);//define el angulo de separacion, si es 1 son 45º, si es 2 son aprox 25º
    feelers[0].add(aux);
    feelers[0].setUnitVector();
    feelers[0].multiply_by(PPAL_FEELER_LENGTH);
    feelers[0].add(boid.pos); //FEELER DERECHA

    feelers[1] = new Vector2D(auxFeeler);
    feelers[1].substract(aux);
    feelers[1].setUnitVector();
    feelers[1].multiply_by(PPAL_FEELER_LENGTH);
    feelers[1].add(boid.pos); //FEELER IZQUIERDA

    aux=get_perpendicular(auxFeeler);
    aux.multiply_by(1.5);
    feelers[2] = new Vector2D(auxFeeler);
    feelers[2].add(aux);
    feelers[2].setUnitVector();
    feelers[2].multiply_by(LATERAL_FEELER_LENGTH);
    feelers[2].add(boid.pos); //FEELER DERECHA

    feelers[3] = new Vector2D(auxFeeler);
    feelers[3].substract(aux);
    feelers[3].setUnitVector();
    feelers[3].multiply_by(LATERAL_FEELER_LENGTH);
    feelers[3].add(boid.pos); //FEELER IZQUIERDA
    /**/

    if (SHOW_FEELERS) {
      for (int i=0; i<feelers.length; i++) {
        line(boid.pos.x, boid.pos.y, feelers[i].x, feelers[i].y);
      }
    }

    return feelers;
  }

  void colision(Flock flock, Grid grid) {
    for (Boid boid : flock.boids) {
      colision(boid, grid);
    }
  }

  void flow(Flock flock, Grid grid) {
    //Metodo de asignar la direccion segun la casilla del void
    /*
    for (Boid boid : flock.boids) {
     Casilla casillaAux = new Casilla((int)(boid.pos.x/grid.lado), (int)(boid.pos.y/grid.lado));
     Casilla casillaBoid = grid.get(casillaAux).casilla;
     if (casillaBoid == flock.flowfield.target) {
     //boid.setDirec(new Vector2D(-boid.vel.x, -boid.vel.y)); //POSIBLE FORMA, QUE SE PARE EL BOID AL LLEGAR
     grid.get(flock.flowfield.target).colorinchi = #FFFFFF;
     flock.generarPathing();
     } else {
     TileData tiledataBoid = flock.flowfield.tiles.get(casillaBoid);
     Vector2D direc;
     if (tiledataBoid.LOS==false) {
     direc = new Vector2D(tiledataBoid.direccion);
     } else {
     direc = substract(grid.get(flock.flowfield.target).centro, boid.pos);
     }
     
     //Prueba
     direc.setUnitVector();
     direc.multiply_by(Boid.MAX_VEL);
     direc.substract(boid.vel);
     //Fin prueba
     boid.setDirec(direc);
     }
     }/**/
    //Metodo de asignar la direccion segun la celda cetroFlock
    for (Boid boid : flock.boids) {
      Casilla casillaAux = new Casilla((int)(boid.pos.x/grid.lado), (int)(boid.pos.y/grid.lado));
      Casilla casillaBoid = grid.get(casillaAux).casilla;
      //Casilla casillaBoid = grid.get(boid.casillaFLock).casilla;
      if (casillaBoid == flock.flowfield.target) {
        //boid.setDirec(new Vector2D(-boid.vel.x, -boid.vel.y)); //POSIBLE FORMA, QUE SE PARE EL BOID AL LLEGAR
        grid.get(flock.flowfield.target).colorinchi = #FFFFFF;
        flock.generarPathing();
      } else {
        TileData tiledataBoid = flock.flowfield.tiles.get(casillaBoid);
        Vector2D direc;
        if (tiledataBoid.LOS==false) {
          direc = new Vector2D(tiledataBoid.direccion);
        } else {
          direc = substract(grid.get(flock.flowfield.target).centro, boid.pos);
        }

        //Prueba
        direc.setUnitVector();
        direc.multiply_by(Boid.MAX_VEL);
        direc.substract(boid.vel);
        //Fin prueba
        boid.setDirec(direc);
      }
    }/**/
  }

  //void alig_acc(Boid boid, ArrayList <Boid> near_flock_boids) { //LA FORMULA ORIGINAL DE RAYNOLS ES EL SUMATORIO DE LAS VELOCIDADES DEL RESTO/NUMERO DE BOIDS CERCANOS - NUESTRA VELOCIDAD, PERO SE PUDEN CONSEGUIR RESULTADOS SIMILARES
  //  //ENIENDO EN CUENTA NUESTRA VELOCIDAD AL CALCULAR LA VELOCIDAD MEDIA O NO RESTANDO NUESTRA VELOCIDAD. CUANDO ESTEN EL RESTO DE COMPORTAMIENTOS PROBARE LAS MODIFICACIONES SOBRE ESTE

  //  Vector2D vel_group;
  //  vel_group = new Vector2D();

  //  if (near_flock_boids.size()>0) {
  //    //vel_group.add(this.vel.multiply_by(1)); //no hace nada pero es para poder jugar un poco y ver que hacer NO ENTIENDO QUE PASA
  //    for (int i=0; i<near_flock_boids.size(); i++) {
  //      vel_group.add(near_flock_boids.get(i).vel);
  //    }
  //    vel_group.divide_by(near_flock_boids.size());
  //    vel_group.substract(boid.vel);
  //  }
  //  boid.setAlin(vel_group);
  //}

  //void cohes_acc(Boid boid, ArrayList <Boid> near_flock_boids) {
  //  Vector2D acc;
  //  acc = new Vector2D();

  //  if (near_flock_boids.size()>0) {
  //    for (int i=0; i<near_flock_boids.size(); i++) {
  //      acc.add(near_flock_boids.get(i).pos);
  //    }
  //    acc.divide_by(near_flock_boids.size());
  //    acc.substract(boid.pos);
  //  }
  //  boid.setCohes(acc);
  //}

  //void separ_acc(Boid boid, ArrayList <Boid> near_boids) {
  //  Vector2D acc;
  //  acc = new Vector2D();
  //  Vector2D direction;
  //  direction = new Vector2D();
  //  float dist_factor = 30;
  //  float distance;

  //  if (near_boids.size()>0) {
  //    for (int i=0; i<near_boids.size(); i++) {
  //      if (boid == near_boids.get(i));
  //      distance = boid.dist2(near_boids.get(i));
  //      direction = substract(boid.pos, near_boids.get(i).pos).getUnitVector();
  //      if (distance > Boid.size) {
  //        direction.multiply_by(dist_factor/(distance-Boid.size));
  //      } else {
  //        direction.multiply_by(10000);
  //      }
  //      acc.add(direction);
  //    }
  //    acc.divide_by(near_boids.size());
  //  }

  //  boid.setSepar(acc);
  //}

  //void flocking(FlockList lista) {
  //  ArrayList <Boid> near_flock_boids;
  //  near_flock_boids = new ArrayList <Boid>();
  //  for (Flock flock : lista.lista) {
  //    for (Boid boid : flock.boids) {
  //      for (Boid boid2 : flock.boids) {
  //        if (boid2 == boid) {
  //          continue;
  //        }
  //        float aux = dist2(boid.pos, boid2.pos);
  //        if (aux<=Boid.VISION_RADIO) {
  //          near_flock_boids.add(boid2);
  //        }
  //      }
  //      alig_acc(boid, near_flock_boids);
  //      cohes_acc(boid, near_flock_boids);
  //      for (Boid boid2 : lista.listaBoid) {
  //        if (dist2(boid.pos, boid2.pos)<=Boid.VISION_RADIO) {
  //          near_flock_boids.add(boid2);
  //        }
  //      }
  //      separ_acc(boid, near_flock_boids);
  //    }
  //  }
  //}

  void flocking (FlockList lista) {
    Vector2D flockAcc = new Vector2D();
    Vector2D sepAcc = new Vector2D();
    Vector2D cohAcc = new Vector2D();
    Vector2D alnAcc = new Vector2D();
    Vector2D centroFlock = new Vector2D();

    //Vectores auxiliares
    Vector2D avgHeading = new Vector2D();
    Vector2D sepAux = new Vector2D();

    //Variables auxiliares
    float dist;
    float neighbourCount;

    ArrayList<Flock> flocks = lista.lista;

    if (flocks == null || flocks.isEmpty()) {
      return;
    }

    for (Flock flock : flocks) {
      for (Boid boid : flock.boids) {
        flockAcc.setCero();
        sepAcc.setCero();
        cohAcc.setCero();
        alnAcc.setCero();
        avgHeading.setCero();
        sepAux.setCero();
        centroFlock.setCero();
        neighbourCount = 0;

        ArrayList<Boid> flockNeighbours = getFlockNeighbours(boid, flock);
        for (Boid other : flockNeighbours) {
          dist = boid.dist2(other);
          neighbourCount++;
          //Cohesion
          cohAcc.add(other.pos);
          //Alignment
          avgHeading.add(other.vel.getUnitVector());
          //Separation
          sepAux.set(substract(boid.pos, other.pos).getUnitVector());
          //if (dist > Boid.size*2.5) {
          //  sepAux.divide_by((dist-Boid.size*2.5)/4);
          //} else {
          //  sepAux.multiply_by(5000);
          //}
          if (dist > Boid.size) {
            sepAux.divide_by(dist);
            //sepAux.divide_by((dist-Boid.size)/5);
          } else {
            sepAux.multiply_by(1000);
          }
          sepAcc.add(sepAux);
        }
        //Centro del flock
        centroFlock.add(cohAcc);
        centroFlock.add(boid.pos);
        centroFlock.divide_by(neighbourCount+1);
        //cohAcc.add(boid.pos);
        if (neighbourCount > 0) {
          // Cohesion
          cohAcc.divide_by(neighbourCount);
          cohAcc.substract(boid.pos);
          //cohAcc.setUnitVector();
          //cohAcc.multiply_by(Boid.MAX_VEL);
          //cohAcc.substract(boid.vel);
          //cohAcc.setUnitVector();
          cohAcc.multiply_by(COHESION_GAIN);

          // Separation
          sepAcc.divide_by(neighbourCount);
          sepAcc.multiply_by(SEPARATION_GAIN);

          // Alignment
          avgHeading.divide_by(neighbourCount);
          avgHeading.substract(boid.vel.getUnitVector());
          alnAcc.set(avgHeading);
          alnAcc.multiply_by(ALIGNMENT_GAIN);

          // Add them up
          flockAcc.set(cohAcc);
          flockAcc.add(sepAcc);
          flockAcc.add(alnAcc);
        }

        //set casilla centro del flock
        boid.casillaFLock = grid.get(centroFlock).casilla;

        //Set flocking acc
        boid.setFlocking(flockAcc);
      }
    }
  }

  void boidSeparation (FlockList lista) {
    Vector2D sepAcc = new Vector2D();

    //Vectores auxiliares
    Vector2D sepAux = new Vector2D();
    Vector2D foreheadAcc = new Vector2D();
    Vector2D lateralAcc = new Vector2D();

    //Variables auxiliares
    float dist;
    float neighbourCount;

    ArrayList<Flock> flocks = lista.lista;

    if (flocks == null || flocks.isEmpty()) {
      return;
    }

    for (Flock flock : flocks) {
      for (Boid boid : flock.boids) {
        sepAcc.setCero();
        sepAux.setCero();
        neighbourCount = 0;

        ArrayList<Boid> nonFlockNeighbours = getNonFlockNeighbours(boid, flock, lista);
        for (Boid other : nonFlockNeighbours) {
          dist = boid.dist2future(other);
          neighbourCount++;
          //Separation
          sepAux.set(substract(boid.futurePos, other.futurePos).getUnitVector());
          //if (dist > Boid.size*2) {
          //  sepAux.divide_by((dist-Boid.size*2)/8);
          //} else {
          //  sepAux.multiply_by(5000);
          //}
          if (dist > 0) {
            sepAux.divide_by((dist)/15);
          } else {
            sepAux.multiply_by(1000);
          }
          sepAcc.add(sepAux);
        }
        if (neighbourCount > 0) {
          //Separation
          sepAcc.divide_by(neighbourCount);
          //sepAcc.multiply_by(BOID_SEPARATION_GAIN);
        }

        foreheadAcc = calcProjection(sepAcc, boid.heading);
        lateralAcc = calcProjection(sepAcc, boid.lateral);
        if (lateralAcc.getModule() != 0) {
          println("Basil");
        }
        foreheadAcc.limit(0.1/*MAX_BACKWARD_ACC*/);
        lateralAcc.multiply_by(0.9);
        if (lateralAcc.getModule() != 0) {
          println("Basil");
        }
        sepAcc.set(foreheadAcc);
        sepAcc.add(lateralAcc);

        sepAcc.limit(1.5);
        boid.setBoidSepar(sepAcc);

        //if (true) {
        //  line(boid.pos.x, boid.pos.y, boid.pos.x+boid.lateral.x*20, boid.pos.y+boid.lateral.y*20);
        //}
      }
    }
  }

  ArrayList<Boid> getFlockNeighbours(Boid boid, Flock flock) {
    ArrayList<Boid> neighbours = new ArrayList<Boid>();

    for (Boid other : flock.boids) {
      if (other == boid) {
        continue;
      }
      if (boid.dist2(other) <= Boid.VISION_RADIO) {
        neighbours.add(other);
      }
    }

    return neighbours;
  }

  ArrayList<Boid> getNonFlockNeighbours(Boid boid, Flock flock, FlockList flockList) {
    ArrayList<Boid> neighbours = new ArrayList<Boid>();
    float dist;
    for (Flock otherFlock : flockList.lista) {
      if (otherFlock.boids.contains(boid)) {
        continue;
      }
      for (Boid other : otherFlock.boids) {
        if (other == boid) {
          continue;
        }
        dist = boid.dist2future(other);
        if (dist <= Boid.OTHER_FLOCK_VISION_RADIO) {
          neighbours.add(other);
        }
      }
    }

    return neighbours;
  }

  ArrayList<Boid> getAllNeighbours(Boid boid, FlockList flockList) {
    ArrayList<Boid> neighbours = new ArrayList<Boid>();

    for (Boid other : flockList.listaBoid) {
      if (other == boid) {
        continue;
      }
      if (boid.dist2(other) <= Boid.VISION_RADIO) {
        neighbours.add(other);
      }
    }

    return neighbours;
  }
}
