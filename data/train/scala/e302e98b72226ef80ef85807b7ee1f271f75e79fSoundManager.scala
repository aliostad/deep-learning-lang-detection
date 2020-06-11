package in.dogue.simulacrum.audio

import com.deweyvm.gleany.AssetLoader

object SoundManager {
  val ping =  load("ping", 1.0)
  val pong =  load("pong", 1.0)
  val `0` =   load("0", 1.0)
  val `321` = load("321", 1.0)
  val oof = load("oof", 1.0)
  val flip = load("flip", 1.0)
  val beeple = load("beeple", 1.0)
  val werp = load("werp", 1.0)
  val swishin = load("swishin", 1.0)
  val swishout = load("swishout", 0.5)
  val lose = load("lose", 1.0)
  val blip = load("blip", 1.0)
  val victory = load("victory2", 4.0)


  val thing = loadm("thing", 4.0)
  def load(s:String, adj:Double) = {
    val sound = AssetLoader.loadSound(s)
    sound.setAdjustVolume(adj.toFloat)
    sound
  }

  def loadm(s:String, adj:Double) = {
    val music = AssetLoader.loadMusic(s)
    music.setAdjustVolume(adj.toFloat)
    music
  }
}
