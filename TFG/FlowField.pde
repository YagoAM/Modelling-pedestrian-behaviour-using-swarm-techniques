import java.util.HashMap; //<>// //<>//
import java.util.Map;

interface fields {
}

class FlowField implements fields {
  /*Atributos*/
  Grid grid;
  boolean terminado;
  HashMap<Casilla, TileData> tiles;
  Casilla target;
  ArrayList<Casilla> openSet;
  ArrayList<Casilla> closedSet;
  //Analyzer analizador; //debuging


  /*Constructor*/
  FlowField(Grid gridIn, Casilla targetIn) {
    grid = gridIn;
    terminado = false;
    tiles = new HashMap<Casilla, TileData>();
    if (targetIn == null) {
      println("cague");
    }
    target = grid.get(targetIn).casilla;
    openSet = new ArrayList<Casilla> ();
    closedSet = new ArrayList<Casilla> ();
    //analizador = new Analyzer(grid, target);

    this.calc();
  }

  /*Métodos*/
  void recalc(){
    this.calc();
  }
  
  void updateGrid() {
    for (int i=0; i<grid.columnas; i++) {
      for (int j=0; j<grid.filas; j++) {
        Tile aux = grid.matrix[i][j];
        tiles.put(aux.casilla, new TileData(aux.pathable, aux.vecinos, aux.centro));
      }
    }
  }

  void calcLOS() {
    //Método de recorrer el borde
    for (int i = 0; i < grid.columnas; i++) {
      BresenhamBorde(target, new Casilla(i, 0));
      BresenhamBorde(target, new Casilla(i, grid.filas-1));
    }
    for (int i = 0; i < grid.filas; i++) {
      BresenhamBorde(target, new Casilla(0, i));
      BresenhamBorde(target, new Casilla(grid.columnas-1, i));
    }/***/

    //Metodo de recorrer los muros
    /*for (int i=0; i<grid.columnas; i++) {
     for (int j=0; j<grid.filas; j++) {
     if (grid.matrix[i][j].pathable == true) {
     grid.matrix[i][j].LOS = true;
     grid.matrix[i][j].colorinchi = #FAE360;
     }
     }
     }
     for (Casilla muro : grid.muros) {
     BresenhamMuro(target, muro);
     }/**/
  }

  void BresenhamMuro(Casilla target, Casilla other) {
    int x0 = target.x, y0 = target.y;
    int x1 = other.x, y1 = other.y;
    int dx = x1-x0, dy = y1-y0;
    int x, y;
    int constPPositive, constPNegative, p, stepX, stepY;
    boolean LOS = true;

    //Definir cuadrantes
    if (dy<0) {
      dy = -dy;
      stepY = -1;
    } else {
      stepY = 1;
    }
    if (dx<0) {
      dx = -dx;
      stepX = -1;
    } else {
      stepX = 1;
    }
    x = x0;
    y = y0;
    setLOS(x, y, LOS);

    //Definir que eje va a avanzar de forma unitaria
    if (dx>dy) {
      p = 2*dy-dx;
      constPNegative = 2*dy;
      constPPositive = 2*(dy-dx);
      while (x > 0 && x < grid.columnas) {
        x += stepX;
        if (p<0) {
          p += constPNegative;
        } else {
          y += stepY;
          p += constPPositive;
        }
        if (grid.get(new Casilla(x, y)).pathable == false) {
          LOS = false;
        }
        setLOS(x, y, LOS);
      }
    } else {
      p = 2*dx-dy;
      constPNegative = 2*dx;
      constPPositive = 2*(dx-dy);
      while (y > 0 && y < grid.filas) {
        y += stepY;
        if (p<0) {
          p += constPNegative;
        } else {
          x += stepX;
          p += constPPositive;
        }
        if (grid.get(new Casilla(x, y)).pathable == false) {
          LOS = false;
        }
        setLOS(x, y, LOS);
      }
    }
  }

  void BresenhamBorde(Casilla target, Casilla other) {
    int x0 = target.x, y0 = target.y;
    int x1 = other.x, y1 = other.y;
    int dx = x1-x0, dy = y1-y0;
    int x, y;
    int constPPositive, constPNegative, p, stepX, stepY;
    boolean LOS = true;
    boolean auxiliar = false;

    //Definir cuadrantes
    if (dy<0) {
      dy = -dy;
      stepY = -1;
    } else {
      stepY = 1;
    }
    if (dx<0) {
      dx = -dx;
      stepX = -1;
    } else {
      stepX = 1;
    }
    x = x0;
    y = y0;
    setLOS(x, y, LOS);

    //Definir que eje va a avanzar de forma unitaria
    if (dx>dy) {
      p = 2*dy-dx;//2
      constPNegative = 2*dy;//14
      constPPositive = 2*(dy-dx);//-10
      while (x != x1) {
        x += stepX;
        if (p<0) {
          p += constPNegative;
        } else {
          y += stepY;
          p += constPPositive;
        }
        //analizador.set(x, y);
        //analizador.draw();
        //println(x, ",", y);

        if (grid.get(new Casilla(x, y)).pathable == false) {
          LOS = false;
        }
        setLOS(x, y, LOS);/*Comentar si SÍ quieres que se analice el nearWall*/
        /*if (grid.get(new Casilla(x, y)).nearWall == true) {
          auxiliar = true;
        } else if (auxiliar == true){
          LOS = false;
        }/**/
      }
    } else {
      p = 2*dx-dy;
      constPNegative = 2*dx;
      constPPositive = 2*(dx-dy);
      while (y != y1) {
        y += stepY;
        if (p<0) {
          p += constPNegative;
        } else {
          x += stepX;
          p += constPPositive;
        }
        //analizador.set(x, y);
        //analizador.draw();
        //println(x, ",", y);

        if (grid.get(new Casilla(x, y)).pathable == false) {
          LOS = false;
        }
        setLOS(x, y, LOS);
        /*if (grid.get(new Casilla(x, y)).nearWall == true) {
          auxiliar = true;
        } else if (auxiliar == true){
          LOS = false;
        }/**/
      }
    }
  }

