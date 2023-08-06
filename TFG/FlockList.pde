interface flocklists {
}

class FlockList implements flocklists {
  int previousWallNumber;
  int actualWallNumber;
  boolean wallChange;
  ArrayList<Flock> lista;
  ArrayList<Boid> listaBoid;
  ObstacleList listaObstaculos;
  Grid grid;
  Interaccion interactor;	

  /*Constructor*/
  FlockList(Grid in) {
    lista = new ArrayList<Flock>();
    listaBoid = new ArrayList<Boid>();
    listaObstaculos = new ObstacleList(in);
    grid = in;
    interactor = new Interaccion();
  }

  /*Metodos*/
  void add(int total, Vector2D posicion_in) {
    Flock flock = new Flock(total, posicion_in, grid);
    lista.add(flock);
    listaBoid.addAll(flock.boids);
  }

  Flock get(int i) {
    return lista.get(i);
  }

  void mueve() {
    actualWallNumber = grid.muros.size();
    if (previousWallNumber != actualWallNumber) {
      wallChange =  true;
    }
    for (Flock flock : lista) {
      if (wallChange == true) {
        flock.flowfield.recalc();
      }
      flock.mueve();
    }
    if (wallChange == true) {
      wallChange = false;
    }
    previousWallNumber = actualWallNumber;
  }

  void dibuja() {
    for (Flock flock : lista) {
      flock.dibuja();
    }
  }

  void interaccion() {
    for (Flock flock : lista) {
      interactor.colision(flock, grid);
      interactor.flow(flock, grid);
      interactor.obstacleAvoidance(flock, listaObstaculos);
    }
    interactor.flocking(this);
    interactor.boidSeparation(this);
  }
}
