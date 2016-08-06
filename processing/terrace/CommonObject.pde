private class CommonObject extends InteractiveObject {
  
  CommonObject (int a, int b, int c, int d, int e, int f, int g) {
    super(a, b, c, d, e, f, g);
    super.calcPosition();
  }

  void init () {}
  void reset () {}
  void destroy () {}
  void iterate () {}
  
}

