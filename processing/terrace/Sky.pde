public class Sky {
  
  private final int backgroundWidth = 800;
  private final int backgroundHeight = 600;
  private final int xDistance;
  private float xMultiplier;
  private float bgX;
    
  public Sky () {
    xDistance = backgroundWidth - globals.viewportWidth;
  }
  
  public void iterate () {
    // if the map width is less than or the same as the viewport width, a division by zero will occur
    xMultiplier = (world.mapWidth > globals.viewportWidth) ? abs(world.posX) / (world.mapWidth - globals.viewportWidth) : 0;
    bgX = (xDistance * xMultiplier) * -1;      
    image(graphics.gameBackdrop, bgX, 0, backgroundWidth, backgroundHeight);
  }

}
