package ru.shubert.tetris

import javax.imageio.ImageIO
import java.awt.Image

object Art {
  val brix = load("brix.png").getScaledInstance(16, 16, Image.SCALE_DEFAULT)
  val bg2 = load("tetris.png")
  val gameover = load("gameover.png")
  val pause = load("pause.png")
  val press_s = load("press_s.png")
  val digits = loadDigits()
  val colors = loadColors()

  def load(path: String): Image = {
    ImageIO.read(Art.getClass.getResource(path))
  }

  def loadDigits(): Array[Image] = {
    val array = Array.ofDim[Image](10)
    for (x <- 0 to 9) {
      array(x) = load(x + ".png")
    }
    array
  }

  def loadColors(): Array[Image] = {
    val colors = Array("blue.png", "cyan.png", "green.png", "lilac.png", "orange.png", "red.png", "yellow.png")
    val array = Array.ofDim[Image](colors.length)
    for (x <- 0 until colors.length) {
      array(x) = load(colors(x))
    }
    array
  }
}
