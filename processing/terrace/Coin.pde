private int coinIncrement = 0;

private class Coin extends InteractiveObject {

  final int coinDestinationY;
  int coinDirection;
  float coinOffsetY;
  float originalPosY;
  Transition easingPosY;
  Animation animateCoin;
  
  final int[][] spriteTable = {
    {96, 28, 16, 16},
    {112, 28, 16, 16},
    {96, 44, 16, 16},
    {112, 44, 16, 16}
  };
  
  Coin (int a, int b, int c) {
    super(a, b, 96, 28, 16, 16, c);
    coinDestinationY = 40;
    easingPosY = new Transition(50, 0, 1, coinIncrement, globals.coinOffsetMultiplier, "easeInOutQuad");
    animateCoin = new Animation(spriteTable, graphics.interativeObjectSpriteSheet, 0, 5, true);
    super.calcPosition();
    originalPosY = super.posY;
    coinIncrement++;
    init();
  }

  void init () {
    coinOffsetY = 0;
    coinDirection = 0;
    easingPosY.init();
  }

  void reset () {
    animateCoin.reset();
    super.isAvailable = true;
    init();
  }

  void destroy () {
    sounds.playAudio(sounds.coin);
    score.increase(1);
    animateCoin.reset();
    super.isAvailable = false;
    init();
  }

  void iterate () {
               
    if (coinDirection == 0) { // EASE UP
      coinOffsetY = easingPosY.value * coinDestinationY;
      if (easingPosY.value == easingPosY.maxValue) coinDirection = 1;
    } 
    else if (coinDirection == 1) { // EASE DOWN
      coinOffsetY = coinDestinationY * (easingPosY.maxValue - easingPosY.value);
      if (easingPosY.value == easingPosY.maxValue) coinDirection = 0;
    }
    
    easingPosY.step();
    animateCoin.run();
    
    super.spriteBlock = animateCoin.spriteBlock;
    super.posY = originalPosY + (coinOffsetY * -1);
    
    if (this.isTouching(player.posX, player.posY, player.sizeWidth, player.sizeHeight)) destroy();
    
  }
 
  
}