  void setLOS(int inX, int inY, Boolean LOS) {
    setLOS(new Casilla(inX, inY), LOS);
  }

  void setLOS(Casilla in, Boolean LOS) {
    if (LOS != true) {
      tiles.get(grid.get(in).casilla).LOS = false;
    }
  }

  void calc() {
    updateGrid();
    terminado = false;
    openSet.clear();
    closedSet.clear();

    openSet.add(target);

    while (terminado == false) {

      //SEGUIMOS SI HAY AlGO EN OPENSET
      if (!openSet.isEmpty()) {
        int ganador = 0; //indice del array openSet del ganador (menor coste f)

        for (int i=0; i<openSet.size(); i++) { //buscamos en el open list el de menos coste f
          if (tiles.get(openSet.get(i)).coste < tiles.get(openSet.get(ganador)).coste) {
            ganador = i;
          }
        }

        Casilla actual = openSet.get(ganador);

        if (true) {
          //SUPONEMOS QUE TODAS LOS TILES TIENEN LINEA DE VISION DIRECTA, PARA QUE AL HACER EL 
          tiles.get(actual).LOS = true;

          openSet.remove(actual);
          closedSet.add(actual);

          Casilla[] vecinos = tiles.get(actual).vecinos;
          boolean arriba_derecha=false, abajo_derecha=false, abajo_izquierda=false, arriba_izquierda=false;

          //Recorremos los vecinos del ganador
          for (int i=0; i<vecinos.length; i++) {
            //if(i>=4){continue;}//Activar para solo tener las cuatro direcciones principales posibles
            Casilla vecino = vecinos[i];

            if (vecino!=null && tiles.get(vecino).pathable==false) {
              if (i==0) {
                arriba_derecha=true;
                abajo_derecha=true;
              }
              if (i==1) {
                abajo_derecha=true;
                abajo_izquierda=true;
              }
              if (i==2) {
                abajo_izquierda=true;
                arriba_izquierda=true;
              }
              if (i==3) {
                arriba_izquierda=true;
                arriba_derecha=true;
              }
            }

            if (i==4 && abajo_derecha) {
              continue;
            }
            if (i==5 && abajo_izquierda) {
              continue;
            }
            if (i==6 && arriba_izquierda) {
              continue;
            }
            if (i==7 && arriba_derecha) {
              continue;
            }


            if (vecino!=null && !closedSet.contains(vecino) && tiles.get(vecino).pathable==true) {
              int tempG;
              if (i>=4) {
                tempG = tiles.get(actual).coste + 14;
              } else {
                tempG = tiles.get(actual).coste + 10;
              }


              if (openSet.contains(vecino)) {
                if (tempG<tiles.get(vecino).coste) {
                  tiles.get(vecino).coste = tempG;
                } else {
                  continue;
                }
              } else {
                tiles.get(vecino).coste = tempG;
                openSet.add(vecino);
              }

              tiles.get(vecino).padre = actual;
              Casilla padre = new Casilla(tiles.get(vecino).padre);
              tiles.get(vecino).direccion.set(padre.x-vecino.x, padre.y-vecino.y);
            }
          }
        }
      } else {
        //SE CALCULA LOS TILES CON LINEA DE VISION DIRECTA (MAS BIEN SE CALCULA LOS QUE NO TIENEN LINEA DE VISION DIRECTA)
        calcLOS();
        println("fin");
        terminado= true;
      }
    }
  }

  /*Auxiliar para pruebas*/
  void draw() {
    if (target == null) {
      println("cague");
    }
    grid.get(target).colorinchi = #F50202;
    for (Map.Entry<Casilla, TileData> me : tiles.entrySet()) {
      line(me.getValue().centro.x, me.getValue().centro.y, me.getValue().centro.x+(10*me.getValue().direccion.x), me.getValue().centro.y+(10*me.getValue().direccion.y));
    }
  }

  TileData get(Casilla in) {
    return tiles.get(grid.get(in).casilla);
  }
}

class TileData {
  /*Atributos*/
  boolean pathable;
  boolean LOS;
  Casilla[] vecinos;
  Vector2D centro;
  Vector2D direccion;
  Casilla padre;
  int coste;

  /*Constructor*/
  TileData(boolean pathableIn, Casilla[] vecinosIn, Vector2D centroIn) {
    pathable = pathableIn;
    LOS = true;
    vecinos = vecinosIn;
    centro = centroIn;
    direccion = new Vector2D();
    coste = 0;
  }
}

class Analyzer {
  //Atributos
  Grid grid;
  boolean dibujar = true;
  Vector2D pos;
  Casilla casilla;

  Analyzer(Grid inGrid, Casilla inicial) {
    grid = inGrid;
    casilla = inicial;
    pos = grid.get(casilla).centro;
  }

  void set(int x, int y) {
    casilla = new Casilla(x, y);
    pos = grid.get(casilla).centro;
  }

  void draw() {
    fill(#17CAFA);
    circle(pos.x, pos.y, 20);
  }
}
