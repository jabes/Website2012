private class Spring extends InteractiveObject {

  int cooldown;
  int strength; // player bounce strength
  
  Spring (int a, int b, int c, int d, int e, int f, int g, int h) {
    super(a, b, c, d, e, f, g);
    super.calcPosition();
    strength = h;
    init();
  }

  void init () {
    cooldown = 0;
  }

  void reset () {
    init();
  }

  void destroy () {
    reset();
  }

  void iterate () {
    
    if (player.isTouching(super.posX, super.posY, super.sizeWidth, super.sizeHeight) && player.speedY > 0 && cooldown == 0) {
      player.bounce(strength);
      super.spriteY = 30;
      cooldown = 10;
    } else if (cooldown > 0) {
      cooldown--;
    } else if (super.spriteY > 0) {
      super.spriteY = 0;
    }
    
    super.spriteBlock = graphics.interativeObjectSpriteSheet.get(super.spriteX, super.spriteY, super.sizeWidth, super.sizeHeight);
    
  }
  
}

