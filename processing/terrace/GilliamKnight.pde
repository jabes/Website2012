public class GilliamKnight extends Enemy {

  private final int sizeDetectionWidth = 45;
  private final int sizeDetectionHeight = 56;

  private int perishLength;

  private Animation animateWalk; // master animation object
  private Animation animatePerish; // master animation object
  private Animation animationWalkLeft;
  private Animation animationWalkRight;
  private Animation animationPerishLeft;
  private Animation animationPerishRight;

  private final int[][] spriteTableWalkLeft = {
    {0, 0, 45, 56}, 
    {45, 0, 45, 56}, 
    {90, 0, 45, 56}
  };

  private final int[][] spriteTableWalkRight = {
    {0, 56, 45, 56}, 
    {45, 56, 45, 56}, 
    {90, 56, 45, 56}
  };

  private final int[][] spriteTablePerishLeft = {
    {0, 0, 45, 56}, 
    {45, 112, 45, 56}
  };

  private final int[][] spriteTablePerishRight = {
    {0, 56, 45, 56}, 
    {0, 112, 45, 56}
  };

  public GilliamKnight (int tileX, int tileY) {
    super(tileX, tileY);
    super.sizeWidth = this.sizeDetectionWidth;
    super.sizeHeight = this.sizeDetectionHeight;
    this.animationWalkLeft = new Animation(this.spriteTableWalkLeft, graphics.gilliamKnightSpriteSheet, 0, 4, true);
    this.animationWalkRight = new Animation(this.spriteTableWalkRight, graphics.gilliamKnightSpriteSheet, 0, 4, true);
    this.animationPerishLeft = new Animation(this.spriteTablePerishLeft, graphics.gilliamKnightSpriteSheet, 0, 2, true);
    this.animationPerishRight = new Animation(this.spriteTablePerishRight, graphics.gilliamKnightSpriteSheet, 0, 2, true);
    this.init(tileX, tileY);
  }

  private void init (int tileX, int tileY) {
    super.init(tileX, tileY);
    super.direction = 1; // start facing right
    this.perishLength = 20;
    this.animateWalk = null;
    this.animatePerish = null;
  }

  public void reset () {
    this.animationWalkLeft.reset();
    this.animationWalkRight.reset();
    this.animationPerishLeft.reset();
    this.animationPerishRight.reset();
    this.init(super.spawnTileX, super.spawnTileY);
  }

  public void destroy () {
    super.isAlive = false;
    super.isExploding = true;
    sounds.playAudio(sounds.kill);
    score.increase(5);
  }

  public void iterate () {

    // 0 = top
    // 1 = right
    // 2 = bottom
    // 3 = left

    if (isAlive) {

      if (super.direction == 1) super.speedX = 3;
      else if (super.direction == 3) super.speedX = -3;

      super.newPosX = super.posX + super.speedX;

      int adjTileLeft = floor((super.newPosX - 1 - super.tilePadding) / world.tileWidth);
      int adjTileRight = floor((super.newPosX + super.sizeWidth + super.tilePadding) / world.tileWidth);

      boolean movableRight = true;
      boolean movableLeft = true;
      boolean touchingRightTile = false;
      boolean touchingLeftTile = false;
      boolean touchingViewportRight = false;
      boolean touchingViewportLeft = false;

      // touching left of viewport
      if (super.newPosX < 0 + super.tilePadding) { 
        touchingViewportLeft = true; 
        super.newPosX = 0 + super.tilePadding;
      }

      // touching right of viewport
      if (super.newPosX >= world.mapWidth - super.sizeWidth - super.tilePadding) { 
        touchingViewportRight = true; 
        super.newPosX = world.mapWidth - super.sizeWidth - super.tilePadding;
      }

      int[] currentTile = world.getTileByCoords(super.newPosX + (super.sizeWidth / 2), super.posY + (super.sizeHeight / 2));

      // LEFT
      if (
      !world.isWalkable(adjTileLeft, currentTile[1])
        || world.isWalkable(adjTileLeft, currentTile[1] + 1)
        ) touchingLeftTile = true;

      // RIGHT
      if (
      !world.isWalkable(adjTileRight, currentTile[1])
        || world.isWalkable(adjTileRight, currentTile[1] + 1)
        ) touchingRightTile = true;

      // moving right
      if (super.speedX >= 0) movableRight = !touchingRightTile && !touchingViewportRight;
      // moving left
      if (super.speedX <= 0) movableLeft = !touchingLeftTile && !touchingViewportLeft;

      // change direction
      if (!movableLeft || !movableRight) {
        super.speedX *= -1; 
        super.newPosX = super.posX + super.speedX;
      }
      
      moveEnemy(super.newPosX, super.posY);
    
    } else if (isExploding) {
      
      if (super.speedX > 0) animatePerish = this.animationPerishRight;
      else if (super.speedX < 0) animatePerish = this.animationPerishLeft;
      
      animatePerish.run();
      
      // the hit detection dimensions may be smaller than that of the drawing dimensions
      // offset the sprite so that it centers in the hit box
      // note: we do not offset the vertical value because the sprites are aligned to the top of their frames
      final int offsetX = (animatePerish.spriteWidth - super.sizeWidth) / 2;
      
      image(animatePerish.spriteBlock, super.posX - offsetX, super.posY, animatePerish.spriteWidth, animatePerish.spriteHeight);
        
      perishLength--;
      if (perishLength <= 0) isExploding = false;
      
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

    if (super.speedX < 0) newDirection = 3;
    else if (super.speedX > 0) newDirection = 1;    
    else newDirection = super.direction;

    if (newDirection != super.direction) {
      this.animationWalkRight.reset();
      this.animationWalkLeft.reset();
    }

    super.direction = newDirection;
    
    if (super.direction == 1) animateWalk = this.animationWalkRight;
    else if (super.direction == 3) animateWalk = this.animationWalkLeft;
    
    if (world.isDrawable(floor((super.posX + (super.sizeWidth / 2)) / world.tileWidth), 2)) {
    
      animateWalk.run();
  
      // the hit detection dimensions may be smaller than that of the drawing dimensions
      // offset the sprite so that it centers in the hit box
      // note: we do not offset the vertical value because the sprites are aligned to the top of their frames
      final int offsetX = (animateWalk.spriteWidth - super.sizeWidth) / 2;
  
      image(animateWalk.spriteBlock, super.posX - offsetX, super.posY, animateWalk.spriteWidth, animateWalk.spriteHeight);
    
    }
  }
}

