public class Kintot extends Enemy {

  private final int sizeDetectionWidth = 27;
  private final int sizeDetectionHeight = 32;
  
  private Animation animateEnemy; // master animation object
  private Animation animationMoveUp;
  private Animation animationMoveDown;
  
  private int msJumpCooldown;
  private boolean isActive;
  
  private final int[][] spriteTableMoveUp = {
    {0, 0, 27, 32}, 
    {0, 32, 27, 32}, 
    {0, 64, 27, 32},
    {0, 96, 27, 32},
    {0, 128, 27, 32}
  };

  private final int[][] spriteTableMoveDown = {
    {27, 0, 27, 32}, 
    {27, 32, 27, 32}, 
    {27, 64, 27, 32},
    {27, 96, 27, 32},
    {27, 128, 27, 32}
  };

  public Kintot (int tileX, int tileY) {
    super(tileX, tileY);
    super.sizeWidth = this.sizeDetectionWidth;
    super.sizeHeight = this.sizeDetectionHeight;
    this.animationMoveUp = new Animation(this.spriteTableMoveUp, graphics.kintotSpriteSheet, 0, 4, true);
    this.animationMoveDown = new Animation(this.spriteTableMoveDown, graphics.kintotSpriteSheet, 0, 4, true);
    this.init(tileX, tileY);
  }

  private void init (int tileX, int tileY) {
    super.init(tileX, tileY);
    super.direction = 0; // start facing up
    this.msJumpCooldown = 0;
    this.animateEnemy = null;
    this.isActive = true;
  }

  public void reset () {
    this.animationMoveUp.reset();
    this.animationMoveDown.reset();
    this.init(super.spawnTileX, super.spawnTileY);
  }
  
  public void destroy () {}
  /*
  public void destroy () {
    super.isAlive = false;
    super.isExploding = true;
    sounds.playAudio(sounds.kill);
    score.add(5);
  }
  */

  public void iterate () {

    // 0 = top
    // 1 = right
    // 2 = bottom
    // 3 = left

    if (isActive) {

      //if (super.direction == 0) super.speedY = -3; // UP
      //else if (super.direction == 2) super.speedY = 3; // DOWN
      
      super.speedY += globals.gravity;

      super.newPosX = super.posX;
      super.newPosY = super.posY + super.speedY;

      //int adjTileUp = floor((super.newPosY - 1 - super.tilePadding) / world.tileHeight);
      //int adjTileDown = floor((super.newPosY + super.sizeHeight + super.tilePadding) / world.tileHeight);
      
      
      if (super.newPosY > globals.viewportHeight) {
        super.newPosY = globals.viewportHeight;
        super.speedY = 0;
        this.msJumpCooldown = floor(random(20, 100));
        this.isActive = false;
      }
      
      moveEnemy(super.newPosX, super.newPosY);

      
    } else {
      
      if (this.msJumpCooldown > 0) this.msJumpCooldown--;
      else {
        super.speedY = -14;
        this.msJumpCooldown = 0;
        this.isActive = true;
      } 
      
    }
    
  }

  void moveEnemy (float x, float y) {

    // 0 = top
    // 1 = right
    // 2 = bottom
    // 3 = left

    int newDirection = 0;

    super.posX = x;
    super.posY = y;

    if (super.speedY < 0) newDirection = 0;
    else if (super.speedY > 0) newDirection = 2;
    else newDirection = super.direction;

    if (newDirection != super.direction) {
      this.animationMoveUp.reset();
      this.animationMoveDown.reset();
    }

    super.direction = newDirection;
    
    if (world.isDrawable(super.spawnTileX, 1)) { // use the spawn tile since this enemy does not move horizontally
      
      if (super.direction == 0) this.animateEnemy = this.animationMoveUp;
      else if (super.direction == 2) this.animateEnemy = this.animationMoveDown;
  
      this.animateEnemy.run();
  
      image(this.animateEnemy.spriteBlock, super.posX, super.posY, this.animateEnemy.spriteWidth, this.animateEnemy.spriteHeight);
    
    }
    
  }
}

