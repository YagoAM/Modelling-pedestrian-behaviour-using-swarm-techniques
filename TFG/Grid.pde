interface grid_interface {
  void draw();
  Tile get(Casilla in);
  void calcVecinos();
  void switchPathable(Casilla in);
}

class Grid implements grid_interface {
  /*Atributos*/
  Tile[][] matrix;
  ArrayList <Casilla> muros;
  int dir[][] = {{1, 0}, {0, 1}, {-1, 0}, {0, -1}, {1, 1}, {-1, 1}, {-1, -1}, {1, -1}}; //8 dirs orden: derecha, abajo, izquierda y arriba
  int columnas;  //Columnas == Ancho == X == width
  int filas;  //Filas == Alto == Y == height
  int lado;  //Lado de la casilla

  /*Constructores*/
  Grid(int columnas_aux, int filas_aux) {
  }  //ATENCION: ESTE CONSTRUCTOR ESTA A MEDIAS, SE RETOMARA CUANDO DECIDA COMO HACERLO PARA UN NUMERO DE FILAS Y COLUMNAS, EL QUE SE USARA ACTUALMENTE ES INDICANDO EL LADO

  Grid(int in) {  //Es importante aclarar con este constructor que el lado quese use tiene que ser divisor TANTO del Ancho como del Alto
    lado = in;
    columnas = width / lado;
    filas = height / lado;
    matrix = new Tile[columnas][filas];
    muros = new ArrayList <Casilla> ();

    Casilla casilla = new Casilla();

    for (int i=0; i<columnas; i++) {
      for (int j=0; j<filas; j++) {
        matrix[i][j] = new Tile(casilla, lado);
        if (j==filas-1) {
          casilla.y=0;
        } else {
          casilla.y+=1;
        }
      }
      casilla.x+=1;
    }

    calcVecinos();
  }

  /*Metodos*/
  void draw() {
    for (int i=0; i<columnas; i++) {
      for (int j=0; j<filas; j++) {
        matrix[i][j].draw();
      }
    }
  }

  Tile get(Casilla in) {
    int x, y;
    
    if(in == null){
      println("cague");
    }
    if(in.x < 0){
      x = 0;
    } else if(in.x > columnas){
      x = columnas;
    } else{
      x = in.x;
    }
    if(in.y < 0){
      y = 0;
    } else if(in.y > filas){
      y = filas;
    } else{
      y = in.y;
    }
    return matrix[x][y];
  }

  void calcVecinos() {
    for (int i=0; i<columnas; i++) {
      for (int j=0; j<filas; j++) {
        Casilla[] _vecinos = new Casilla[8];
        for (int n=0; n<dir.length; n++) {
          int _i=i+dir[n][0];
          int _j=j+dir[n][1];
          if (-1<_i && _i<columnas && -1<_j && _j<filas) {
            _vecinos[n] = matrix[_i][_j].casilla;
          } else {
            _vecinos[n] = null;
          }
        }
        matrix[i][j].setVecinos(_vecinos);
      }
    }
  }

  void switchPathable(Casilla in) {
    matrix[in.x][in.y].switchPathable();
  }
}
