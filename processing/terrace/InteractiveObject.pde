public abstract class InteractiveObject extends Hitbox {

  final int tileX;
  final int tileY;
  int spriteX;
  int spriteY;
  final int alignment;

  PImage spriteBlock;
  
  boolean isAvailable = true;

  InteractiveObject (int a, int b, int c, int d, int e, int f, int g) {
    tileX = a;
    tileY = b;
    spriteX = c;
    spriteY = d;
    super.sizeWidth = e;
    super.sizeHeight = f;
    alignment = g;
    spriteBlock = graphics.interativeObjectSpriteSheet.get(spriteX, spriteY, sizeWidth, sizeHeight);
  }

  abstract void init();
  abstract void reset();
  abstract void destroy();
  abstract void iterate();

  void calcPosition () {
    
    /* 
    ALIGNMENT CHART
    1 = top left
    2 = top middle
    3 = top right
    4 = middle right
    5 = bottom right
    6 = bottom middle
    7 = bottom left
    8 = middle left
    */
    
    switch (alignment) {
    case 1:
      super.posX = tileX * world.tileWidth;
      super.posY = tileY * world.tileHeight;
      break;
    case 2:
      super.posX = (tileX * world.tileWidth) + (world.tileWidth / 2) - (sizeWidth / 2);
      super.posY = tileY * world.tileHeight;
      break;
    case 3:
      super.posX = (tileX * world.tileWidth) + world.tileWidth - sizeWidth;
      super.posY = tileY * world.tileHeight;
      break;
    case 4:
      super.posX = (tileX * world.tileWidth) + world.tileWidth - sizeWidth;
      super.posY = (tileY * world.tileHeight) + (world.tileHeight / 2) - (sizeHeight / 2);
      break;
    case 5:
      super.posX = (tileX * world.tileWidth) + world.tileWidth - sizeWidth;
      super.posY = (tileY * world.tileHeight) + world.tileHeight - sizeHeight;
      break;
    case 6:
      super.posX = (tileX * world.tileWidth) + (world.tileWidth / 2) - (sizeWidth / 2);
      super.posY = (tileY * world.tileHeight) + world.tileHeight - sizeHeight;
      break;
    case 7:
      super.posX = tileX * world.tileWidth;
      super.posY = (tileY * world.tileHeight) + world.tileHeight - sizeHeight;
      break;
    case 8:
      super.posX = tileX * world.tileWidth;
      super.posY = (tileY * world.tileHeight) + (world.tileHeight / 2) - (sizeHeight / 2);
      break;
    }
    
  }
}

