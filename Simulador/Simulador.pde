import wblut.core.*;
import wblut.geom.*;
import wblut.hemesh.*;
import wblut.math.*;
import wblut.nurbs.*;
import wblut.processing.*;

import peasy.*;

import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.Sheet;  // Fully qualified name to resolve ambiguity
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import java.io.FileOutputStream;
import java.io.IOException;

import g4p_controls.*;
import org.quark.jasmine.*;
import java.awt.Font;

float nC = 1e-6; //Numero nC
float p = 1e-2; //Escala distancia

final float f = 5 * 1e3; // Escala del vector de fuerza 3d
final float f_ = 1e2; // Escala del vector de fuerza en 2d

final float k = 8.99e9;
final float Eo = 8.85e-12;

float escala = 2;

int numTheta = 10;
int numPhi = 7;
float radio = 25;

int op = 1;
int opO = 0;

int index = 0;
float x_ = 770;
float y_ = 117;

int xi = -500;
int yi = 0;

ArrayList<Particula> nuevasParticulas = new ArrayList<Particula>();
ArrayList<Particula> eliminarParticulas = new ArrayList<Particula>();
ArrayList<Particula> particula = new ArrayList<>();
ArrayList<GButton> prop = new ArrayList<>();

Camara camara = new Camara();
VentanaS s = new VentanaS();
Objeto cable = new Objeto();
Objeto anillo = new Objeto();

ArrayList<Objeto> placa = new ArrayList<>();

static boolean e = false;
static boolean c = false;
static boolean v = false;
static boolean simulacion = false;

long tiempoI;
long tiempoF;
long tiempoT;

PVector mouse;
Colision m;
Colision malla;

WB_Render3D render;
HE_Mesh mesh;
HEC_Torus creator;

void setup() {
  size(1500, 1000, P3D);  // Inicializar la ventana en modo 3D
  render = new WB_Render3D(this);

  // Inicializar Jasmine
  Compile.init();
  createGUI();

  sliderCable.setVisible(false);
  propSimulacion.setVisible(false);
  guia1.setVisible(false);
  guia2.setVisible(false);
  propiedades.setVisible(false);

  smooth();

  // Agregar botón en la ventana de interfaz
  int size = 15;

  propElectrica.setFont(new Font("Arial", Font.PLAIN, size));
  propCampo.setFont(new Font("Arial", Font.PLAIN, size));
  propEstatico.setFont(new Font("Arial", Font.PLAIN, size));

  lblMasa.setFont(new Font("Arial", Font.PLAIN, size));
  propMasa.setFont(new Font("Arial", Font.PLAIN, size));
  lblMasaU.setFont(new Font("Arial", Font.PLAIN, size));

  lblPosX.setFont(new Font("Arial", Font.PLAIN, size));
  propPosX .setFont(new Font("Arial", Font.PLAIN, size));
  lblPosY.setFont(new Font("Arial", Font.PLAIN, size));
  propPosY.setFont(new Font("Arial", Font.PLAIN, size));
  lblPosU.setFont(new Font("Arial", Font.PLAIN, size));

  lblVelX.setFont(new Font("Arial", Font.PLAIN, size));
  propVelX.setFont(new Font("Arial", Font.PLAIN, size ));
  propVelX.setEnabled(false);
  lblVelY.setFont(new Font("Arial", Font.PLAIN, size));
  propVelY.setFont(new Font("Arial", Font.PLAIN, size));
  propVelY.setEnabled(false);
  lblVelU.setFont(new Font("Arial", Font.PLAIN, size));



  mouse = new PVector();
  malla = new Colision(new PVector(100, 100), 500, 500);

  cable = new Cable(500, 1, new PVector(0, 0, 0));
  placa.add(new Placa(1500, 1500, 1, new PVector(0, -500, 0)));
  placa.add(new Placa(1500, 1500, -1, new PVector(0, 500, 0)));
  anillo = new Anillo(300, 1, new PVector(0, 0, 0));


  Insertar();


  mesh = new HE_Mesh(creator);
}

void draw() {
  customGUI();

  background(255);
  display3D();
}

void display3D() {
  lights();  // Agregar luces para mejor visualización 3D
  camara.updateCamera();
  camara.drawWorld();

  switch(opO) {
  case 1:
    cable.Display();
    break;
  case 2:
    for (Objeto p : placa) p.Display();
    break;
  case 3:
    anillo.Display();
    break;
  }

  int y = 0;
  for (Particula p : particula) {
    p.Display();

    fill(0);
    text("particula " + p.i + " :", xi, yi + y);
    text("p = " + p.q, xi, yi + 20 + y);
    text("x: " + p.posE.x + ", y:" + - p.posE.y, xi, yi + 40 + y);
    text("Fueza Neta: ", xi, yi + 60 + y);
    text("Magnitud = " + p.fuerzaE.mag() + " N", xi, yi + 80 + y);
    text("Potencial = " + p.potencial + " V", xi, yi + 100 + y);
    y += 130;
  }

  if (!nuevasParticulas.isEmpty()) {
    particula.addAll(nuevasParticulas);
    nuevasParticulas.clear();
  }

  if (!eliminarParticulas.isEmpty()) {
    particula.removeAll(eliminarParticulas);
    eliminarParticulas.clear();

    index = 0;
    x_ = 770;
    y_ = 117;

    if (particula.size() == 0) return;

    for (int i = 0; i < particula.size(); i++) {
      Particula p = particula.get(i);
      index++;
      p.i = index;

      p.texto.moveTo(x_, y_);
      p.texto.setText(String.valueOf((int) (p.q / nC)));

      GButton botonProp = prop.get(i);
      botonProp.moveTo(x_ + 130, y_ + 3);

      y_ += 60;
    }
  }
}

