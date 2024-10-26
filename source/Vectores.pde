class Vector {
  Particula p;
  float r = 7.5;

  float radioCono = 2;
  float alturaCono = 5;

  Vector(Particula p) {
    this.p = p;
  }

  void Display() {
    // Dibujar el vector de fuerza en 3D
    vectorFuerza();
    
    if(e & p.fuerza & p.estatico) return;
    pushMatrix();
    stroke(0);
    strokeWeight(2);
    line(p.pos.x, p.pos.y, p.pos.z,
      p.pos.x + p.fuerzaE.x * f, // Escalar para visualización
      p.pos.y + p.fuerzaE.y * f,
      p.pos.z + p.fuerzaE.z * f);
    popMatrix();
    
  }

  void Display(PApplet a) {
    a.stroke(0);
    a.strokeWeight(2);
    a.line(p.pos_.x + r, p.pos_.y + r,
      p.pos_.x + (p.fuerzaE.x * f_) + r,
      p.pos_.y + (p.fuerzaE.y * f_) + r);
  }

  void vectorFuerza() {       
    PVector campoTotal = new PVector(0, 0, 0);

      campoTotal.add(campoTotal(p.pos));
      
      p.fuerzaE = campoTotal.mult(p.q);
    
  }

  void dibujarCampo() {
    boolean cargaNegativa = p.q < 0;
    float[] rango = camara.estimarCampo();

    for (int i = 0; i < numTheta; i++) {
      float theta = map(i, 0, numTheta, 0, TWO_PI); // Ángulo theta de 0 a 2π

      for (int j = 0; j < numPhi; j++) {
        float phi = map(j, 0, numPhi, 0, PI); // Ángulo phi de 0 a π

        float x = radio * sin(phi) * cos(theta);
        float y = radio * sin(phi) * sin(theta);
        float z = radio * cos(phi);

        curvaCampo(new PVector(x, y, z).add(p.pos), cargaNegativa, rango);
      }
    }
  }

  void curvaCampo(PVector puntoInicial, boolean cargaNegativa, float[] rango) {
    PVector puntoActual = puntoInicial.copy();
    PVector campoTotal = new PVector(0, 0, 0);    
    
    float cMin = rango[0];
    float cMax = rango[1];
    
    beginShape();
    for (int i = 0; i <= 100; i ++) {
      campoTotal.set(0, 0, 0);

      campoTotal.add(campoTotal(puntoActual));
      
      color Color = colorCampo(cMin, campoTotal.mag(), cMax);
      
      stroke(Color, campoTotal.mag() * 0.05);

      campoTotal.normalize();

      if (cargaNegativa) {
        campoTotal.mult(-1);
      }

      PVector puntoAnterior = puntoActual.copy();

      // Avanzar en la dirección del campo eléctrico
      puntoActual.add(PVector.mult(campoTotal, 5)); // Paso ajustable (5 píxeles en este caso)

      // Dibujar la línea entre el punto anterior y el actual
      noFill();
      
      vertex(puntoAnterior.x, puntoAnterior.y, puntoAnterior.z);
    }
    endShape();
  }
}
