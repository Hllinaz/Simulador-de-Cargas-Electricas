class Objeto {
  protected boolean inf;

  protected float qMax;
  protected float qMin;
  protected int tipo;

  protected PVector pos;


  protected float largo;
  protected float ancho;
  protected float altura;
  protected float dCarga;
  protected float q;

  protected float pasos = 50;
  protected float pasosA;
  protected float pasosL;

  protected boolean campo = true;

  Objeto() {
  }

  Objeto(float l, float a, float h, float q) {
    this.largo = l;
    this.ancho = a;
    this.altura = h;
    this.q = q * nC;
  }

  void Display() {
  }

  PVector Campo(PVector pos, PVector punto) {
    return null;
  }

  PVector Campo(PVector punto) {
    return null;
  }

  float Potencial(PVector pos, PVector punto) {
    return 0.0;
  }

  float Potencial(PVector punto) {
    return 0.0;
  }
}


class Cable extends Objeto {
  int numLados = 20;
  float radio = 5;

  Cable(float l, float q, PVector pos) {
    this.pos = pos;
    this.largo = l;
    this.q = q * nC;
    this.qMax = q * nC;
    this.qMin = q * nC;
    this.tipo = 0;
    this.inf = true;
  }

  Cable(float l, float qMax, float qMin, PVector pos) {
    this.pos = pos;
    this.largo = l;
    this.qMax = qMax * nC;
    this.qMin = qMin * nC;
    this.tipo = 1;
    this.inf = false;
  }

  @Override
    void Display() {
    pushMatrix();
    translate(pos.x, pos.y, pos.z);
    cable(radio, largo, numLados);
    popMatrix();

    if (campo & !c) dibujarCampo();
  }

  @Override
    PVector Campo(PVector pos, PVector punto) {

    PVector direccion = PVector.sub(punto, pos);
    float distancia = direccion.mag() * p;

    if (distancia < 1) distancia = 1;

    direccion.normalize();

    float carga = carga(pos.x);

    float magnitudCampo = (k * carga) / (distancia * distancia);

    return direccion.mult(magnitudCampo);
  }

  @Override
    PVector Campo(PVector punto) {
    PVector campoTotal = new PVector(0, 0, 0);
    PVector tempCampo = new PVector();

    float lMedia = largo / 2;

    for (float x = - lMedia; x <= lMedia; x += pasos) {
      tempCampo.set(x, cable.pos.y, cable.pos.z);
      PVector campo = cable.Campo(tempCampo, punto);
      campoTotal.add(campo);
    }

    return campoTotal;
  }

  float carga(float x) {
    float xNorma = x / (largo / 2);

    switch(tipo) {
    case 1:
      return map(xNorma, -1, 1, qMin, qMax); //Carga Lineal
    case 2:
      return qMax * (xNorma * xNorma); //Carga cuadratica
    case 3:
      return qMax * sin(TWO_PI * xNorma); //Carga sinuoidal
    }

    return q; //Carga constante
  }

  void dibujarCampo() {
    for (float x = - largo / 2; x <= largo / 2; x += pasos) {
      boolean cargaNegativa = carga(x) < 0;

      for (int i = 0; i < numTheta; i++) {
        float theta = map(i, 0, numTheta, 0, TWO_PI); // Ángulo theta de 0 a 2π

        for (int j = 0; j < numPhi; j++) {
          float phi = map(j, 0, numPhi, 0, PI); // Ángulo phi de 0 a π

          float y = radio * sin(phi) * sin(theta);
          float z = radio * cos(phi);

          curvaCampo(new PVector(x, y, z).add(pos), cargaNegativa);
        }
      }
    }
  }

  void curvaCampo(PVector puntoInicial, boolean cargaNegativa) {
    PVector puntoActual = puntoInicial.copy();
    PVector campoTotal = new PVector(0, 0, 0);

    beginShape();
    for (int i = 0; i <= 25; i ++) {

      campoTotal.add(campoTotal(puntoActual));

      campoTotal.normalize();

      if (cargaNegativa) {
        campoTotal.mult(-1);
      }

      PVector puntoAnterior = puntoActual.copy();

      // Avanzar en la dirección del campo eléctrico
      puntoActual.add(PVector.mult(campoTotal, 5)); // Paso ajustable (5 píxeles en este caso)

      // Dibujar la línea entre el punto anterior y el actual
      noFill();
      stroke(150, 70);
      vertex(puntoAnterior.x, puntoAnterior.y, puntoAnterior.z);
    }

    endShape();
  }

