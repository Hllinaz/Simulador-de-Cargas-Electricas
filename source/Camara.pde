class Camara {
  PVector cameraPosition, cameraTarget, cameraUp;
  float moveSpeed = 10;
  float angleY = 0, angleX = 0;  // Para controlar la rotación de la vista

  float paso = 27;
  float xMin = -500;
  float xMax = 500;
  float yMin = -500;
  float yMax = 500;
  float zMin = 0;
  float zMax = 0;

  Camara() {
    // Inicializar la posición de la cámara y el objetivo (hacia donde mira)
    cameraPosition = new PVector(0, 0, 200);  // Iniciar cámara en Z=200
    cameraTarget = new PVector(0, 0, 0);      // Mirando al origen
    cameraUp = new PVector(0, 1, 0);          // El "arriba" de la cámara es el eje Y
  }

  void drawWorld() {
    // Dibujar una cuadrícula para tener referencia
    pushMatrix();
    translate(0, 0, 0);

    strokeWeight(2);
    stroke(0, 50);
    for (int i = -500; i <= 500; i += 100) {
      line(i, xMin, 0, i, xMax, 0);  // Líneas en X
      line(yMin, i, 0, yMax, i, 0);  // Líneas en y
    }

    strokeWeight(1);
    stroke(150, 50);
    for (int i = -500; i <= 500; i += 25) {
      line(i, xMin, 0, i, xMax, 0);  // Líneas en X
      line(yMin, i, 0, yMax, i, 0);  // Líneas en y
    }

    strokeWeight(2);

    //Eje x
    stroke(255, 0, 0);
    line(- 500, 0, 0, 500, 0, 0);
    
    //Eje y
    stroke(0, 255, 0);
    line(0, - 500, 0, 0, 500, 0);

    //Eje z
    stroke(0, 0, 255);
    line(0, 0, -500, 0, 0, 500);

    textSize(20);
    text("x", 500, 0, 0);
    text("y", 0, -500, 0);
    text("z", 0, 0, 500);
    popMatrix();

    if (c) dibujarCampo();
    if (v) dibujarEquipotenciales();
  }

  // Actualizar la posición y dirección de la cámara
  void updateCamera() {
    // Control de rotación de la cámara con el ratón
    if (mousePressed) {
      angleY += (mouseX - pmouseX) * 0.005;  // Rotar en eje Y
      angleX += (mouseY - pmouseY) * 0.005;  // Rotar en eje X
    }

    // Crear el vector de dirección a partir de los ángulos de rotación
    PVector direction = new PVector(
      cos(angleY) * cos(angleX),
      sin(angleX),
      sin(angleY) * cos(angleX)
      );

    // Actualizar el objetivo de la cámara
    cameraTarget = PVector.add(cameraPosition, direction);

    // Configurar la cámara usando `camera()`
    camera(cameraPosition.x, cameraPosition.y, cameraPosition.z, // Posición de la cámara
      cameraTarget.x, cameraTarget.y, cameraTarget.z, // A dónde mira la cámara
      cameraUp.x, cameraUp.y, cameraUp.z);                   // El vector "arriba" de la cámara

    // Movimiento de la cámara con el teclado
    if (keyPressed) {
      switch(key) {
      case 'w':

        cameraPosition.add(PVector.mult(direction, moveSpeed));  // Avanzar
        break;
      case 's':
        cameraPosition.sub(PVector.mult(direction, moveSpeed));  // Retroceder
        break;
      case 'a':
        PVector left = direction.cross(cameraUp);  // Mover hacia la izquierda
        cameraPosition.sub(PVector.mult(left, moveSpeed));
        break;
      case 'd':
        PVector right = direction.cross(cameraUp);  // Mover hacia la derecha
        cameraPosition.add(PVector.mult(right, moveSpeed));
        break;
      }
    }
  }

  void dibujarCampo() {
    float[] rango = estimarCampo();

    for (float x = xMin; x <= xMax; x += paso) {
      for (float y = yMin; y <= yMax; y += paso) {
        for (float z = zMin; z <= zMax; z += paso) {

          PVector punto = new PVector(x, y, z);
          curvaCampo(punto, rango);

          // Visualizar el campo en este punto
        }
      }
    }
  }

  void curvaCampo(PVector punto, float[] rango) {
    PVector puntoActual = punto.copy();
    PVector campoTotal = new PVector(0, 0, 0);

    float cMin = rango[0];
    float cMax = rango[1];


    beginShape();
    
    for (int i = 0; i <= d; i ++) {
      campoTotal.set(0, 0, 0);

      campoTotal.add(campoTotal(puntoActual));

      color Color = colorCampo(cMin, campoTotal.mag(), cMax);
      
      stroke(Color, campoTotal.mag() * 0.05);

      campoTotal.normalize();

      PVector puntoAnterior = puntoActual.copy();

      puntoActual.add(PVector.mult(campoTotal, 5));


      noFill();
      
      vertex(puntoAnterior.x, puntoAnterior.y, puntoAnterior.z);
    }
    endShape();
  }

  float[] estimarCampo() {
    float magnitudMaxima = 0;
    float magnitudMinima = 0.001;

    for (float x = xMin; x <= xMax; x += paso) {
      for (float y = yMin; y <= yMax; y += paso) {
        for (float z = zMin; z <= zMax; z += paso) {

          PVector punto = new PVector(x, y, z);
          PVector campoTotal = campoTotal(punto);
          float magnitudCampo = campoTotal.mag();

          if (magnitudCampo > magnitudMaxima) {
            magnitudMaxima = magnitudCampo;
          }
        }
      }
    }

    float[] rango = {magnitudMinima, magnitudMaxima};
    return rango;
  }

  void dibujarEquipotenciales() {
    float potencialMin = -20000;
    float potencialMax = 20000;
    int numEquipotenciales = 15;
    float deltaPotencial = (potencialMax - potencialMin) / numEquipotenciales;

    float paso = 2.5;
    int cols = (int)Math.ceil((xMax - xMin) / paso);
    int rows = (int)Math.ceil((yMax - yMin) / paso);
    float[][] potenciales = new float[cols + 1][rows + 1];

    // Calcular y almacenar los potenciales
    for (int i = 0; i <= cols; i++) {
      for (int j = 0; j <= rows; j++) {
        float x = xMin + i * paso;
        float y = yMin + j * paso;
        PVector punto = new PVector(x, y, 0);
        potenciales[i][j] = calcularPotencial(punto);
      }
    }

    // Para cada valor equipotencial
    for (int n = 0; n <= numEquipotenciales; n++) {
      float valorEquipotencial = potencialMin + n * deltaPotencial;
      stroke(colorPotencial(valorEquipotencial)); // Puedes variar el color según el potencial

      // Recorrer la rejilla y aplicar Marching Squares
      for (int i = 0; i < cols; i++) {
        for (int j = 0; j < rows; j++) {
          // Obtener los potenciales en los cuatro vértices de la celda
          float v1 = potenciales[i][j];         // Superior izquierdo
          float v2 = potenciales[i + 1][j];     // Superior derecho
          float v3 = potenciales[i + 1][j + 1]; // Inferior derecho
          float v4 = potenciales[i][j + 1];     // Inferior izquierdo

          // Determinar el índice del caso
          int caso = 0;
          if (v1 >= valorEquipotencial) caso |= 1;
          if (v2 >= valorEquipotencial) caso |= 2;
          if (v3 >= valorEquipotencial) caso |= 4;
          if (v4 >= valorEquipotencial) caso |= 8;

          float x0 = xMin + i * paso;
          float y0 = yMin + j * paso;

          float x1, y1, x2, y2;
          switch (caso) {
          case 0:
          case 15:
            break;
          case 1:
          case 14:
            // Línea entre el borde izquierdo y el borde superior
            x1 = x0;
            y1 = y0 + interpola(v1, v4, valorEquipotencial) * paso;
            x2 = x0 + interpola(v1, v2, valorEquipotencial) * paso;
            y2 = y0;
            line(x1, y1, x2, y2);
            break;

          case 2:
          case 13:
            x1 = x0 + interpola(v1, v2, valorEquipotencial) * paso;
            y1 = y0;
            x2 = x0;
            y2 = y0 + interpola(v2, v3, valorEquipotencial) * paso;
            line(x1, y1, x2, y2);
            break;
          case 3:
          case 12:
            x1 = x0;
            y1 = y0 + interpola(v1, v4, valorEquipotencial) * paso;
            x2 = x0;
            y2 = y0 + interpola(v2, v3, valorEquipotencial) * paso;
            line(x1, y1, x2, y2);
            break;
          case 4:
          case 11:
            x1 = x0;
            y1 = y0 + interpola(v1, v4, valorEquipotencial) * paso;
            x2 = x0 + interpola(v1, v2, valorEquipotencial) * paso;
            y2 = y0;
            line(x1, y1, x2, y2);
            break;
          case 5:
            x1 = x0;
            y1 = y0 + interpola(v1, v4, valorEquipotencial) * paso;
            x2 = x0 + interpola(v2, v3, valorEquipotencial) * paso;
            y2 = y0;
            line(x1, y1, x2, y2);

            x1 = x0;
            y1 = y0 + interpola(v2, v3, valorEquipotencial) * paso;
            x2 = x0 + interpola(v3, v4, valorEquipotencial) * paso;
            y2 = y0;
            line(x1, y1, x2, y2);
            break;
          case 10:
            x1 = x0 + interpola(v1, v2, valorEquipotencial) * paso;
            y1 = y0;
            x2 = x0;
            y2 = y0 + interpola(v1, v4, valorEquipotencial) * paso;
            line(x1, y1, x2, y2);

            x1 = x0;
            y1 = y0 + interpola(v2, v3, valorEquipotencial) * paso;
            x2 = x0 + interpola(v3, v4, valorEquipotencial) * paso;
            y2 = y0;
            line(x1, y1, x2, y2);
            break;
          case 6:
          case 9:
            x1 = x0 + interpola(v1, v2, valorEquipotencial) * paso;
            y1 = y0;
            x2 = x0 + interpola(v3, v4, valorEquipotencial) * paso;
            y2 = y0;
            line(x1, y1, x2, y2);
            break;
          case 7:
          case 8:
            x1 = x0;
            y1 = y0 + interpola(v1, v4, valorEquipotencial) * paso;
            x2 = x0 + interpola(v3, v4, valorEquipotencial) * paso;
            y2 = y0 + paso;
            line(x1, y1, x2, y2);
            break;
          }
        }
      }
    }
  }

  // Función para interpolar entre dos valores
  float interpola(float val1, float val2, float valorEquipotencial) {
    if (val2 == val1) {
      return 0.5;
    } else {
      return (valorEquipotencial - val1) / (val2 - val1);
    }
  }

  void dibujarPotencial() {
    float paso = 20;

    for (float x = xMin; x <= xMax; x += paso) {
      for (float y = yMin; y <= yMax; y += paso) {
        PVector punto = new PVector(x, y, 0); // Considerando z = 0


        float voltaje = calcularPotencial(punto);

        // Mapear el voltaje a un color
        color Color = colorPotencial(voltaje);

        // Dibujar un punto o cuadrado con el color correspondiente
        stroke(Color);
        point(x, y);
      }
    }
  }

  color colorPotencial(float voltaje) {
    // Define los valores mínimo y máximo del potencial
    float voltajeMin = -100; // Ajusta según tu simulación
    float voltajeMax = 100;  // Ajusta según tu simulación

    // Mapear el voltaje a un valor entre 0 y 255
    float valorColor = map(voltaje, voltajeMin, voltajeMax, 0, 255);
    valorColor = constrain(valorColor, 0, 255);

    // Retornar un color basado en el valor mapeado
    return color(255 - valorColor, 0, valorColor); // De rojo a azul
  }
}
