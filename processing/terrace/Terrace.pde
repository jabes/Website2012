/* @pjs preload="resources/graphics/bullet-sprite.gif,
                 resources/graphics/volume.png,
                 resources/graphics/objects-tileset.gif,
                 resources/graphics/enemy-sprite-gilliam-knight.gif,
                 resources/graphics/enemy-sprite-kintot.gif,
                 resources/graphics/menu-backdrop-red.png,
                 resources/graphics/menu-backdrop-blue.png,
                 resources/graphics/menu-title.png,
                 resources/graphics/player-sprite.gif,
                 resources/graphics/game-backdrop.png,
                 resources/graphics/world-tileset.png"; */

PApplet applet;
Globals globals;
Graphics graphics;
Fonts fonts;
Mouse mouse;
Keyboard keyboard;
Sounds sounds;
Player player;
Sky sky;
World world;
Score score;
ScoreCard scorecard;
Game game;
Menu menu;

void setup () {

  applet = this;
  globals = new Globals();

  applet.size(globals.viewportWidth, globals.viewportHeight);
  applet.noSmooth();
  applet.noStroke();

  graphics = new Graphics();
  sounds = new Sounds(applet);
  game = new Game();
  menu = new Menu();
  fonts = new Fonts();
  mouse = new Mouse();
  keyboard = new Keyboard();
  sky = new Sky();
  world = new World(60, 60);
  player = new Player();
  score = new Score();
  scorecard = new ScoreCard();
  
  sounds.mute();
  menu.show();
  
}

void draw () {
  
  applet.background(0);
  
  mouse.cursor = ARROW; // reset every draw (evaluated in code below)
  
  if (game.isRunning) {
    if (player.isAlive) {
      game.iterate();
    } else {
      game.stop();
      scorecard.show();
      player.reset();
    }
  } else if (menu.isOpen) {
    menu.iterate();
  } else if (scorecard.isOpen) {
    scorecard.iterate();
  }
  
  cursor(mouse.cursor);
  if (mouse.wasClicked) mouse.reset();

}

void keyPressed () {
  keyboard.pressed(keyCode);
}

void keyReleased () {
  keyboard.released(keyCode);
}

void mousePressed () {
  mouse.pressed();
}

void mouseReleased () {
  mouse.released();
}

void mapFileSelected (File selection) {
  if (selection == null) {
    //println("Window was closed or the user hit cancel.");
  } else {
    String[] data = loadStrings(selection);
    if (data != null) {
      
      String dataType = "";
      int lineCount = 0;
      ArrayList newInteractiveObjectData = new ArrayList();
      ArrayList newEnemyData = new ArrayList();
      int[][] newMapData = new int[10][1];
      int newSpawnTileX = 0;
      int newSpawnTileY = 0;
      
      for (int i = 0; i < data.length; i++) {
        
        if (data[i].substring(0, 1).equals(globals.groupDelimiter)) {
          // determine if delimiter is succeeded by characters
          if (!data[i].substring(1).equals("")) dataType = data[i].substring(1);
          lineCount = 0;
        } else {
          
          int[] rowData = int(split(data[i], globals.inlineDelimiter));
          
          if (dataType.equals("PLAYER")) {
            newSpawnTileX = rowData[0];
            newSpawnTileY = rowData[1];
          } else if (dataType.equals("BLOCKS")) {
            newMapData[lineCount] = expand(newMapData[lineCount], rowData.length);
            arrayCopy(rowData, newMapData[lineCount]);
          } else if (dataType.equals("OBJECTS")) {
            newInteractiveObjectData.add(rowData);
          } else if (dataType.equals("ENEMIES")) {
            newEnemyData.add(rowData);
          }
          
          lineCount++;
        }
        
      }
      
      // there is probably a better way to do this
      int[][] convertedInteractiveObjectData = new int[newInteractiveObjectData.size()][4];
      for (int i = 0; i < newInteractiveObjectData.size(); i++) convertedInteractiveObjectData[i] = (int[]) newInteractiveObjectData.get(i);
      
      int[][] convertedEnemyData = new int[newEnemyData.size()][3];
      for (int i = 0; i < newEnemyData.size(); i++) convertedEnemyData[i] = (int[]) newEnemyData.get(i);
      
      player.init(newSpawnTileX, newSpawnTileY);
      world.init(newMapData);
      game.init(convertedInteractiveObjectData, convertedEnemyData); 
      game.start();
      
    } else {
      menu.show();
    }
  }
}

