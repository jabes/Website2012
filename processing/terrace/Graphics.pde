public class Graphics {

  final PImage bulletSpriteSheet;
  final PImage volumeIcon;
  final PImage interativeObjectSpriteSheet;
  final PImage gilliamKnightSpriteSheet;
  final PImage kintotSpriteSheet;
  final PImage menuBackdropRed;
  final PImage menuBackdropBlue;
  final PImage menuTitle;
  final PImage playerSpriteSheet;
  final PImage gameBackdrop;
  final PImage gameTileSheet;
  
  int startTime;
  int endTime;
  
  // note: sound class also loads external resources
  Graphics () {

    //println("LOADING EXTERNAL GRAPHICS");
    startTime = millis();

    bulletSpriteSheet             = loadImage("resources/graphics/bullet-sprite.gif");
    volumeIcon                    = loadImage("resources/graphics/volume.png");
    interativeObjectSpriteSheet   = loadImage("resources/graphics/objects-tileset.gif");
    gilliamKnightSpriteSheet      = loadImage("resources/graphics/enemy-sprite-gilliam-knight.gif");
    kintotSpriteSheet             = loadImage("resources/graphics/enemy-sprite-kintot.gif");
    menuBackdropRed               = loadImage("resources/graphics/menu-backdrop-red.png");
    menuBackdropBlue              = loadImage("resources/graphics/menu-backdrop-blue.png");
    menuTitle                     = loadImage("resources/graphics/menu-title.png");
    playerSpriteSheet             = loadImage("resources/graphics/player-sprite.gif");
    gameBackdrop                  = loadImage("resources/graphics/game-backdrop.png");
    gameTileSheet                 = loadImage("resources/graphics/world-tileset.png");

    endTime = millis();
    //println("EXTERNAL GRAPHICS LOADED IN " + (endTime - startTime) + " MS");

  }
  
}
