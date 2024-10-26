void botonPropiedades_click(GButton source, GEvent event) {
  if (event == GEvent.CLICKED) {
    if (!propiedades.isVisible()) propiedades.setVisible(true);
  }
}

public void prop_click(GButton source, GEvent event) {
  for (int i = 0; i < prop.size(); i++) {
    Particula p = particula.get(i);
    if (source == prop.get(i) && !propiedades.isVisible()) {

      propiedades.setVisible(true);
      p.selected = true;

      propElectrica.setSelected(p.fuerza);
      propCampo.setSelected(p.campo);
      propEstatico.setSelected(p.estatico);

      propMasa.setText(String.valueOf((int) p.masa));
      propPosX.setText(String.valueOf(p.posE.x / (this.p * 100)));
      propPosY.setText(String.valueOf(- p.posE.y / (this.p * 100)));
      propVelX.setText(String.valueOf(p.vel.x));
      propVelY.setText(String.valueOf(- p.vel.y));

      if (p.estatico) {
        propVelX.setEnabled(false);
        propVelY.setEnabled(false);
      }

      if (simulacion == true) {
        propEstatico.setEnabled(false);
        if (!p.estatico) propPosX.setEnabled(false);
        if (!p.estatico) propPosY.setEnabled(false);
      } else {
        propEstatico.setEnabled(true);
      }
    }
  }
}

void Insertar() {
  botonSimulacion.setVisible(true);
  botonAgregar.setVisible(true);
  if (opO == 0) checkPotencial.setVisible(true);
  checkElectrica.setVisible(true);
  checkCampo.setVisible(true);
}

void Simulacion() {

  if (simulacion) {
    tiempoT = 0;
    tiempoI = millis();
    botonSimulacion.setText("Pausar");
  } else {
    tiempoF = millis();
    tiempoT += (tiempoF - tiempoI);
    botonSimulacion.setText("Iniciar");

    archivoExcel();

    for (Particula p : particula) {
      p.vel.set(0, 0, 0);
      p.estatico = true;
    }
  }
}

float Tiempo() {
  if (simulacion) {
    // Si la simulación está corriendo, calcular el tiempo actual también
    return (tiempoT + (millis() - tiempoI)) / 1000.0;
  } else {
    // Si está pausada, devolver el tiempo total acumulado
    return tiempoT / 1000.0;
  }
}
