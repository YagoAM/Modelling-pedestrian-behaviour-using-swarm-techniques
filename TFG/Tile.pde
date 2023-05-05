interface tile_interface {
  void switchPathable();  //Cambia de camino a muro y viceversa
  void draw();  //Función basica de dibujado
  void setVecinos(Casilla[] in);  //Establece los vecinos que tiene dentro de un Grid
}

class Tile implements tile_interface {
  /*Atributos*/
  Casilla casilla;
  Vector2D centro;  //Centro, se usara para la separacaion de los boids con los muros, y para las flechas
  Vector2D up_left;  //Vertice arriba izquierda, se utiliza para dibujar el cuadrado
  Vector2D up_right, down_left, down_right;
  Casilla[] vecinos;  //Referencias a las Casillas de los Tiles vecinos
  int dir[][] = {{1, 0}, {1, 1}, {0, 1}, {-1, 1}, {-1, 0}, {-1, -1}, {0, -1}, {1, -1}};  //Direcciones en las que se evaluaran los vecinos
  int lado;  //Lado del cuadrado
  boolean pathable;  //True puede pasar, False es pared
  color colorinchi;  //Color del cuadrado, blanco = camino, negro = muro, rojo = target, verde = origen (si aplica)

  /*Constructores*/
  Tile() {
    casilla = new Casilla();
    centro = new Vector2D();
    up_left = new Vector2D();
    up_right = new Vector2D();
    down_left = new Vector2D();
    down_right = new Vector2D();
    lado = 0;
    pathable = true;
    colorinchi = color(255);
  }
  Tile(Casilla in, int lado_aux) {
    casilla = new Casilla(in);
    centro = new Vector2D((in.x*lado_aux)+lado_aux/2, (in.y*lado_aux)+lado_aux/2);
    up_left = new Vector2D(in.x*lado_aux, in.y*lado_aux);
    up_right = new Vector2D(in.x*lado_aux+lado_aux, in.y*lado_aux);
    down_left = new Vector2D(in.x*lado_aux, in.y*lado_aux+lado_aux);
    down_right = new Vector2D(in.x*lado_aux+lado_aux, in.y*lado_aux+lado_aux);
    lado = lado_aux;
    pathable = true;
    colorinchi = color(255);
  }

  /*Metodos*/
  void switchPathable() {
    if (pathable == true) {
      pathable = false;
      colorinchi = color(50);
    } else {
      pathable = true;
      colorinchi = color(255);
    }
  }
  void draw() {
    fill(colorinchi);
    square(up_left.x, up_left.y, lado);
  }
  void setVecinos(Casilla[] in) {
    vecinos = in;
  }
}

class Casilla {
  /*Atributos*/
  int x;
  int y;

  /*Constructores*/
  Casilla() {
    x=0;
    y=0;
  }
  Casilla(int in_x, int in_y) {
    x=in_x;
    y=in_y;
  }
  Casilla(Casilla in) {
    x=in.x;
    y=in.y;
  }
}
