class Particula {
  Colision colision;
  Vector vector;

  boolean arrastrando;
  boolean selected;
  boolean campo;
  boolean fuerza;
  boolean estatico;

  PVector pos; //Posicion en 3d
  PVector pos_; //Posicion en 2d
  PVector norma; //Referencia de la posicion 3d en 2d
  PVector offset;
  PVector posE;

  PVector fuerzaE;
  PVector vel;
  PVector ac;

  float q;
  float masa;
  float potencial;


  color c;

  int r;
  int i;

  ArrayList<Float> datoTiempo = new ArrayList<>();
  ArrayList<PVector> datoPos = new ArrayList<>();
  ArrayList<PVector> datoVel = new ArrayList<>();
  ArrayList<PVector> datoAc = new ArrayList<>();
  ArrayList<PVector> datoFuerza = new ArrayList<>();
  ArrayList<PVector> datoCampo = new ArrayList<>();


  GTextField texto;

  Particula() {
  }

  Particula(float x, float y, float z, float q, float masa) {

    index++;
    this.r = 350;

    pos = new PVector(x, y, z);
    pos_ = new PVector(pos.x - 7.5 + r, pos.y - 7.5 + r);
    norma = new PVector(x, y);

    vel = new PVector(0, 0, 0);
    ac = new PVector(0, 0, 0);

    this.q = q * nC;
    fuerzaE = new PVector(0, 0);
    this.masa = masa;

    arrastrando = false;
    campo = true;
    fuerza = true;
    estatico = true;

    colision = new Colision(pos_, 20, 20);

    this.i = index;
    vector = new Vector(this);


    texto = new GTextField(interfaz, x_, y_, 50, 30);
    texto.setText(String.valueOf((int) q));
    texto.setFont(new Font("Arial", Font.PLAIN, 24));

    prop.add(new GButton(interfaz, x_ + 130, y_ + 3, 30, 30, "P"));

    y_ += 60;
  }

  void Display() {
    // Dibujar la Particula 1 en 3D (roja)
    pushStyle();
    noStroke();
    fill(c);
    pushMatrix();
    translate(pos.x, pos.y, pos.z);
    sphere(5);  // Dibujar la esfera que representa la Particula 1
    popMatrix();
    popStyle();

    vector.Display();
    if (!Simulador.c & campo & q != 0) vector.dibujarCampo();
    if (!estatico & simulacion) Movimiento();
    Potencial();

    posE = PVector.sub(pos, new PVector(0, 0, 0)).mult(p);
  }

  void Display(PApplet a) {

    a.noStroke();
    a.fill(c);
    a.circle(pos_.x + 7.5, pos_.y + 7.5, 15);

    //a.rect(colision.pos.x, colision.pos.y, colision.width, colision.height);
  }

  boolean Colision(Colision another) {
    return colision.detectar(another);
  }

  PVector Campo(PVector punto) {
    PVector direccion = PVector.sub(punto, this.pos);
    float distancia = direccion.mag() * p;

    if (distancia < 1 * p) distancia = 1;

    direccion.normalize();

    float magnitudCampo = (k * this.q) / (distancia * distancia);
    
    return direccion.mult(magnitudCampo);
  }

  void Movimiento() {
    PVector campoTotal = new PVector(0, 0, 0);

    campoTotal.add(campoTotal(pos));

    actualizar();

    if (simulacion) {

      if (Tiempo() * 1000 % 5 == 0) {
        datoPos.add(pos.copy());
        datoFuerza.add(fuerzaE.copy());
        datoAc.add(ac.copy());
        datoTiempo.add(Tiempo());
        datoVel.add(vel.copy());
        datoCampo.add(campoTotal(pos).copy());
      }
    }

    if ((pos.x > 550|| pos.x < -550 || pos.y > 550|| pos.y < -550)) {
      simulacion = false;
      estatico = true;

      Simulacion();

      propEstatico.setSelected(true);
      ac = new PVector(0, 0, 0);
      vel = new PVector(0, 0, 0);
      pos.x = pos_.x - r;
      pos.y = pos_.y - r;
      pos.z = 0;

      datoPos.clear();
      datoFuerza.clear();
      datoAc.clear();
      datoTiempo.clear();
      datoVel.clear();
    }
  }
  
  void actualizar() {
    ac = PVector.div(fuerzaE, masa);
    vel.add(ac);
    pos.add(vel);
  }

  float Potencial(PVector punto) {
    float distancia = PVector.dist(pos, punto) * p;

    if (distancia == 0) {
      return Float.POSITIVE_INFINITY; // O manejarlo según corresponda
    }

    return (k * q) / distancia;
  }

  void Potencial() {
    float potencial = 0;

    for (Particula p : particula) {
      if (this != p) {
        potencial += p.Potencial(this.pos);
      }
    }


    this.potencial = potencial;
  }
}
