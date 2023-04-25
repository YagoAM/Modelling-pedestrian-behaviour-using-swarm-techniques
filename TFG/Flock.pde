interface flocks {
}

class Flock {
  /*Atributos*/
  color flockColor;
  Grid grid;
  FlowField flowfield;
  ArrayList <Boid> boids;
  Casilla destino;

  /*Constructor*/
  Flock() {
    flockColor = color(random(255), random(255), random(255));
    boids = new ArrayList <Boid>();
  }

  Flock(int total, Vector2D posicion_in, Grid grid_in) {
    grid = grid_in;
    generarPathing();
    flockColor = color(random(255), random(255), random(255));
    boids = new ArrayList <Boid>();

    generarBoids(total, posicion_in);
  }

  /*Métodos*/
  void generarPathing() {
    do {
      destino = new Casilla((int)random(0, grid.columnas), (int)random(0, grid.filas));
      if(destino == null){
        println("cague");
      }
    } while (grid.get(destino).pathable == false);
    flowfield = new FlowField(grid, destino);
  }
  
  void generarBoids(int total, Vector2D posicion_in) {
    Casilla casilla= new Casilla((int)posicion_in.x/grid.lado, (int)posicion_in.y/grid.lado);
    
    Vector2D posicion;
    int i = 0;
    
    if(casilla == null){
      println("cague"); //<>//
    }
    
    while (i < total) {
      posicion = new Vector2D(grid.get(casilla).centro);
      posicion.add(randomWithMaxMod(grid.lado));
      Boid boid = new Boid(posicion, new Vector2D(), flockColor);
      boids.add(boid);
      i++;
    }
  }

  void mueve() {
    for (Boid boid : boids) {
      boid.mueve();
    }
  }

  void dibuja() {
    for (Boid boid : boids) {
      boid.dibuja();
    }
  }
}