  void cable(float r, float l, int lados) {
    float anguloIncremento = TWO_PI / lados;
    noStroke();
    fill(150);
    // Dibujamos la tapa izquierda del cilindro
    beginShape(TRIANGLE_FAN);
    vertex(-l / 2, pos.y, pos.z);  // Centro de la tapa izquierda
    for (float angulo = 0; angulo <= TWO_PI + anguloIncremento; angulo += anguloIncremento) {
      vertex(-l / 2, r * cos(angulo), r * sin(angulo));
    }
    endShape();

    // Dibujamos la tapa derecha del cilindro
    beginShape(TRIANGLE_FAN);
    vertex(l / 2, pos.y, pos.z);  // Centro de la tapa derecha
    for (float angulo = 0; angulo <= TWO_PI + anguloIncremento; angulo += anguloIncremento) {
      vertex(l / 2, r * cos(angulo), r * sin(angulo));
    }
    endShape();

    // Dibujamos las paredes laterales del cilindro
    beginShape(QUAD_STRIP);
    for (float angulo = 0; angulo <= TWO_PI + anguloIncremento; angulo += anguloIncremento) {
      float y = r * cos(angulo);
      float z = r * sin(angulo);
      vertex(-l / 2, y + pos.y, z + pos.z);  // Punto en la tapa izquierda
      vertex(l / 2, y + pos.y, z + pos.z);   // Punto en la tapa derecha
    }
    endShape();
  }
}

class Placa extends Objeto {
  float pasos_ = 4.5;

  float pasosL;
  float pasosA;

  Placa(float l, float a, float q, PVector pos) {
    this.pos = pos;

    this.largo = l;
    this.ancho = a;
    this.altura = 1;

    this.q = q * nC;
    this.qMax = q * nC;
    this.qMin = q * nC;
    this.dCarga = q  / (a * l);

    this.tipo = 0;
    this.pasos = 144;
    this.pasosL = largo / pasos_;
    this.pasosA = ancho / pasos_;

    this.inf = false;
  }

  @Override
    void Display() {
    if(q != 0)placa(ancho, largo);

    if (campo & !c) dibujarCampo();
  }

  @Override
    PVector Campo(PVector pos, PVector punto) {
    PVector direccion = PVector.sub(punto, pos);
    float distancia = direccion.mag() * p;

    if (distancia < 1) distancia = 1;

    direccion.normalize();

    float magnitudCampo;
    if (inf) {
      magnitudCampo = dCarga / (2 * Eo);

      if (punto.y > pos.y) {
        direccion = new PVector(0, 1, 0); // Campo apunta hacia arriba
      } else if (punto.y < pos.y) {
        direccion = new PVector(0, -1, 0); // Campo apunta hacia abajo
      } else {
        direccion = new PVector(0, 0, 0); // Campo es cero en el plano de la placa
      }
    } else {
      magnitudCampo = (k * q) / (distancia * distancia);
    }

    return direccion.mult(magnitudCampo);
  }

  @Override
    PVector Campo(PVector punto) {
    PVector campoTotal = new PVector(0, 0, 0);
    PVector tempCampo = new PVector();

    for (float x = - ancho / 2; x <= ancho / 2; x += pasos) {
      for (float z = - largo/ 2; z <= largo/ 2; z += pasos) {
        tempCampo.set(x, pos.y, z);
        PVector campo = Campo(tempCampo, punto);
        campoTotal.add(campo);
      }
    }
    return campoTotal;
  }

  void dibujarCampo() {
    boolean cargaNegativa = q < 0;
    float[] rango = camara.estimarCampo();

    for (float x = - ancho / 2; x <= (ancho / 2); x += pasosA) {

      for (float y = -100; y <= 100; y += pasos) {

        for (float z = - largo / 2; z <= (largo/ 2); z += pasosL) {

          curvaCampo(new PVector(x, y, z).add(pos), cargaNegativa, rango);
        }
      }
    }
  }

