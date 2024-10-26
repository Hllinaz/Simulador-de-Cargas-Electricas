/* =========================================================
 * ====                   WARNING                        ===
 * =========================================================
 * The code in this tab has been generated from the GUI form
 * designer and care should be taken when editing this file.
 * Only add/edit code inside the event handlers i.e. only
 * use lines between the matching comment tags. e.g.

 void myBtnEvents(GButton button) { //_CODE_:button1:12356:
     // It is safe to enter your event code here  
 } //_CODE_:button1:12356:
 
 * Do not rename this tab!
 * =========================================================
 */

synchronized public void draw2D(PApplet appc, GWinData data) { //_CODE_:interfaz:662211:
  appc.background(230);

  try {
    Mouse(appc);
  }
  catch(Exception e) {
  }
  s.Insertar(appc);
} //_CODE_:interfaz:662211:

synchronized public void arrastrarMouse_dragged(PApplet appc, GWinData data, MouseEvent mevent) { //_CODE_:interfaz:451853:
  if (mevent.getAction() == MouseEvent.PRESS) {
    // Detectar si el ratón hizo clic sobre el círculo
    for (Particula p : particula) {
      if (Colision(p.colision)) {

        p.arrastrando = true;
        p.offset =  new PVector(appc.mouseX - p.norma.x, appc.mouseY - p.norma.y);
        break;
      }
    }
  }

  if (mevent.getAction() == MouseEvent.RELEASE) {
    // Detener el arrastre cuando se suelta el ratón
    for (Particula p : particula) {
      p.arrastrando = false;
    }
  }
} //_CODE_:interfaz:451853:

public void botonAgregar_click(GButton source, GEvent event) { //_CODE_:botonAgregar:241399:
  if (event == GEvent.CLICKED) {
    if (particula.size() > 7) return;

    nuevasParticulas.add(new Particula(0, 0, 0, 1, 1));
    prop.get(index - 1).addEventHandler(this, "prop_click");
  }
} //_CODE_:botonAgregar:241399:

public void botonSimulacion_click(GButton source, GEvent event) { //_CODE_:botonSimulacion:538595:
  if (event == GEvent.CLICKED) {

    if (particula.size() == 0) return;

    simulacion = simulacion ? false : true;

    Simulacion();
  }
} //_CODE_:botonSimulacion:538595:

public void checkPotencial_click(GCheckbox source, GEvent event) { //_CODE_:checkPotencial:453597:
  v = source.isSelected() ? true : false;
} //_CODE_:checkPotencial:453597:

public void checkElectrica_click(GCheckbox source, GEvent event) { //_CODE_:checkElectrica:537409:
  e = source.isSelected() ? true : false;
} //_CODE_:checkElectrica:537409:

public void checkCampo_click(GCheckbox source, GEvent event) { //_CODE_:checkCampo:531909:
  c = source.isSelected() ? true : false;
} //_CODE_:checkCampo:531909:

public void slider1_change1(GSlider source, GEvent event) { //_CODE_:sliderCable:620390:
  cable.largo = source.getValueF();
} //_CODE_:sliderCable:620390:

public void propiedades_click(GButton source, GEvent event) { //_CODE_:botonPropiedades:845455:
  propSimulacion.setVisible(true);

  switch(opO) {
  case 1:


    campo.setSelected(cable.inf);
    if (campo.isSelected()) {
      txtMin.setText(String.valueOf(cable.q / nC));
    } else {
      txtMin.setText(String.valueOf(cable.qMin / nC));
      txtMax.setText(String.valueOf(cable.qMax / nC));
    }
    break;
  case 2:
    int i = 0;
    for (Objeto p : placa) {
      i++;
      listDistribucion.addItem("Placa " + i);
    }

    listDistribucion.removeItem(0);
    listDistribucion.removeItem(0);
    listDistribucion.removeItem(0);
    listDistribucion.removeItem(0);

    campo.setSelected(placa.get(0).inf);
    txtMin.setText(String.valueOf(placa.get(0).q / nC));
    break;
  default:
    listDistribucion.setSelected(0);
    campo.setSelected(true);
    txtMin.setText("-");
    txtMax.setText("-");
    break;
  }
} //_CODE_:botonPropiedades:845455:

