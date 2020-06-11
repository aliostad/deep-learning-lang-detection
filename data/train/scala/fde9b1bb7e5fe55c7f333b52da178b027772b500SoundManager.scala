package in.dogue.gazophylacium.audio

import com.deweyvm.gleany.AssetLoader


object SoundManager {
  val baseVol = 2f
  val bass = loadS("bigbass", 1)
  val explode = loadS("explode", 1)
  val wave = loadS("wave", 1)
  val page = loadS("page", 1)
  val blip = loadS("blip", 0.2)
  val fwip = loadS("fwip", 0.2)
  val collect = loadS("collect", 0.5)
  val step = loadS("step", 0.3)
  val stepSmall = loadS("stepSmall", 0.3)
  val stepMed = loadS("stepMed", 0.3)
  val stepBig = loadS("stepBig", 0.3)
  val oof = loadS("oof", 0.6)
  val wrong = loadS("wrong", 0.6)
  val trees1 = loadS("trees1", 0.3)
  val trees2 = loadS("trees2", 0.3)
  val trees3 = loadS("trees3", 0.3)
  val trees4 = loadS("trees4", 0.3)

  val trees = Vector(trees1, trees2, trees3, trees4)

  def loadS(s:String, adj:Double) = {
    val snd = AssetLoader.loadSound(s, false)
    snd.setAdjustVolume(adj.toFloat*baseVol)
    snd
  }

}
