public abstract class Enemy {
  
  private final int tilePadding = 1;
  private int sizeWidth;
  private int sizeHeight;

  private int direction;
  
  private final int spawnTileX;
  private final int spawnTileY;
  private float posX;
  private float posY;
  private float newPosX;
  private float newPosY;
  private float speedX;
  private float speedY;
  
  public boolean isAlive;
  public boolean isExploding;
  
  Enemy (int x, int y) {
    spawnTileX = x;
    spawnTileY = y;
  }
  
  private void init (int tileX, int tileY) {
    speedX = speedY = 0;
    isAlive = true;
    isExploding = false;
    posX = (tileX * world.tileWidth) + (world.tileWidth / 2) - (sizeWidth / 2);
    posY = (tileY * world.tileHeight) + world.tileHeight - sizeHeight - tilePadding; // include tile padding because the enemy is always touching the bottom tile
  }
  
  abstract void reset();
  abstract void destroy();
  abstract void iterate();
  abstract void moveEnemy(float x, float y);
  
}