public void listEspacio_select(GDropList source, GEvent event) { //_CODE_:listEspacio:607491:
  opO = source.getSelectedIndex();

  for (int i = 0; i < particula.size(); i++) {
    eliminarParticulas.add(particula.get(i));

    particula.get(i).texto.setVisible(false);
    particula.get(i).texto.dispose();

    prop.get(i).setVisible(false);
    prop.get(i).dispose();
  }
  prop.clear();
} //_CODE_:listEspacio:607491:

synchronized public void drawPropiedades(PApplet appc, GWinData data) { //_CODE_:propiedades:214121:
  appc.background(230);

  for (Particula p : particula) {
    if (p.selected) {

      if (p.arrastrando) {
        propPosX.setText(String.valueOf(p.posE.x / (this.p * 100)));
        propPosY.setText(String.valueOf(- p.posE.y / (this.p * 100)));
      }

      if (!p.estatico & simulacion) {
        propPosX.setText(String.valueOf(p.posE.x / (this.p * 100)));
        propPosY.setText(String.valueOf(- p.posE.y / (this.p * 100)));

        propVelX.setText(String.valueOf(p.vel.x));
        propVelY.setText(String.valueOf(- p.vel.y));
      }
    }
  }
} //_CODE_:propiedades:214121:

public void botonAplicar_click(GButton source, GEvent event) { //_CODE_:botonAplicar:521210:
  if (event != GEvent.CLICKED) return;
  for (Particula p : particula) {
    if (p.selected) {

      if (!propMasa.getText().trim().isEmpty()) {
        float masa = Float.parseFloat(propMasa.getText().trim());
        p.masa = masa <= 1 ? p.masa : masa;
      }


      if (!propPosX.getText().trim().isEmpty() & !propPosY.getText().trim().isEmpty()) {
        float posX = Float.parseFloat(propPosX.getText().trim()) * (100);
        float posY = - Float.parseFloat(propPosY.getText().trim()) * (100);

        p.pos.set(posX, posY);

        p.norma.set(posX / 2, posY / 2);
        p.pos_.set(p.norma.x + p.r - 7.5, p.norma.y + p.r - 7.5);
      }

      if (!propVelX.getText().trim().isEmpty() & !propVelY.getText().trim().isEmpty()) {
        float velX = Float.parseFloat(propVelX.getText().trim());
        float velY = - Float.parseFloat(propVelY.getText().trim());

        p.vel.x = velX;
        p.vel.y = velY;
      }

      propiedades.setVisible(false);
      p.selected = false;
    }
  }
} //_CODE_:botonAplicar:521210:

public void botonEliminar_click(GButton source, GEvent event) { //_CODE_:botonEliminar:486075:
  if (event != GEvent.CLICKED) return;

  for (int i = 0; i < particula.size(); i++) {
    if (particula.get(i).selected) {
      eliminarParticulas.add(particula.get(i));

      particula.get(i).texto.setVisible(false);
      particula.get(i).texto.dispose();

      prop.get(i).setVisible(false);
      prop.get(i).dispose();

      prop.remove(i);
      i--;

      break;
    }
  }
  propiedades.setVisible(false);
} //_CODE_:botonEliminar:486075:

public void propElectrica_click(GCheckbox source, GEvent event) { //_CODE_:propElectrica:911119:
  for (Particula p : particula) {
    if (p.selected) p.fuerza = source.isSelected() ? true : false;
  }
} //_CODE_:propElectrica:911119:

public void propCampo_click(GCheckbox source, GEvent event) { //_CODE_:propCampo:828506:
  for (Particula p : particula) {
    if (p.selected) p.campo = source.isSelected() ? true : false;
  }
} //_CODE_:propCampo:828506:

public void propEstatico_click(GCheckbox source, GEvent event) { //_CODE_:propEstatico:243267:
  for (Particula p : particula) {
    if (p.selected) {

      p.estatico = source.isSelected() ? true : false;

      if (!p.estatico) {
        propVelX.setEnabled(true);
        propVelY.setEnabled(true);
      } else {
        propVelX.setText("0.0");
        propVelX.setText("0.0");
        propVelX.setEnabled(false);
        propVelY.setEnabled(false);
      }
    }
  }
} //_CODE_:propEstatico:243267:

