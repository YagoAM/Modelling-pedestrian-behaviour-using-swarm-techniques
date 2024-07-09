Grid grid;
Input input;
FlockList flocklist;
FlowField ff;

void setup() {
  size(1500, 1000);  //ancho, alto
  grid = new Grid(50); //Validos: 10, 20, 25, 50 y 100
  input = new Input(grid);
  flocklist = new FlockList(grid);
}

void draw() {
  background(0);
  grid.draw();
  if (ff != null) {
    ff.draw();
  }
  
  if (!flocklist.lista.isEmpty()) {
    flocklist.mueve();
    flocklist.interaccion();
    flocklist.dibuja();
    //flocklist.get(0).flowfield.draw();
  }
  if (!flocklist.listaObstaculos.lista.isEmpty()) {
    flocklist.listaObstaculos.mueve();
    flocklist.listaObstaculos.dibuja();
  }
}

void mouseClicked() {
  input.mouseClick();
}

void mouseDragged() {
  input.mouseDrag();
}

void keyPressed() {
  if (key == 't' || key == 'T') {
    if(ff == null){
      ff = new FlowField(grid, new Casilla(mouseX/grid.lado, mouseY/grid.lado));
    } else {
      grid.get(ff.target).colorinchi = #FFFFFF;
      ff = new FlowField(grid, new Casilla(mouseX/grid.lado, mouseY/grid.lado));
    }
  }
  if (key == 'a' || key == 'A') {
    flocklist.add(5, new Vector2D(mouseX, mouseY));
  }
  if (key == 'q' || key == 'Q') {
    flocklist.listaObstaculos.preAdd(new Vector2D(mouseX, mouseY));
  }
}
