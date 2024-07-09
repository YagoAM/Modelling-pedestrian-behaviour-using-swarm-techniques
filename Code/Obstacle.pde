class Obstacle {
  //Atributos
  Grid grid;
  FlowField flowfield;
  Casilla origen, destino;
  Vector2D heading, lateral;
  Vector2D pos;
  Vector2D futurePos;
  Vector2D prevPos;
  Vector2D vel;
  Vector2D direccion;  //Aceleración que marca la direccion en la que se tiene que mover para llegar al destino.
  color fillColor = #0E8B0D;  //Color para la representacion del Boid, variará dependiendo de a que Flock pertenezca, para poder diferenciarlos.
  Casilla casilla;

  //Atributos Static
  static final float size = 50;
  static final float MAX_VEL = 1.5;
  static final float MAX_ACC = 0.17;
  static final float FUTURE_FRAMES_PROJECTION = 5;

  //Constructor
  Obstacle(Vector2D posIn, Vector2D velIn, Grid in) {
    pos = new Vector2D(posIn);
    futurePos = new Vector2D(posIn);
    prevPos = new Vector2D(posIn);
    vel = new Vector2D(velIn);
    heading = vel.getUnitVector();
    lateral = get_perpendicular(heading);
    grid = in;
    direccion = new Vector2D();
    casilla = grid.get(pos).casilla;
    origen = casilla;
  }

  //Métodos
  //Funciones Set
  void setPos(Vector2D in) {
    Vector2D aux = new Vector2D(in);
    pos = aux;
  }
  void setVel(Vector2D in) {
    Vector2D aux = new Vector2D(in);
    vel = aux;
  }
  void setDestino(Casilla in) {
    destino = grid.get(in).casilla;
    flowfield = new FlowField(grid, destino);
  }

  //Funciones basicas
  void mueve() {
    this.flow();
    vel.limit(MAX_VEL);
    prevPos.set(pos);
    pos.add(vel);
    futurePos.set(pos);
    futurePos.add(product(vel, FUTURE_FRAMES_PROJECTION));
    heading = vel.getUnitVector();
    lateral = get_perpendicular(heading);
    casilla = grid.get(pos).casilla;

    if (pos.x >= width) {
      pos.x = width;
    } else if (pos.x <= 0) {
      pos.x = 0;
    }
    if (pos.y >= height) {
      pos.y = height;
    } else if (pos.y <= 0) {
      pos.y = 0;
    }
  }
  void flow() {
    //Metodo de asignar la direccion segun la casilla del void
    if (flowfield != null) {
      if (casilla == flowfield.target) {
        if (flowfield.target == destino) {
          flowfield = new FlowField(grid, origen);
        } else {
          flowfield = new FlowField(grid, destino);
        }
      } else {
        TileData tiledata = flowfield.tiles.get(casilla);
        Vector2D direc;
        if (tiledata.LOS==false) {
          direc = new Vector2D(tiledata.direccion);
        } else {
          direc = substract(grid.get(flowfield.target).centro, pos);
        }

        //Prueba
        direc.setUnitVector();
        direc.multiply_by(Obstacle.MAX_VEL);
        //Fin prueba
        this.setVel(direc);
      }
    }
  }

  void dibuja() {
    pushMatrix();
    translate(pos.x, pos.y);
    fill(fillColor);
    circle(0, 0, size);
    popMatrix();
  }

  float dist2(Boid other) {
    Vector2D dist = new Vector2D();
    dist.set(pos);
    dist.substract(other.pos);
    return(dist.getModule());
  }

  float dist2future(Boid other) {
    Vector2D dist = new Vector2D();
    dist.set(futurePos);
    dist.substract(other.futurePos);
    return(dist.getModule());
  }

  public boolean equals(Object obj) {
    if (!(obj instanceof Obstacle)) {
      return false;
    }
    Obstacle obstacle = (Obstacle)obj;
    return this == obstacle;
  }
}
