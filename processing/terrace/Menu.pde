public class Menu {
  
  boolean isOpen = false;
  Button playButton;
  Button loadMapButton;
  
  Menu () {
    
    playButton = new Button(globals.viewportHalfWidth - 80, 250, 160, 40, new int[][]{
      {80, 136, 248},
      {62, 75, 102}
    });
    playButton.addText("PLAY GAME");
    
    loadMapButton = new Button(globals.viewportHalfWidth - 80, 300, 160, 40, new int[][]{
      {80, 136, 248},
      {62, 75, 102}
    });
    loadMapButton.addText("LOAD MAP");
    
  }
  
  void show () {
    isOpen = true;
  }
  
  void hide () {
    isOpen = false;
    playButton.reset();
    loadMapButton.reset();
  }
  
  void iterate () {
    
    applet.background(80, 136, 248);
    image(graphics.menuBackdropBlue, 0, globals.viewportHeight - 122, 600, 122);
    image(graphics.menuTitle, globals.viewportHalfWidth - 96, 100, 192, 80);
    
    pushStyle();
    fill(255);
    textFont(fonts.TheSans);
    textAlign(CENTER);
    text("Shoot: \"Ctr\" or \"Z\"", globals.viewportHalfWidth, 400);
    text("Jump: \"Spacebar\" or \"X\" or \"Up Arrow\"", globals.viewportHalfWidth, 420);
    popStyle();
    
    if (playButton.isActive) {
      menu.hide();
      player.init(player.defaultSpawnTileX, player.defaultSpawnTileY);
      world.init(world.mapDataDefault);
      game.init(game.defaultInteractiveObjectData, game.defaultEnemyData);
      game.start();
    } else if (loadMapButton.isActive) {
      menu.hide();
      selectInput("Load Map File...", "mapFileSelected");
    } else {
      playButton.iterate();
      loadMapButton.iterate();
    }
    
  } 
}

