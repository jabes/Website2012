public class Bullet extends Hitbox {

  private final int speed = 8;
  private int direction;
  private final int walkOffsetY = 13; // help line up the bullets with the players gun
  private final int jumpOffsetY = 15; // help line up the bullets with the players gun
  public boolean isActive;
  private boolean isExploding;
  
  private int explosionWidth;
    
  Animation animateBullet; // master animation object
  Animation animationShootLeft;
  Animation animationShootRight;
  Animation animationExplodeLeft;
  Animation animationExplodeRight;
  
  // x, y, w, h
  private final int[][] spriteTableShootRight = {
    {0, 0, 28, 24},
    {28, 0, 32, 24},
    {60, 0, 38, 24},
    {98, 0, 40, 24},
    {138, 0, 36, 24}
  };
  
  // x, y, w, h
  private final int[][] spriteTableShootLeft = {
    {0, 24, 28, 24},
    {28, 24, 32, 24},
    {60, 24, 38, 24},
    {98, 24, 40, 24},
    {138, 24, 36, 24}
  };
  
  // x, y, w, h
  private final int[][] spriteTableExplodeRight = {
    {0, 48, 20, 20},
    {20, 48, 20, 20},
    {40, 48, 20, 20},
    {60, 48, 20, 20},
    {80, 48, 20, 20},
    {100, 48, 20, 20},
    {120, 48, 20, 20}
  };
  
  // x, y, w, h
  private final int[][] spriteTableExplodeLeft = {
    {0, 68, 20, 20},
    {20, 68, 20, 20},
    {40, 68, 20, 20},
    {60, 68, 20, 20},
    {80, 68, 20, 20},
    {100, 68, 20, 20},
    {120, 68, 20, 20}
  };
  
  public Bullet () {
    animationShootLeft = new Animation(spriteTableShootLeft, graphics.bulletSpriteSheet, 1, 3, false);
    animationShootRight = new Animation(spriteTableShootRight, graphics.bulletSpriteSheet, 1, 3, false);
    animationExplodeLeft = new Animation(spriteTableExplodeLeft, graphics.bulletSpriteSheet, 1, 3, false);
    animationExplodeRight = new Animation(spriteTableExplodeRight, graphics.bulletSpriteSheet, 1, 3, false);
    destroy(); // bullets begin their life dead :)
  }
  
  public void init (float x, float y, int dir) {
    direction = dir;
    // note: last frame is true dimensional size
    super.sizeWidth = (direction == 1) ? spriteTableShootRight[spriteTableShootRight.length - 1][2] : spriteTableShootLeft[spriteTableShootLeft.length - 1][2];
    super.sizeHeight = (direction == 1) ? spriteTableShootRight[spriteTableShootRight.length - 1][3] : spriteTableShootLeft[spriteTableShootLeft.length - 1][3];
    super.posX = (dir == 3) ? x - super.sizeWidth : x;
    super.posY = y - (player.isJumping ? jumpOffsetY : walkOffsetY);
    isActive = true;
    isExploding = false;
    // note: last frame is true dimensional size 
    explosionWidth = (direction == 1) ? spriteTableExplodeRight[spriteTableExplodeRight.length - 1][2] : spriteTableExplodeLeft[spriteTableExplodeLeft.length - 1][2];
  }
  
  //public void reset () {}
  
  public void destroy () {
    isActive = false; // we set this to equal true when the player shoots
    isExploding = false;
    direction = 0;
    super.sizeWidth = super.sizeHeight = 0;
    super.posX = super.posY = -999;
    animateBullet = null;
    animationShootLeft.reset();
    animationShootRight.reset();
    animationExplodeLeft.reset();
    animationExplodeRight.reset();
  }
  
  public void explode (int x) {
    super.posX = x; // align with walls
    isExploding = true;
  }
  
  public void iterate () {
    
    // 0 = top
    // 1 = right
    // 2 = bottom
    // 3 = left
    
    
    if (!isExploding) {
      
      if (direction == 1) super.posX += speed;
      else if (direction == 3) super.posX -= speed; 
      
      if (super.posX < (0 - world.posX - super.sizeWidth) || super.posX > (globals.viewportWidth - world.posX)) { // no longer within viewport (direction is irrelevant)
        destroy(); 
      } else if (direction == 1 && (super.posX + super.sizeWidth) < world.mapWidth) { // RIGHT - only test collisions while within viewport
        int[] tileTopRight = world.getTileByCoords(super.posX + super.sizeWidth, super.posY);
        int[] tileBottomRight = world.getTileByCoords(super.posX + super.sizeWidth, super.posY + super.sizeHeight);
        if (!world.isWalkable(tileTopRight[0], tileTopRight[1])) explode(tileTopRight[0] * world.tileWidth - explosionWidth); // top right corner is touching a tile
        else if (!world.isWalkable(tileBottomRight[0], tileBottomRight[1])) explode(tileBottomRight[0] * world.tileWidth - explosionWidth); // bottom right corner is touching a tile
      } else if (direction == 3 && super.posX > 0) { // LEFT - only test collisions while within viewport
        int[] tileTopLeft = world.getTileByCoords(super.posX, super.posY);
        int[] tileBottomLeft = world.getTileByCoords(super.posX, super.posY + super.sizeHeight);
        if (!world.isWalkable(tileTopLeft[0], tileTopLeft[1])) explode(tileTopLeft[0] * world.tileWidth + world.tileWidth); // top left corner is touching a tile
        else if (!world.isWalkable(tileBottomLeft[0], tileBottomLeft[1])) explode(tileBottomLeft[0] * world.tileWidth + world.tileWidth); // bottom left corner is touching a tile   
      }
    }
    
    if (isActive) moveBullet(super.posX, super.posY);

  }

  private void moveBullet (float x, float y) {
    
    // 0 = top
    // 1 = right
    // 2 = bottom
    // 3 = left
    
    int offsetX = 0;
    
    if (direction == 1) { // RIGHT
      if (isExploding) animateBullet = animationExplodeRight; 
      else animateBullet = animationShootRight;
    } else if (direction == 3) { // LEFT
      if (isExploding) animateBullet = animationExplodeLeft; 
      else animateBullet = animationShootLeft;
    }
    
    animateBullet.run();
    
    if (isExploding && animateBullet.frame >= animateBullet.spriteTable.length - 1) destroy();
    else {
      if (!isExploding && direction == 1) offsetX = super.sizeWidth - animateBullet.spriteWidth; // align sprite to right of bounding box
      image(animateBullet.spriteBlock, x + offsetX, y, animateBullet.spriteWidth, animateBullet.spriteHeight);
    }
    
    
  
  }
  
  

}
