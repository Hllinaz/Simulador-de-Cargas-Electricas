class Colision {
  PVector pos;
  float width;
  float height;
  
  Colision(PVector pos, float width, float height){
    this.pos = pos;
    this.width = width;
    this.height = height;
  }
  
  Colision(PVector pos, float width, float height, float r){
    this.pos = pos;
    this.pos.x = pos.x - r;
    this.pos.y = pos.y - r;
    this.width = width;
    this.height = height;
  }
  
  boolean detectar(Colision another) {
    return (pos.x < another.pos.x + another.width &&
      pos.x + width > another.pos.x &&
      pos.y < another.pos.y + another.height &&
      pos.y + height > another.pos.y);
  }
  
}
