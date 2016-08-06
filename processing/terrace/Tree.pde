private class Tree extends InteractiveObject {

  Animation animateTree;
  final int[][] spriteTable = {
    {0, 60, 128, 121},
    {128, 60, 128, 121},
    {256, 60, 128, 121},
    {384, 60, 128, 121},
    {512, 60, 128, 121},
    {0, 181, 128, 121},
    {128, 181, 128, 121},
    {256, 181, 128, 121},
    {384, 181, 128, 121},
    {512, 181, 128, 121}
  };
  
  Tree (int a, int b, int c) {
    super(a, b, 0, 60, 128, 121, c);
    animateTree = new Animation(spriteTable, graphics.interativeObjectSpriteSheet, 0, 10, true);
    super.calcPosition();
    init();
  }

  void init () {}

  void reset () {
    animateTree.reset();
    init();
  }

  void destroy () {
    reset();
  }

  void iterate () {
    animateTree.run();
    super.spriteBlock = animateTree.spriteBlock;
  }
  
}

