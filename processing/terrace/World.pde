public class World {
  
  float posX, posY; // the map moves based on player position
  
  int totalTilesX;
  int totalTilesY;
  int mapWidth;
  int mapHeight;
  final int tileWidth;
  final int tileHeight;
  final int viewportTileCount;
  
  PImage tileBlock;
  
  // note: subject to change when importing maps
  int[][] mapData;
  final int[][] mapDataDefault = {
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 2, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 2, 2, 2, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 5, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 5, 5, 5, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 1, 2, 2, 2, 2,10, 5, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {3, 0, 0, 1, 3, 0, 0, 0, 0, 0, 0, 0, 4, 5, 5, 5, 6, 0, 0, 0, 0, 0, 0, 7, 0, 0, 8, 0, 0, 0, 0, 0, 4, 5, 5, 5, 5, 5, 5, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {6, 0, 0, 4, 6, 0, 0, 0, 0, 0, 0, 0, 4, 5, 5, 5, 6, 0, 0, 0, 0, 0, 0, 8, 0, 0, 8, 0, 0, 7, 0, 0, 4, 5, 5, 5, 5, 5, 5, 9, 2, 2, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {6, 0, 0, 4, 6, 0, 0, 0, 0, 0, 0, 0, 4, 5, 5, 5, 9, 2, 2, 2, 3, 0, 0, 8, 0, 0, 8, 0, 0, 8, 0, 0, 4, 5, 5, 5, 5, 5, 5, 5, 5, 5, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {9, 2, 2,10, 6, 0, 0, 1, 2, 2, 2, 2,10, 5, 5, 5, 5, 5, 5, 5, 6, 0, 0, 8, 0, 0, 8, 0, 0, 8, 0, 0, 4, 5, 5, 5, 5, 5, 5, 5, 5, 5, 6, 0, 0, 0, 0, 1, 2, 2, 3, 0, 0}
  };

  final int[][] mapLegend = {
    {}, // 0 - empty space
    {0, 0}, // 1 - top left corner
    {60, 0}, // 2 - top middle
    {120, 0}, // 3 - top right corner
    {0, 60}, // 4 - left wall
    {60, 60}, // 5 - solid ground
    {120, 60}, // 6 - right wall
    {180, 0}, // 7 - top shaft
    {180, 60}, // 8 - shaft
    {240, 0}, // 9 - overhang right
    {300, 0}, // 10 - overhang left
    {240, 60} // 11 - overhang both
  };
  
  World (int w, int h) {
    tileWidth = w;
    tileHeight = h;
    viewportTileCount = globals.viewportWidth / tileWidth;
  }
  
  void init (int[][] newMapData) {
    //println("WORLD INIT");
    posX = posY = 0;
    mapData = new int[newMapData.length][newMapData[0].length]; // reset array
    arrayCopy(newMapData, mapData);
    totalTilesX = mapData[0].length;
    totalTilesY = mapData.length;
    mapWidth = tileWidth * totalTilesX;
    mapHeight = tileHeight * totalTilesY;
  }
  
  void iterate () {
    
    float playerCenter = player.posX + (player.sizeWidth / 2);
    int mapThresholdRight = mapWidth - globals.viewportHalfWidth;
    int mapThresholdLeft = globals.viewportHalfWidth;
    
    // player has moved past the map width minus half the viewport
    if (playerCenter > mapThresholdRight) {
      posX = (mapWidth - globals.viewportWidth) * -1;
    // player has moved past the middle of the viewport
    } else if (playerCenter > mapThresholdLeft) {
      posX = (playerCenter - mapThresholdLeft) * -1;
    } else {
      posX = 0;
    }
    
    applet.translate(posX, posY);

    for (int y = 0; y < mapData.length; y++) {
      for (int x = 0; x < mapData[y].length; x++) { 
        int tileType = mapData[y][x];
        if (tileType > 0 && isDrawable(x, 1)) {
          tileBlock = graphics.gameTileSheet.get(mapLegend[tileType][0], mapLegend[tileType][1], tileWidth, tileHeight);
          image(tileBlock, x * tileWidth, y * tileHeight, tileWidth, tileHeight);
        }
      }
    }
    
  }
  
  boolean isWalkable (int tileX, int tileY) {
    // prevent access to array when out of bounds     
    if (tileX < 0 || tileX >= totalTilesX || tileY < 0 || tileY >= totalTilesY) return false;
    else if (mapData[tileY][tileX] == 0) return true;
    else return false;
  }
  
  boolean isDrawable (int tileX, int offsetX) {
    // note: offsetX is subject to change depending on what is calling this method (DUH!)
    // for example: ~ tiles only require 1 block of offset to completely hide them when not within the viewport
    //              ~ but interactive objects require 2 blocks of offset for objects wider than 1 tile, such as trees
    int baseTile = floor(abs(posX) / tileWidth);
    return tileX > (baseTile - offsetX) && tileX < (baseTile + viewportTileCount + offsetX);
  }

  int[] getTileByCoords (float coordX, float coordY) {
    int[] tile = new int[2];
    tile[0] = floor(coordX / tileWidth);
    tile[1] = floor(coordY / tileHeight);
    return tile;
  }

}