  void curvaCampo(PVector puntoInicial, boolean cargaNegativa, float[] rango) {
    PVector puntoActual = puntoInicial.copy();
    PVector campoTotal = new PVector(0, 100, 0);
    
    float cMin = rango[0];
    float cMax = rango[1];
    
    beginShape();
    for (int i = 0; i <= 150; i ++) {
      campoTotal.set(0, 0, 0);

      campoTotal.add(campoTotal(puntoActual));
      
      color Color = colorCampo(cMin, campoTotal.mag(), cMax);
      
      stroke(Color);

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
  @Override
    float Potencial(PVector punto) {
    float voltaje = 0;
    PVector tempPos = new PVector();

    for (float x = - ancho / 2; x <= ancho / 2; x += pasosA) {
      tempPos.set(x, 0, 0).add(pos);
      voltaje += Potencial(tempPos, punto);
    }

    return voltaje;
  }

  @Override
    float Potencial(PVector pos, PVector punto) {
    float distancia = PVector.dist(punto, pos);
    float dq = dCarga * pasosA * pasosL;

    if (distancia == 0) {
      return 0; // O manejarlo según corresponda
    }

    return (k * dq) / distancia;
  }

  void placa(float ancho, float largo) {

    pushMatrix();
    noStroke();
    fill(240);
    translate(pos.x, pos.y, pos.z);
    box(ancho, altura, largo);
    popMatrix();
  }
}

class Anillo extends Objeto {
  float R;
  float r;
  float pasos = 5;

  Anillo(float R, float q, PVector pos) {
    this. R = R;
    this.pos = pos;
    this.q = q * nC;
    creator =  new HEC_Torus(5, R, 64, 32);
  }
  
  @Override
    void Display() {
    
    if (campo & !c) dibujarCampo();  
      
    pushMatrix();
    noStroke();
    fill(150);
    translate(pos.x, pos.y, pos.z);
    rotateY(PI / 2);
    render.drawFaces(mesh);
    render.drawEdges(mesh);
    popMatrix();
  }

  @Override
    PVector Campo(PVector pos, PVector punto) {
    PVector direccion = PVector.sub(punto, pos);
    float distancia = direccion.mag() * p;

    if (distancia < 1) distancia = 1;

    direccion.normalize();

    float magnitudCampo = (k * q) / (distancia * distancia);

    return direccion.mult(magnitudCampo);
  }

  @Override
    PVector Campo(PVector punto) {
    PVector campoTotal = new PVector(0, 0, 0);
    PVector tempCampo = new PVector();

    for (int i = 0; i < pasos; i++) {
      float theta = map(i, 0, pasos, 0, TWO_PI); 

      float y = R * cos(theta);  
      float z = R * sin(theta);  
      
      tempCampo.set(anillo.pos.x, y, z);


      campoTotal.add(anillo.Campo(tempCampo, punto));
    }

    return campoTotal;
  }

  void dibujarCampo() {
    boolean cargaNegativa = q < 0;
    
    for (int i = 0; i < numTheta; i++) {
      float theta = map(i, 0, numTheta, 0, TWO_PI); 

      float y = radio * cos(theta);  
      float z = radio * sin(theta);  
      
      curvaCampo(new PVector(0, y, z).add(pos), cargaNegativa);
    }

  }

  void curvaCampo(PVector puntoInicial, boolean cargaNegativa) {
    PVector puntoActual = puntoInicial.copy();
    PVector campoTotal = new PVector(0, 100, 0);

    beginShape();
    for (int i = 0; i <= 100; i ++) {
      campoTotal.set(0, 0, 0);

      campoTotal.add(campoTotal(puntoActual));

      campoTotal.normalize();

      if (cargaNegativa) {
        campoTotal.mult(-1);
      }

      PVector puntoAnterior = puntoActual.copy();

      // Avanzar en la dirección del campo eléctrico
      puntoActual.add(PVector.mult(campoTotal, 5)); // Paso ajustable (5 píxeles en este caso)

      // Dibujar la línea entre el punto anterior y el actual
      noFill();
      stroke(150, 70);
      vertex(puntoAnterior.x, puntoAnterior.y, puntoAnterior.z);
    }

    endShape();
  }




  
}