public void propMasa_change(GTextField source, GEvent event) { //_CODE_:propMasa:619178:
} //_CODE_:propMasa:619178:

public void propPosX_change(GTextField source, GEvent event) { //_CODE_:propPosX:381789:
} //_CODE_:propPosX:381789:

public void propPosY_change(GTextField source, GEvent event) { //_CODE_:propPosY:961826:
} //_CODE_:propPosY:961826:

public void propVelX_change(GTextField source, GEvent event) { //_CODE_:propVelX:214877:
} //_CODE_:propVelX:214877:

public void propVelY_change(GTextField source, GEvent event) { //_CODE_:propVelY:566350:
} //_CODE_:propVelY:566350:

synchronized public void drawSimulacion(PApplet appc, GWinData data) { //_CODE_:propSimulacion:895098:
  appc.background(230);
} //_CODE_:propSimulacion:895098:

public void botonAplicar_click1(GButton source, GEvent event) { //_CODE_:butonAplicar1:458806:
  propSimulacion.setVisible(false);

  switch(escalaDistancia.getSelectedIndex()) {
  case 0:
    p = 1e-1; //10 m
    break;
  case 1:
    p = 1e-2; //1 m
    break;
  case 2:
    p = 1e-3; //0.1 m
    break;
  }

  switch(escalaCarga.getSelectedIndex()) {
  case 0:
    nC = 1e-6;
    break;
  case 1:
    nC = 1e-3;
    break;
  case 2:
    nC = 1;
    break;
  }

  switch(opO) {
  case 1:
    cable.inf = campo.isSelected();

    if (campo.isSelected()) {
      cable.q = Float.parseFloat(txtMin.getText()) * nC;
    } else {
      cable.tipo = listDistribucion.getSelectedIndex();

      cable.qMin = Float.parseFloat(txtMin.getText()) * nC;
      cable.qMax = Float.parseFloat(txtMax.getText()) * nC;
    }
    break;
  case 2:
    listDistribucion.addItem("Constante");
    listDistribucion.addItem("Lineal");
    listDistribucion.addItem("Cuadratica");
    listDistribucion.addItem("Sinuidal");

    listDistribucion.removeItem(0);
    listDistribucion.removeItem(0);
    break;
  default:
    break;
  }
} //_CODE_:butonAplicar1:458806:

public void distancia_click(GDropList source, GEvent event) { //_CODE_:escalaDistancia:767099:
} //_CODE_:escalaDistancia:767099:

public void carga_click(GDropList source, GEvent event) { //_CODE_:escalaCarga:846924:
} //_CODE_:escalaCarga:846924:

public void slider1_change2(GSlider source, GEvent event) { //_CODE_:sliderVector:815539:
  println("slider1 - GSlider >> GEvent." + event + " @ " + millis());
} //_CODE_:sliderVector:815539:

public void distribucion_click(GDropList source, GEvent event) { //_CODE_:listDistribucion:485310:
  switch(opO) {
  case 2:
    switch(listDistribucion.getSelectedIndex()) {
    case 0:
      campo.setSelected(placa.get(0).inf);
      txtMin.setText(String.valueOf(placa.get(0).q / nC));
      break;
    case 1:
      campo.setSelected(placa.get(1).inf);
      txtMin.setText(String.valueOf(placa.get(1).q / nC));
      break;
    }
    break;
  }
} //_CODE_:listDistribucion:485310:

public void textMin_change(GTextField source, GEvent event) { //_CODE_:txtMin:247087:
  if(opO == 2) placa.get(listDistribucion.getSelectedIndex()).q = Float.parseFloat(txtMin.getText()) / nC;
} //_CODE_:txtMin:247087:

public void textMax_change(GTextField source, GEvent event) { //_CODE_:txtMax:397608:

} //_CODE_:txtMax:397608:

