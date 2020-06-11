package in.dogue.profundus.audio

import com.deweyvm.gleany.AssetLoader
import in.dogue.antiqua.Antiqua.Cell
import in.dogue.antiqua.Antiqua
import Antiqua._

trait Sfx {
  def play(ij:Cell):Unit
  def playFull():Unit
  def stop():Unit
}

object SoundManager {

  private val max = 25
  private var ear:Option[Cell] = None
  def setEar(ij:Cell) = {
    ear = ij.some
  }
  val dig = load("dig", 0.5)
  val swish = load("swish", 1.0)
  val land = load("land", 0.5)
  val dead = load("dead", 0.5)
  val item = load("item", 0.2)
  val shhh = load("shhh", 0.5)
  val boom = load("boom", 1.5)
  val step = load("step", 1.0)
  val `throw` = load("throw", 1.0)
  val stuck = load("stuck", 0.2)
  val blip = load("blip", 1.0)
  val clack = load("clack", 1.0)
  val blap = load("blap", 1.0)
  val wipe = load("wipe", 0.1)
  val pop = load("pop", 0.2)
  val drop = load("drop", 0.5)
  val hurt = load("hurt", 0.5)
  val enehit = load("enehit", 0.5)
  val flare = load("flare", 0.5)
  val fdown = load("fdown", 0.5)
  val pew = load("pew", 0.5)
  val pow = load("pow", 0.5)
  val petrify = load("petrify", 0.5)
  val enedie = load("death", 0.5)
  def load(s:String, adj:Double) = {
    val sound = AssetLoader.loadSound(s)
    sound.setAdjustVolume(adj.toFloat)
    new Sfx {
      def play(ij:Cell) = {
        val adjust = ear.map { e =>
          ((1 - (ij |-| e).mag)/max.toDouble).clamp(0,1)
        }.getOrElse(1.0)
        sound.setVolume(adjust.toFloat)
        sound.play()
      }
      def playFull() = {
        sound.setVolume(1)
        sound.play()
      }
      def stop() {
        sound.stop()
      }
    }
    //sound
  }
}
