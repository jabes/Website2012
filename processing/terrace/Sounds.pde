import ddf.minim.*;

public class Sounds {

  Minim minim;
  
  AudioPlayer music;
  AudioPlayer jump;
  AudioPlayer lazer;
  AudioPlayer kill;
  AudioPlayer spring;
  AudioPlayer die;
  AudioPlayer coin;
  
  boolean isMuted;
  
  int startTime;
  int endTime;
    
  public Sounds (PApplet a) {
    
    minim = new Minim(a);
    isMuted = false;
    
    //println("LOADING EXTERNAL SOUNDS");
    startTime = millis();
    
    music     = minim.loadFile("resources/sounds/gunman.wav");
    jump      = minim.loadFile("resources/sounds/jump.wav");
    lazer     = minim.loadFile("resources/sounds/lazer.wav");
    kill      = minim.loadFile("resources/sounds/kill.wav");
    spring    = minim.loadFile("resources/sounds/spring.wav");
    die       = minim.loadFile("resources/sounds/die.wav");
    coin      = minim.loadFile("resources/sounds/coin.wav");
    
    endTime = millis();
    //println("EXTERNAL SOUNDS LOADED IN " + (endTime - startTime) + " MS");
    
  }
  
  public void playAudio (AudioPlayer a) {
    if (!isMuted) a.play(0);
  }
  
  public void loopAudio (AudioPlayer a) {
    a.loop();
  }
  
  public void pauseAudio (AudioPlayer a) {
    a.pause();
  }
  
  public void mute () {
    music.mute();
    jump.mute();
    lazer.mute();
    kill.mute();
    spring.mute();
    die.mute();
    coin.mute();
    isMuted = true;
  }
  
  public void unmute () {
    music.unmute();
    jump.unmute();
    lazer.unmute();
    kill.unmute();
    spring.unmute();
    die.unmute();
    coin.unmute();
    isMuted = false;
  }
  
  public void unload () {
    music.close();
    jump.close();
    lazer.close();
    kill.close();
    spring.close();
    die.close();
    coin.close();
    minim.stop();
  }

}


