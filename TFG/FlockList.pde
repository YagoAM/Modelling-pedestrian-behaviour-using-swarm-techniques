interface flocklists {
}

class FlockList implements flocklists {
  ArrayList<Flock> lista;
  ArrayList<Boid> listaBoid;
  Grid grid;
  Interaccion interactor;	

  /*Constructor*/
  FlockList(Grid in) {
    lista = new ArrayList<Flock>();
    listaBoid = new ArrayList<Boid>();
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
    for (Flock flock : lista) {
      flock.mueve();
    }
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
    }
    interactor.flocking(this);
    interactor.boidSeparation(this);
  }
}
