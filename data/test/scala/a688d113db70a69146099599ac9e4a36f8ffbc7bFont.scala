package edu.depauw.scales.graphics

trait FontStyleType {
  val value : Int
}

case object PLAIN extends FontStyleType {
  val value = java.awt.Font.PLAIN
}

case object BOLD extends FontStyleType {
  val value = java.awt.Font.BOLD
}

case object ITALIC extends FontStyleType {
  val value = java.awt.Font.ITALIC
}

case object BOLD_ITALIC extends FontStyleType {
  val value = java.awt.Font.BOLD + java.awt.Font.ITALIC
}

case class Font(name : String, style : FontStyleType, size : Double, g : Graphic) extends Graphic {
  def render(gc : GraphicsContext) {
    val oldFont = gc.g2d.getFont
    gc.g2d.setFont(new java.awt.Font(name, style.value, 1).deriveFont(size.toFloat))
    g.render(gc)
    gc.g2d.setFont(oldFont)
  }
}

case class FontName(name : String, g : Graphic) extends Graphic {
  def render(gc : GraphicsContext) {
    val oldFont = gc.g2d.getFont
    gc.g2d.setFont(new java.awt.Font(name, oldFont.getStyle, 1).deriveFont(oldFont.getSize2D))
    g.render(gc)
    gc.g2d.setFont(oldFont)
  }
}

case class FontStyle(style : FontStyleType, g : Graphic) extends Graphic {
  def render(gc : GraphicsContext) {
    val oldFont = gc.g2d.getFont
    gc.g2d.setFont(oldFont.deriveFont(style.value))
    g.render(gc)
    gc.g2d.setFont(oldFont)
  }
}

case class FontSize(size : Double, g : Graphic) extends Graphic {
  def render(gc : GraphicsContext) {
    val oldFont = gc.g2d.getFont
    gc.g2d.setFont(oldFont.deriveFont(size.toFloat))
    g.render(gc)
    gc.g2d.setFont(oldFont)
  }
}