public void checkCampo_clicked(GCheckbox source, GEvent event) { //_CODE_:campo:432574:
  switch(opO) {
  case 1:
    if (source.isSelected()) {
      txtMin.setText(String.valueOf(cable.q / nC));
    } else {
      txtMin.setText(String.valueOf(cable.qMin / nC));
      txtMax.setText(String.valueOf(cable.qMax / nC));
    }
    break;
  case 2:
    
    switch(listDistribucion.getSelectedIndex()){
    case 0:
      placa.get(0).inf = campo.isSelected();
      break;
    case 1:
      placa.get(1).inf = campo.isSelected();
      break;
    }
    break;
  }
} //_CODE_:campo:432574:



// Create all the GUI controls. 
// autogenerated do not edit
public void createGUI(){
  G4P.messagesEnabled(false);
  G4P.setGlobalColorScheme(GCScheme.BLUE_SCHEME);
  G4P.setMouseOverEnabled(false);
  surface.setTitle("Sketch Window");
  tiempo = new GLabel(this, 1333, 905, 122, 44);
  tiempo.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  tiempo.setText("My label");
  tiempo.setOpaque(false);
  interfaz = GWindow.getWindow(this, "Interface", 0, 0, 1050, 850, JAVA2D);
  interfaz.noLoop();
  interfaz.setActionOnClose(G4P.KEEP_OPEN);
  interfaz.addDrawHandler(this, "draw2D");
  interfaz.addMouseHandler(this, "arrastrarMouse_dragged");
  botonAgregar = new GButton(interfaz, 800, 650, 150, 30);
  botonAgregar.setText("Agregar");
  botonAgregar.addEventHandler(this, "botonAgregar_click");
  botonSimulacion = new GButton(interfaz, 100, 700, 150, 30);
  botonSimulacion.setText("Iniciar");
  botonSimulacion.addEventHandler(this, "botonSimulacion_click");
  checkPotencial = new GCheckbox(interfaz, 350, 680, 150, 30);
  checkPotencial.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  checkPotencial.setText("Lineas Equipotenciales");
  checkPotencial.setOpaque(false);
  checkPotencial.addEventHandler(this, "checkPotencial_click");
  checkElectrica = new GCheckbox(interfaz, 350, 720, 150, 30);
  checkElectrica.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  checkElectrica.setText("Fuerzas Electricas");
  checkElectrica.setOpaque(false);
  checkElectrica.addEventHandler(this, "checkElectrica_click");
  checkCampo = new GCheckbox(interfaz, 350, 640, 150, 30);
  checkCampo.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  checkCampo.setText("Campo Electrico");
  checkCampo.setOpaque(false);
  checkCampo.addEventHandler(this, "checkCampo_click");
  sliderCable = new GSlider(interfaz, 650, 700, 300, 60, 15.0);
  sliderCable.setShowValue(true);
  sliderCable.setShowLimits(true);
  sliderCable.setLimits(500.0, 250.0, 1500.0);
  sliderCable.setShowTicks(true);
  sliderCable.setNumberFormat(G4P.DECIMAL, 2);
  sliderCable.setOpaque(false);
  sliderCable.addEventHandler(this, "slider1_change1");
  botonPropiedades = new GButton(interfaz, 100, 650, 150, 30);
  botonPropiedades.setText("Propiedades de Simulacion");
  botonPropiedades.addEventHandler(this, "propiedades_click");
  listEspacio = new GDropList(interfaz, 100, 50, 90, 100, 4, 10);
  listEspacio.setItems(loadStrings("list_607491"), 0);
  listEspacio.addEventHandler(this, "listEspacio_select");
  guia1 = new GLabel(interfaz, 100, 100, 500, 500);
  guia1.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  guia1.setOpaque(true);
  guia2 = new GLabel(interfaz, 650, 100, 300, 500);
  guia2.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  guia2.setOpaque(true);
  lblTitulo = new GLabel(interfaz, 228, 15, 245, 62);
  lblTitulo.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  lblTitulo.setText("Simulador de Interacciones entre Cargas Electricas");
  lblTitulo.setOpaque(false);
  lblParticula = new GLabel(interfaz, 743, 29, 138, 53);
  lblParticula.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  lblParticula.setText("Particulas");
  lblParticula.setOpaque(false);
  propiedades = GWindow.getWindow(this, "Propiedades", 0, 0, 500, 300, JAVA2D);
  propiedades.noLoop();
  propiedades.setActionOnClose(G4P.KEEP_OPEN);
  propiedades.addDrawHandler(this, "drawPropiedades");
  botonAplicar = new GButton(propiedades, 350, 250, 100, 30);
  botonAplicar.setText("Aplicar");
  botonAplicar.addEventHandler(this, "botonAplicar_click");
  botonEliminar = new GButton(propiedades, 50, 250, 100, 30);
  botonEliminar.setText("Eliminar");
  botonEliminar.addEventHandler(this, "botonEliminar_click");
  propElectrica = new GCheckbox(propiedades, 50, 40, 120, 30);
  propElectrica.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  propElectrica.setText("Fuerzas electricas");
  propElectrica.setOpaque(false);
  propElectrica.addEventHandler(this, "propElectrica_click");
  propCampo = new GCheckbox(propiedades, 50, 80, 120, 30);
  propCampo.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  propCampo.setText("Campo electrico");
  propCampo.setOpaque(false);
  propCampo.addEventHandler(this, "propCampo_click");
  propEstatico = new GCheckbox(propiedades, 50, 120, 120, 30);
  propEstatico.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  propEstatico.setText("Estatico");
  propEstatico.setOpaque(false);
  propEstatico.addEventHandler(this, "propEstatico_click");
  lblMasa = new GLabel(propiedades, 210, 40, 50, 30);
  lblMasa.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  lblMasa.setText("Masa");
  lblMasa.setOpaque(false);
  propMasa = new GTextField(propiedades, 270, 40, 30, 30, G4P.SCROLLBARS_NONE);
  propMasa.setText("0");
  propMasa.setOpaque(true);
  propMasa.addEventHandler(this, "propMasa_change");
  lblMasaU = new GLabel(propiedades, 310, 40, 50, 30);
  lblMasaU.setText("kg");
  lblMasaU.setOpaque(false);
  lblPosX = new GLabel(propiedades, 210, 80, 50, 30);
  lblPosX.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  lblPosX.setText("Pos X");
  lblPosX.setOpaque(false);
  propPosX = new GTextField(propiedades, 265, 80, 40, 30, G4P.SCROLLBARS_NONE);
  propPosX.setText("0");
  propPosX.setOpaque(true);
  propPosX.addEventHandler(this, "propPosX_change");
  lblPosY = new GLabel(propiedades, 310, 80, 50, 30);
  lblPosY.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  lblPosY.setText("Pos Y");
  lblPosY.setOpaque(false);
  propPosY = new GTextField(propiedades, 365, 80, 40, 30, G4P.SCROLLBARS_NONE);
  propPosY.setText("0");
  propPosY.setOpaque(true);
  propPosY.addEventHandler(this, "propPosY_change");
  lblPosU = new GLabel(propiedades, 410, 80, 70, 30);
  lblPosU.setText("text");
  lblPosU.setOpaque(false);
  lblVelX = new GLabel(propiedades, 210, 120, 50, 30);
  lblVelX.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  lblVelX.setText("Vel X");
  lblVelX.setOpaque(false);
  propVelX = new GTextField(propiedades, 265, 120, 40, 30, G4P.SCROLLBARS_NONE);
  propVelX.setText("0");
  propVelX.setOpaque(true);
  propVelX.addEventHandler(this, "propVelX_change");
  lblVelY = new GLabel(propiedades, 310, 120, 50, 30);
  lblVelY.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  lblVelY.setText("VelY");
  lblVelY.setOpaque(false);
  propVelY = new GTextField(propiedades, 365, 120, 40, 30, G4P.SCROLLBARS_NONE);
  propVelY.setText("0");
  propVelY.setOpaque(true);
  propVelY.addEventHandler(this, "propVelY_change");
  lblVelU = new GLabel(propiedades, 410, 120, 80, 30);
  lblVelU.setText("text");
  lblVelU.setLocalColorScheme(GCScheme.CENTER);
  lblVelU.setOpaque(false);
  propSimulacion = GWindow.getWindow(this, "Propiedades Simulacion", 0, 0, 500, 260, JAVA2D);
  propSimulacion.noLoop();
  propSimulacion.setActionOnClose(G4P.KEEP_OPEN);
  propSimulacion.addDrawHandler(this, "drawSimulacion");
  butonAplicar1 = new GButton(propSimulacion, 360, 200, 100, 30);
  butonAplicar1.setText("Aplicar");
  butonAplicar1.addEventHandler(this, "botonAplicar_click1");
  escalaDistancia = new GDropList(propSimulacion, 30, 30, 90, 80, 3, 10);
  escalaDistancia.setItems(loadStrings("list_767099"), 1);
  escalaDistancia.addEventHandler(this, "distancia_click");
  escalaCarga = new GDropList(propSimulacion, 130, 30, 90, 80, 3, 10);
  escalaCarga.setItems(loadStrings("list_846924"), 0);
  escalaCarga.addEventHandler(this, "carga_click");
  sliderVector = new GSlider(propSimulacion, 30, 150, 150, 40, 15.0);
  sliderVector.setLimits(0.5, 0.0, 1.0);
  sliderVector.setNumberFormat(G4P.DECIMAL, 2);
  sliderVector.setOpaque(false);
  sliderVector.addEventHandler(this, "slider1_change2");
  lblVector = new GLabel(propSimulacion, 30, 110, 100, 30);
  lblVector.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  lblVector.setText("Tamaño Vector");
  lblVector.setOpaque(false);
  listDistribucion = new GDropList(propSimulacion, 370, 30, 90, 100, 4, 10);
  listDistribucion.setItems(loadStrings("list_485310"), 0);
  listDistribucion.addEventHandler(this, "distribucion_click");
  lblMin = new GLabel(propSimulacion, 251, 101, 80, 30);
  lblMin.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  lblMin.setText("Carga Minima");
  lblMin.setOpaque(false);
  txtMin = new GTextField(propSimulacion, 350, 100, 120, 30, G4P.SCROLLBARS_NONE);
  txtMin.setOpaque(true);
  txtMin.addEventHandler(this, "textMin_change");
  txtMax = new GTextField(propSimulacion, 350, 150, 120, 30, G4P.SCROLLBARS_NONE);
  txtMax.setOpaque(true);
  txtMax.addEventHandler(this, "textMax_change");
  lblMax = new GLabel(propSimulacion, 250, 150, 80, 30);
  lblMax.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  lblMax.setText("Carga Maxima");
  lblMax.setOpaque(false);
  campo = new GCheckbox(propSimulacion, 250, 30, 100, 20);
  campo.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  campo.setText("Constante");
  campo.setOpaque(false);
  campo.addEventHandler(this, "checkCampo_clicked");
  interfaz.loop();
  propiedades.loop();
  propSimulacion.loop();
}

