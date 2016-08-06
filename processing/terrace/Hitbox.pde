public abstract class Hitbox {
  
  float posX, posY;
  int sizeWidth, sizeHeight;
  
  public boolean isTouching (float x, float y, int w, int h) {
    return (
      (
        // top left corner
        posX >= x 
        && posX <= x + w
        && posY >= y
        && posY <= y + h
      )
      || (
        // top right corner
        posX + sizeWidth >= x 
        && posX + sizeWidth <= x + w
        && posY >= y
        && posY <= y + h
      )
      || (
        // bottom left corner
        posX >= x 
        && posX <= x + w
        && posY + sizeHeight >= y
        && posY + sizeHeight <= y + h
      )
      || (
        // bottom right corner
        posX + sizeWidth >= x 
        && posX + sizeWidth <= x + w
        && posY + sizeHeight >= y
        && posY + sizeHeight <= y + h
      )
    );
  }
  
}
