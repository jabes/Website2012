public class Keyboard {
  
  public boolean keyUp;
  public boolean keyDown;
  public boolean keyLeft;
  public boolean keyRight;
  public boolean keyControl;
  public boolean keySpace;
  public boolean keyZ;
  public boolean keyX;

  public Keyboard () {
    keyUp = false;
    keyDown = false;
    keyLeft = false;
    keyRight = false;
    keyControl = false;
    keySpace = false;
    keyZ = false;
    keyX = false;
  }

  public void pressed (int code) {
    //println("KEY PRESSED: " + code);
    if (code == UP) keyUp = true;
    else if (code == DOWN) keyDown = true;
    else if (code == LEFT) keyLeft = true;
    else if (code == RIGHT) keyRight = true;
    else if (code == CONTROL) keyControl = true;
    else if (code == 32) keySpace = true;
    else if (code == 90) keyZ = true;
    else if (code == 88) keyX = true;
}
  
  public void released (int code) {
    if (code == UP) keyUp = false;
    if (code == DOWN) keyDown = false;
    else if (code == LEFT) keyLeft = false;
    else if (code == RIGHT) keyRight = false;
    else if (code == CONTROL) keyControl = false;
    else if (code == 32) keySpace = false;
    else if (code == 90) keyZ = false;
    else if (code == 88) keyX = false;
  }
  
}
