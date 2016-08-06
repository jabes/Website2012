public class Player extends Hitbox {
  
  private final float acceleration = 0.35;
  private final float deceleration = 0.20;
  private final float jumpForce = -6;
  private final float maxSpeedX = 4;
  
  // hit detection in pixels between tile and player
  // caution: do not allow player padding + dimensions to exceed tile dimensions 
  private final int tilePadding = 2;
  
  private int direction;
  
  private final int defaultSpawnTileX = 0;
  private final int defaultSpawnTileY = 5;
  // note: subject to change when importing maps
  int spawnTileX;
  int spawnTileY;
  
  private float newPosX;
  private float newPosY;
  private float speedX;
  private float speedY;
  private float currSpeedX;
  private float currSpeedY;
  
  private boolean isJumping;
  private boolean isShooting;
  public boolean isAlive;
  
  private int gunInterval; // measured in frames
  private final int gunCooldown = 6; // measured in frames
  
  private Animation animatePlayer; // master animation object
  private Animation animationWalkLeft;
  private Animation animationWalkRight;
  private Animation animationJumpLeft;
  private Animation animationJumpRight;
  private Animation animationShootWalkLeft;
  private Animation animationShootWalkRight;
  private Animation animationShootJumpLeft;
  private Animation animationShootJumpRight;
  
  private int[] currTopLeftTile;
  private int[] currTopRightTile; 
  private int[] currBottomLeftTile; 
  private int[] currBottomRightTile; 
  private int[] currLeftBottomTile;
  private int[] currLeftTopTile;
  private int[] currRightBottomTile;
  private int[] currRightTopTile;
  
  private final int[][] spriteTableWalkRight = {
    {0, 0, 44, 44},
    {44, 0, 44, 44},
    {88, 0, 44, 44},
    {132, 0, 44, 44},
    {176, 0, 44, 44},
    {220, 0, 44, 44},
    {264, 0, 44, 44},
    {308, 0, 44, 44},
    {352, 0, 44, 44},
    {396, 0, 44, 44},
    {440, 0, 44, 44}
  };
  
  private final int[][] spriteTableWalkLeft = {
    {0, 44, 44, 44},
    {44, 44, 44, 44},
    {88, 44, 44, 44},
    {132, 44, 44, 44},
    {176, 44, 44, 44},
    {220, 44, 44, 44},
    {264, 44, 44, 44},
    {308, 44, 44, 44},
    {352, 44, 44, 44},
    {396, 44, 44, 44},
    {440, 44, 44, 44}
  };
  
  private final int[][] spriteTableShootWalkRight = {
    {0, 200, 44, 44},
    {44, 200, 44, 44},
    {88, 200, 44, 44},
    {132, 200, 44, 44},
    {176, 200, 44, 44},
    {220, 200, 44, 44},
    {264, 200, 44, 44},
    {308, 200, 44, 44},
    {352, 200, 44, 44},
    {396, 200, 44, 44},
    {440, 200, 44, 44}
  };
  
  private final int[][] spriteTableShootWalkLeft = {
    {0, 244, 44, 44},
    {44, 244, 44, 44},
    {88, 244, 44, 44},
    {132, 244, 44, 44},
    {176, 244, 44, 44},
    {220, 244, 44, 44},
    {264, 244, 44, 44},
    {308, 244, 44, 44},
    {352, 244, 44, 44},
    {396, 244, 44, 44},
    {440, 244, 44, 44}
  };
  
  private final int[][] spriteTableJumpRight = {
    {0, 88, 44, 56},
    {44, 88, 44, 56},
    {88, 88, 44, 56},
    {132, 88, 44, 56},
    {176, 88, 44, 56}
  };
  
  private final int[][] spriteTableJumpLeft = {
    {0, 144, 44, 56},
    {44, 144, 44, 56},
    {88, 144, 44, 56},
    {132, 144, 44, 56},
    {176, 144, 44, 56}
  };
  
  private final int[][] spriteTableShootJumpRight = {
    {0, 288, 44, 56},
    {44, 288, 44, 56},
    {88, 288, 44, 56},
    {132, 288, 44, 56},
    {176, 288, 44, 56}
  };
  
  private final int[][] spriteTableShootJumpLeft = {
    {0, 344, 44, 56},
    {44, 344, 44, 56},
    {88, 344, 44, 56},
    {132, 344, 44, 56},
    {176, 344, 44, 56}
  };
  
  public Player () {
    
    // note: player dimensions cannot exceed tile dimensions
    super.sizeWidth = 32;
    super.sizeHeight = 38;
    
    currTopLeftTile = new int[2];
    currTopRightTile = new int[2];
    currBottomLeftTile = new int[2];
    currBottomRightTile = new int[2];
    currLeftBottomTile = new int[2];
    currLeftTopTile = new int[2];
    currRightBottomTile = new int[2];
    currRightTopTile = new int[2];
    
    animationWalkLeft = new Animation(spriteTableWalkLeft, graphics.playerSpriteSheet, 1, 3, true); // exclude first frame because it is not part of the running animation
    animationWalkRight = new Animation(spriteTableWalkRight, graphics.playerSpriteSheet, 1, 3, true); // exclude first frame because it is not part of the running animation
    animationJumpLeft = new Animation(spriteTableJumpLeft, graphics.playerSpriteSheet, 0, 3, false);
    animationJumpRight = new Animation(spriteTableJumpRight, graphics.playerSpriteSheet, 0, 3, false);
    animationShootWalkLeft = new Animation(spriteTableShootWalkLeft, graphics.playerSpriteSheet, 1, 3, true); // exclude first frame because it is not part of the running animation
    animationShootWalkRight = new Animation(spriteTableShootWalkRight, graphics.playerSpriteSheet, 1, 3, true); // exclude first frame because it is not part of the running animation
    animationShootJumpLeft = new Animation(spriteTableShootJumpLeft, graphics.playerSpriteSheet, 0, 3, false);
    animationShootJumpRight = new Animation(spriteTableShootJumpRight, graphics.playerSpriteSheet, 0, 3, false);
    
  }
  
  private void init (int tileX, int tileY) {
    //println("PLAYER INIT");
    spawnTileX = tileX;
    spawnTileY = tileY;
    direction = 1; // start facing right
    speedX = speedY = 0;
    isJumping = true; // player starts in the air
    isShooting = false;
    isAlive = true;
    super.posX = (spawnTileX * world.tileWidth) + (world.tileWidth / 2) - (super.sizeWidth / 2);
    super.posY = (spawnTileY * world.tileHeight) + (world.tileHeight / 2) - (super.sizeHeight / 2);
    gunInterval = 0;
    animationJumpRight.setFrame(4); // start at end of animation
    animatePlayer = animationJumpRight; // player starts in the air facing right 
  }
  
  public void reset () {
    //println("PLAYER RESET");
    animationWalkLeft.reset();
    animationWalkRight.reset();
    animationJumpLeft.reset();
    animationJumpRight.reset();
    animationShootWalkLeft.reset();
    animationShootWalkRight.reset();
    animationShootJumpLeft.reset();
    animationShootJumpRight.reset();
  }
  
  public void destroy () {
    isAlive = false;
    sounds.playAudio(sounds.die);
  }

  public void iterate () {
    
    if (keyboard.keyLeft) speedX -= acceleration;
    if (keyboard.keyRight) speedX += acceleration;
    
    if ((keyboard.keyUp || keyboard.keySpace || keyboard.keyX) && !isJumping && speedY == 0) {
      speedY = jumpForce;
      isJumping = true;
      sounds.playAudio(sounds.jump);
    }

    if (keyboard.keyControl || keyboard.keyZ) {
      isShooting = true;
      shoot(direction);
    } else isShooting = false;
    
    speedY += globals.gravity;
    if (speedY > 0 || speedY < 0) isJumping = true;
    
    // calculate horizontal momentum (LEFT)
    if (speedX < 0) {
      if (speedX + deceleration > 0) speedX = 0;
      else speedX += deceleration;
    }
    
    // calculate horizontal momentum (RIGHT)
    if (speedX > 0) {
      if (speedX - deceleration < 0) speedX = 0;
      else speedX -= deceleration;
    }
    
    if (speedX > maxSpeedX) speedX = maxSpeedX;
    else if (speedX < maxSpeedX * -1) speedX = maxSpeedX * -1;
    
  
    // apply new positional coords to player   
    newPosX = super.posX + speedX;
    newPosY = super.posY + speedY;
    
    
    // get tile numbers adjacent to the player
    int adjTileUp = floor((newPosY - 1 - tilePadding) / world.tileHeight);
    int adjTileDown = floor((newPosY + super.sizeHeight + tilePadding) / world.tileHeight);
    int adjTileLeft = floor((newPosX - 1 - tilePadding) / world.tileWidth);
    int adjTileRight = floor((newPosX + super.sizeWidth + tilePadding) / world.tileWidth);
    
    
    int[] topLeftTile = world.getTileByCoords(newPosX - tilePadding, newPosY - 1 - tilePadding);
    int[] topRightTile = world.getTileByCoords(newPosX + super.sizeWidth - 1 + tilePadding, newPosY - 1 - tilePadding);
    int[] bottomLeftTile = world.getTileByCoords(newPosX - tilePadding, newPosY + super.sizeHeight + tilePadding);
    int[] bottomRightTile = world.getTileByCoords(newPosX + super.sizeWidth - 1 + tilePadding, newPosY + super.sizeHeight + tilePadding);
    int[] leftBottomTile = world.getTileByCoords(newPosX - 1 - tilePadding, newPosY + super.sizeHeight - 1 + tilePadding);
    int[] leftTopTile = world.getTileByCoords(newPosX - 1 - tilePadding, newPosY - tilePadding);
    int[] rightBottomTile = world.getTileByCoords(newPosX + super.sizeWidth + tilePadding, newPosY + super.sizeHeight - 1 + tilePadding);
    int[] rightTopTile = world.getTileByCoords(newPosX + super.sizeWidth + tilePadding, newPosY - tilePadding);


    
    /*
    stroke(0, 0, 0);
    point(newPosX - tilePadding, newPosY - 1 - tilePadding); // topLeftTile
    point(newPosX + super.sizeWidth - 1 + tilePadding, newPosY - 1 - tilePadding); // topRightTile
    point(newPosX - tilePadding, newPosY + super.sizeHeight + tilePadding); // bottomLeftTile
    point(newPosX + super.sizeWidth - 1 + tilePadding, newPosY + super.sizeHeight + tilePadding); // bottomRightTile
    point(newPosX - 1 - tilePadding, newPosY + super.sizeHeight - 1 + tilePadding); // leftBottomTile
    point(newPosX - 1 - tilePadding, newPosY - tilePadding); // leftTopTile
    point(newPosX + super.sizeWidth + tilePadding, newPosY + super.sizeHeight - 1 + tilePadding); // rightBottomTile
    point(newPosX + super.sizeWidth + tilePadding, newPosY - tilePadding); // rightTopTile
    noStroke();
    */
    
    boolean movableRight = true;
    boolean movableLeft = true;
    boolean movableDown = true;
    boolean movableUp = true;
    boolean touchingRightTile = false;
    boolean touchingLeftTile = false;
    boolean touchingBottomTile = false;
    boolean touchingTopTile = false;
    boolean touchingViewportRight = false;
    boolean touchingViewportLeft = false;
    boolean touchingViewportBottom = false;
    boolean touchingViewportTop = false;
    
    // touching top of viewport
    if (newPosY < 0 + tilePadding) { 
      touchingViewportTop = true;
      newPosY = 0 + tilePadding;
    }
    // touching bottom of viewport    
    if (newPosY >= world.mapHeight - super.sizeHeight - tilePadding) { 
      touchingViewportBottom = true; 
      newPosY = world.mapHeight - super.sizeHeight - tilePadding; 
    }
    // touching left of viewport
    if (newPosX < 0 + tilePadding) { 
      touchingViewportLeft = true; 
      newPosX = 0 + tilePadding; 
    }
    // touching right of viewport
    if (newPosX >= world.mapWidth - super.sizeWidth - tilePadding) { 
      touchingViewportRight = true; 
      newPosX = world.mapWidth - super.sizeWidth - tilePadding; 
    }

    // LEFT
    if (
      (
        !world.isWalkable(leftBottomTile[0], leftBottomTile[1])
        && world.isWalkable(leftBottomTile[0] + 1, leftBottomTile[1])
        && super.posX > ((leftBottomTile[0] * world.tileWidth) + world.tileWidth)
        && (
          leftBottomTile[0] < currLeftBottomTile[0]
          || currSpeedX == 0
        )
      )
      || (
        !world.isWalkable(leftTopTile[0], leftTopTile[1])
        && world.isWalkable(leftTopTile[0] + 1, leftTopTile[1])
        && super.posX > ((leftTopTile[0] * world.tileWidth) + world.tileWidth)
        && (
          leftTopTile[0] < currLeftTopTile[0]
          || currSpeedX == 0
        )
      )
    ) {
      touchingLeftTile = true;
      newPosX = ((adjTileLeft + 1) * world.tileWidth) + tilePadding; 
    }
    
    // RIGHT
    if (
      (
        !world.isWalkable(rightBottomTile[0], rightBottomTile[1])
        && world.isWalkable(rightBottomTile[0] - 1, rightBottomTile[1])
        && (super.posX + super.sizeWidth) < (rightBottomTile[0] * world.tileWidth)
        && (
          rightBottomTile[0] > currRightBottomTile[0]
          || currSpeedX == 0
        )
      )
      || (
        !world.isWalkable(rightTopTile[0], rightTopTile[1])
        && world.isWalkable(rightTopTile[0] - 1, rightTopTile[1])
        && (super.posX + super.sizeWidth) < (rightTopTile[0] * world.tileWidth)
        && (
          rightTopTile[0] > currRightTopTile[0]
          || currSpeedX == 0
        )
      )
    ) {
      touchingRightTile = true;
      newPosX = (adjTileRight * world.tileWidth) - super.sizeWidth - tilePadding; 
    }
    
    // TOP
    if (
      (
        !world.isWalkable(topLeftTile[0], topLeftTile[1]) 
        && world.isWalkable(topLeftTile[0], topLeftTile[1] + 1)
        && super.posY > ((topLeftTile[1] * world.tileHeight) + world.tileHeight)
        && (
          topLeftTile[1] < currTopLeftTile[1]
          || currSpeedY == 0
        )
      )
      || (
        !world.isWalkable(topRightTile[0], topRightTile[1])
        && world.isWalkable(topRightTile[0], topRightTile[1] + 1)
        && super.posY > ((topRightTile[1] * world.tileHeight) + world.tileHeight)
        && (
          topRightTile[1] < currTopRightTile[1] 
          || currSpeedY == 0
        )
      )
    ) {
      touchingTopTile = true;
      newPosY = ((adjTileUp + 1) * world.tileHeight) + tilePadding;
    }
    
    // BOTTOM
    if (
      (
        !world.isWalkable(bottomLeftTile[0], bottomLeftTile[1]) 
        && world.isWalkable(bottomLeftTile[0], bottomLeftTile[1] - 1)
        && (super.posY + super.sizeHeight) < (bottomLeftTile[1] * world.tileHeight)
        && (
          bottomLeftTile[1] > currBottomLeftTile[1]
          || currSpeedY == 0
        )
      )
      || (
        !world.isWalkable(bottomRightTile[0], bottomRightTile[1])
        && world.isWalkable(bottomRightTile[0], bottomRightTile[1] - 1)
        && (super.posY + super.sizeHeight) < (bottomRightTile[1] * world.tileHeight)
        && (
          bottomRightTile[1] > currBottomRightTile[1]
          || currSpeedY == 0
        )
      )
    ) {
      touchingBottomTile = true;
      newPosY = (adjTileDown * world.tileHeight) - super.sizeHeight - tilePadding; 
    }
    
    
    // moving right
    if (speedX >= 0) movableRight = !touchingRightTile && !touchingViewportRight;
    // moving left
    if (speedX <= 0) movableLeft = !touchingLeftTile && !touchingViewportLeft;
    // moving down
    if (speedY >= 0) movableDown  = !touchingBottomTile && !touchingViewportBottom;
    // moving up
    if (speedY <= 0) movableUp = !touchingTopTile && !touchingViewportTop;
 
    
    if (movableRight) {
      arrayCopy(rightTopTile, currRightTopTile);
      arrayCopy(rightBottomTile, currRightBottomTile);
    } else {
      speedX = 0;
    }
    if (movableLeft) { 
      arrayCopy(leftTopTile, currLeftTopTile);
      arrayCopy(leftBottomTile, currLeftBottomTile);
    } else {
      speedX = 0; 
    }
    if (movableDown) { 
      arrayCopy(bottomLeftTile, currBottomLeftTile);
      arrayCopy(bottomRightTile, currBottomRightTile);
    } else {
      speedY = 0; 
    }
    if (movableUp) { 
      arrayCopy(topLeftTile, currTopLeftTile);
      arrayCopy(topRightTile, currTopRightTile);
    } else {
      speedY = 0; 
    }
    
    if (touchingViewportBottom) destroy();
    if (touchingBottomTile) {
      isJumping = false;
      animationJumpLeft.reset();
      animationJumpRight.reset();
      animationShootJumpLeft.reset();
      animationShootJumpRight.reset();
    }
    
    movePlayer(newPosX, newPosY);
    
    currSpeedX = speedX;
    currSpeedY = speedY;
    
  }

  private void movePlayer (float x, float y) {
    
    final int lastAnimationFrame = animatePlayer.frame;
    int newDirection;

    super.posX = x;
    super.posY = y;
    
    if (speedX < 0) newDirection = 3; // LEFT
    else if (speedX > 0) newDirection = 1; // RIGHT
    else newDirection = direction;
    
    if (newDirection == 1) { // RIGHT
      if (isJumping) {
        if (isShooting) animatePlayer = animationShootJumpRight;
        else animatePlayer = animationJumpRight;
      } else {
        if (isShooting) animatePlayer = animationShootWalkRight;
        else animatePlayer = animationWalkRight;
      }
    } else if (newDirection == 3) { // LEFT
      if (isJumping) {
        if (isShooting) animatePlayer = animationShootJumpLeft;
        else animatePlayer = animationJumpLeft;
      } else {
        if (isShooting) animatePlayer = animationShootWalkLeft;
        else animatePlayer = animationWalkLeft;
      }
    }
    
    if (newDirection != direction) {
      if (isJumping) {
        // preserve current jumping frame IF the player WAS jumping previously
        animationJumpLeft.setFrame(lastAnimationFrame);
        animationJumpRight.setFrame(lastAnimationFrame);
        animationShootJumpLeft.setFrame(lastAnimationFrame);
        animationShootJumpRight.setFrame(lastAnimationFrame);
      }
      animationWalkLeft.reset();
      animationWalkRight.reset();
      animationShootWalkLeft.reset();
      animationShootWalkRight.reset();
    }
    
    direction = newDirection;

    if (speedX == 0 && !isJumping) animatePlayer.getFrame(0);
    else animatePlayer.run();
    
    // the hit detection dimensions are smaller than that of the drawing dimensions
    // offset the sprite so that it centers in the hit box
    // note: we do not offset the vertical value because the sprites are aligned to the top of their frames
    final int offsetX = (animatePlayer.spriteWidth - super.sizeWidth) / 2;
    
    image(animatePlayer.spriteBlock, super.posX - offsetX, super.posY, animatePlayer.spriteWidth, animatePlayer.spriteHeight);
    
  }
  
  private void shoot (int dir) {
    
    // 0 = top
    // 1 = right
    // 2 = bottom
    // 3 = left
    
    float halfHeight = super.sizeHeight / 2;
    
    if (gunInterval == 0) {
      for (int i = 0, ii = globals.maxBullets; i < ii; i++) {
        // override an inactive bullet
        if (!game.bullets[i].isActive) {
          if (dir == 1) game.bullets[i].init(super.posX + super.sizeWidth, super.posY + halfHeight, dir); // RIGHT
          else if (dir == 3) game.bullets[i].init(super.posX, super.posY + halfHeight, dir); // LEFT
          sounds.playAudio(sounds.lazer);
          break; // stop looking for inactive bullets
        }
      }
    }
    
    if (gunInterval > gunCooldown) gunInterval = 0;
    else gunInterval += 1;
    
  }
  
  public void bounce (int force) {
    speedY = force * -1;
    sounds.playAudio(sounds.spring);
  }
  
}

