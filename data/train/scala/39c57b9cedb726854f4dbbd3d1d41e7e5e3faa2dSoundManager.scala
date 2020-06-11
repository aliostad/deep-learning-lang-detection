package in.dogue.orthopraxy.audio

import com.deweyvm.gleany.AssetLoader


object SoundManager {
  val baseVol = 0.5f

  lazy val blip  = loadS("blip",  baseVol*0.2)
  lazy val blop  = loadS("blop",  baseVol)
  lazy val thump = loadS("thump", baseVol*1.5)
  lazy val floop = loadS("floop", baseVol)
  lazy val flip  = loadS("flip",  baseVol*2.5)
  lazy val chunk = loadS("chunk", baseVol)
  lazy val fwip  = loadS("fwip",  baseVol)
  lazy val donut = loadS("donut", baseVol)
  lazy val boom  = loadS("boom",  baseVol)
  lazy val bad   = loadS("bad",   baseVol)


  val baseSpeak = 0.4f
  lazy val gologa     = loadS("gologa",          baseSpeak)
  lazy val skinta0    = loadS("zeroskinta",      baseSpeak)
  lazy val skinta1    = loadS("wonskinta",       baseSpeak)
  lazy val skinta2    = loadS("tuskinta",        baseSpeak)
  lazy val skinta3    = loadS("Triskinta",       baseSpeak)
  lazy val skinta4    = loadS("foskinta",        baseSpeak)
  lazy val skinta5    = loadS("faivskinta",      baseSpeak)
  lazy val skinta6    = loadS("siksskinta",      baseSpeak)
  lazy val skinta7    = loadS("akkaskinta",      baseSpeak)
  lazy val skinta8    = loadS("onononomaskinta", baseSpeak)
  lazy val orthopraxy = loadS("ortopraksi",      baseSpeak)

  def loadS(s:String, adj:Double) = {
    val snd = AssetLoader.loadSound(s, false)
    snd.setAdjustVolume(adj.toFloat)
    snd
  }

}
