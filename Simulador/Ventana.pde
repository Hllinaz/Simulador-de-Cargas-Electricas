class VentanaS {
  void Inicio(PApplet a) {
    a.fill(0);
    a.textSize(16);
    a.text("Interfaz 2D", a.width / 2, 30);
  }

  void Insertar(PApplet a) {
    int xi = 100;
    int yi = 100;

    //Malla
    a.stroke(0);
    a.strokeWeight(2);
    a.fill(255);
    a.rect(xi, yi, 500, 500);

    a.stroke(150, 50);
    a.fill(0);
    a.strokeWeight(1);
    int j = -10;
    for (int i = 0; i <= 500; i += 25) {
      a.line(xi, yi + i, xi + 500, yi + i);
      a.line(xi + i, yi, xi + i, yi + 500);


      a.textSize(12);
      a.text(j, xi + i - 4, yi + 520);
      j++;
    }

    a.strokeWeight(2);
    a.stroke(0, 50);
    for (int i = 0; i <= 500; i += 50) {
      a.line(xi, yi + i, xi + 500, yi + i);
      a.line(xi + i, yi, xi + i, yi + 500);
    }

    a.strokeWeight(2);
    a.stroke(0, 255, 0);
    a.line(xi + 250, yi, xi + 250, yi + 500);

    a.stroke(255, 0, 0);
    a.line(xi, yi + 250, xi + 500, yi + 250);

    a.textSize(20);
    a.text("y", xi + 246, yi - 4);
    a.text("x", xi + 504, yi + 254);
    
    a.textSize(20);
    a.text(Tiempo(), xi + 440, yi + 490);

    //Particulas
    int xf = 650;
    int yf = 100;
    a.stroke(0);
    a.strokeWeight(2);
    a.fill(255);
    a.rect(xf, yf, 300, 500, 10);

    int y_ = 0;
    for (Particula p : particula) {
      a.fill(51, 50);
      a.noStroke();
      a.rect(xf + 10, yf + 10 + y_, 280, 50, 10);

      a.fill(0);
      a.text("Particula " + p.i, xf + 20, yf + 40 + y_);
      a.text(nC + "C", xf + 180, yf + 40 + y_);

      if (!p.texto.getText().trim().isEmpty()) p.q = Float.parseFloat(p.texto.getText().trim()) * nC;


      y_ += 60;

      p.Display(a);

      if (p.arrastrando & Colision(malla)) {
        p.pos_.set((a.mouseX - p.offset.x), (a.mouseY - p.offset.y));
        p.norma.set((a.mouseX - p.offset.x), (a.mouseY - p.offset.y));

        p.pos.set(p.norma.x * escala, p.norma.y * escala);
        p.colision.pos.set(p.norma.x - 7.5 + p.r, p.norma.y - 7.5 + p.r);

        p.c = color(0, 255, 0);
      } else {
        p.c = p.q > 0 ? color(0) : color(255, 0, 0);
      }

      if (!p.selected) {
        p.c = p.q > 0 ? color(0) : color(255, 0, 0);
      } else {
        p.c = color(0, 255, 0);
      }
    }
  }
}
