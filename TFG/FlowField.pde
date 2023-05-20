import java.util.HashMap; //<>//
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


  /*Constructor*/
  FlowField(Grid gridIn, Casilla targetIn) {
    grid = gridIn;
    terminado = false;
    tiles = new HashMap<Casilla, TileData>();
    if(targetIn == null){
      println("cague"); //<>//
    }
    target = grid.get(targetIn).casilla;
    openSet = new ArrayList<Casilla> ();
    closedSet = new ArrayList<Casilla> ();

    this.calc();
  }

  /*Métodos*/
  void updateGrid() {
    for (int i=0; i<grid.columnas; i++) {
      for (int j=0; j<grid.filas; j++) {
        Tile aux = grid.matrix[i][j];
        tiles.put(aux.casilla, new TileData(aux.pathable, aux.vecinos, aux.centro));
      }
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

          openSet.remove(actual);
          closedSet.add(actual);

          Casilla[] vecinos = tiles.get(actual).vecinos;
          boolean arriba_derecha=false, abajo_derecha=false, abajo_izquierda=false, arriba_izquierda=false;

          //Recorremos los vecinos del ganador
          for (int i=0; i<vecinos.length; i++) {
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
        println("fin");
        terminado= true;
      }
    }
  }

  /*Auxiliar para pruebas*/
  void draw() {
    if(target == null){
      println("cague");
    }
    grid.get(target).colorinchi = #F50202;
    for (Map.Entry<Casilla, TileData> me : tiles.entrySet()) {
      line(me.getValue().centro.x, me.getValue().centro.y, me.getValue().centro.x+(10*me.getValue().direccion.x), me.getValue().centro.y+(10*me.getValue().direccion.y));
    }
  }
  
  TileData get(Casilla in){
    return tiles.get(grid.get(in).casilla);
  }
}

class TileData {
  /*Atributos*/
  boolean pathable;
  Casilla[] vecinos;
  Vector2D centro;
  Vector2D direccion;
  Casilla padre;
  int coste;

  /*Constructor*/
  TileData(boolean pathableIn, Casilla[] vecinosIn, Vector2D centroIn) {
    pathable = pathableIn;
    vecinos = vecinosIn;
    centro = centroIn;
    direccion = new Vector2D();
    coste = 0;
  }
}