// Variable declarations 
// autogenerated do not edit
GLabel tiempo; 
GWindow interfaz;
GButton botonAgregar; 
GButton botonSimulacion; 
GCheckbox checkPotencial; 
GCheckbox checkElectrica; 
GCheckbox checkCampo; 
GSlider sliderCable; 
GButton botonPropiedades; 
GDropList listEspacio; 
GLabel guia1; 
GLabel guia2; 
GLabel lblTitulo; 
GLabel lblParticula; 
GWindow propiedades;
GButton botonAplicar; 
GButton botonEliminar; 
GCheckbox propElectrica; 
GCheckbox propCampo; 
GCheckbox propEstatico; 
GLabel lblMasa; 
GTextField propMasa; 
GLabel lblMasaU; 
GLabel lblPosX; 
GTextField propPosX; 
GLabel lblPosY; 
GTextField propPosY; 
GLabel lblPosU; 
GLabel lblVelX; 
GTextField propVelX; 
GLabel lblVelY; 
GTextField propVelY; 
GLabel lblVelU; 
GWindow propSimulacion;
GButton butonAplicar1; 
GDropList escalaDistancia; 
GDropList escalaCarga; 
GSlider sliderVector; 
GLabel lblVector; 
GDropList listDistribucion; 
GLabel lblMin; 
GTextField txtMin; 
GTextField txtMax; 
GLabel lblMax; 
GCheckbox campo; 
