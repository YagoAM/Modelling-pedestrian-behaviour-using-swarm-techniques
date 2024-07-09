interface inputs {
  void mouseClick();  //Clicks del raton
  void mouseDrag();  //Arrastrar el raton (principalmente con algun boton apretado)
  void keyboardPressed();  //Pulsar una tecla
}

class Input implements inputs {
  /*Atributos*/
  Grid grid;
  Casilla casilla;
  Casilla prev_casilla;

  /*Constructor*/
  Input(Grid in_grid) {
    grid = in_grid;
    casilla = new Casilla();
    prev_casilla = new Casilla();
  }

  /*Metodos*/
  void mouseClick() {
    casilla.x = (mouseX/grid.lado);
    casilla.y = (mouseY/grid.lado);

    switch(mouseButton) {
    case LEFT:
      grid.switchPathable(casilla);
      if (grid.muros.contains(grid.matrix[int(casilla.x)][int(casilla.y)].casilla)) {
        grid.muros.remove(grid.matrix[int(casilla.x)][int(casilla.y)].casilla);
      } else {
        grid.muros.add(grid.matrix[int(casilla.x)][int(casilla.y)].casilla);
      }

    case RIGHT:
    }
  }

  void mouseDrag() {
    casilla.x = (mouseX/grid.lado);
    casilla.y = (mouseY/grid.lado);

    switch(mouseButton) {
    case LEFT:
      if (casilla.x!=prev_casilla.x || casilla.y!=prev_casilla.y) {
        if (0 <= casilla.x && casilla.x < grid.columnas && 0 <= casilla.y && casilla.y < grid.filas) {
          grid.switchPathable(casilla);
          if (grid.muros.contains(grid.matrix[int(casilla.x)][int(casilla.y)].casilla)) {
            grid.muros.remove(grid.matrix[int(casilla.x)][int(casilla.y)].casilla);
          } else {
            grid.muros.add(grid.matrix[int(casilla.x)][int(casilla.y)].casilla);
          }
        }
      }
    }
    prev_casilla.x=casilla.x;
    prev_casilla.y=casilla.y;
  }

  void keyboardPressed() {
  }
}