void Malla(PApplet a) {
}

PVector campoTotal(PVector punto) {
  PVector campoTotal = new PVector(0, 0, 0);

  // Sumar campos de partículas
  for (Particula p : particula) {
    PVector campo = p.Campo(punto);
    campoTotal.add(campo);
  }

  //Sumar campo anillo
  if (opO == 3) {
    campoTotal.add(anillo.Campo(punto));
  }

  // Sumar campos de placas
  if (opO == 2) {
    for (Objeto p : placa) {
      PVector campo = p.Campo(punto);
      campoTotal.add(campo);
    }
  }

  // Sumar campo del cable
  if (opO == 1) {
    campoTotal.add(cable.Campo(punto));
  }

  return campoTotal;
}

float calcularPotencial(PVector punto) {
  float voltaje = 0;

  /*
  if(opO == 2){
   for(Objeto p : placa) {
   voltaje += p.Potencial(punto);
   }
   }
   */

  for (Particula p : particula) {
    if (p.q != 0) voltaje += p.Potencial(punto);
  }

  return voltaje;
}


void Mouse(PApplet a) {
  if (m == null) m = new Colision(mouse, 5, 5);

  mouse.x = a.mouseX;
  mouse.y = a.mouseY;
  m.pos = mouse;
}

boolean Colision(Colision another) {
  return m.detectar(another);
}

public void customGUI() {
  tiempo.setText(String.valueOf(Tiempo()));

  if (propiedades.isVisible()) {
    lblPosU.setText("*" + p * 100 + " m");
    lblVelU.setText("*" + p * 100 + " m / s");
  }

  listEspacio.setEnabled(!propSimulacion.isVisible());

  switch(opO) {
    //Cable
  case 1:
    if (campo.isSelected()) {
      if (listDistribucion.getSelectedIndex() != 0) listDistribucion.setSelected(0);
      listDistribucion.setEnabled(false);
      campo.setEnabled(true);
      lblMin.setText("Carga");
      lblMax.setVisible(false);
      txtMax.setEnabled(false);
      txtMax.setVisible(false);
      txtMin.setEnabled(true);
      sliderCable.setVisible(true);
    } else {
      sliderCable.setVisible(true);
      listDistribucion.setEnabled(true);
      campo.setText("Constante");
      campo.setEnabled(true);
      lblMax.setText("Carga Maxima");
      lblMin.setText("Carga Minima");
      lblMax.setVisible(true);
      txtMax.setEnabled(true);
      txtMax.setVisible(true);
      txtMin.setEnabled(true);
    }
    break;
    //Placas
  case 2:
    listDistribucion.setEnabled(true);
    campo.setText("Infinito");
    campo.setEnabled(true);
    lblMin.setText("Carga");
    lblMax.setVisible(false);
    txtMax.setEnabled(false);
    txtMax.setVisible(false);
    txtMin.setEnabled(true);
    sliderCable.setVisible(false);
    break;
  default:
    listDistribucion.setEnabled(false);
    campo.setText("Constante");
    campo.setEnabled(false);
    lblMax.setText("Carga Maxima");
    lblMin.setText("Carga Minima");
    lblMax.setVisible(true);
    txtMax.setEnabled(false);
    txtMin.setEnabled(false);
    txtMax.setVisible(true);
    txtMin.setVisible(true);
    sliderCable.setVisible(false);
    break;
  }
}

color colorCampo(float magnitudMinima, float magnitudCampo, float magnitudMaxima) {
  color colorInicio = color(255);
  color colorFinal = color(100);

  float logMin = log(magnitudMinima + 1); // Añadir 1 para evitar log(0)
  float logMax = log(magnitudMaxima + 1);
  float escala = map(log(magnitudCampo + 1), logMin, logMax, 0, 1);
  return lerpColor(colorInicio, colorFinal, escala);
}

int d = 25;

void keyPressed() {
  
  switch(key) {
  case 'q':
    if (interfaz.isVisible()) {
      interfaz.setVisible(false);
    } else {
      interfaz.setVisible(true);
    }
    break;
  case 'x':
    d++;
    break;
  case 'z':
    if(d != 0) d--;
  }

  switch(keyCode) {
  case 32:
    if (particula.size() == 0) return;
    simulacion = simulacion ? false : true;

    Simulacion();
    break;
  }
}
