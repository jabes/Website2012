public class Score {
  
  private int p;
  
  public Score () {
    p = 0;
  }
  
  public void reset () {
    p = 0;
  }
  
  public void increase (int i) {
    p += i;
  }
  
  public void iterate () {
    pushStyle();
    fill(255);
    textFont(fonts.Pro);
    textAlign(LEFT, TOP);
    text("SCORE: " + p, 10, 12);
    popStyle();
  }
  
}
