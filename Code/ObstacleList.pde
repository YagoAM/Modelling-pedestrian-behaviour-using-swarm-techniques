class ObstacleList {
  int previousWallNumber;
  int actualWallNumber;
  boolean wallChange;
  ArrayList<Obstacle> lista;
  Grid grid;
  boolean preparation = false;
  int last = 0;

  /*Constructor*/
  ObstacleList(Grid in) {
    lista = new ArrayList<Obstacle>();
    grid = in;
  }

  /*Metodos*/
  void preAdd(Vector2D posicion_in){
    if (preparation == false){
      this.add(posicion_in);
      preparation = true;
    } else {
      lista.get(last).setDestino(grid.get(posicion_in).casilla);
      last++;
      preparation = false;
    }
  }
  
  void add(Vector2D posicion_in) {
    Obstacle obstacle = new Obstacle(posicion_in, new Vector2D(), grid);
    lista.add(obstacle);
  }

  Obstacle get(int i) {
    return lista.get(i); //<>//
  }

  void mueve() {
    for (Obstacle obstacle : lista) {
      obstacle.mueve();
    }
  }

  void dibuja() {
    for (Obstacle obstacle : lista) {
      obstacle.dibuja();
    }
  }
}
