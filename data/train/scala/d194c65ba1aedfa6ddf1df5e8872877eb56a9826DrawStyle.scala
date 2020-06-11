package be.angelcorp.omicron.base.gui.slick

import org.newdawn.slick.{Graphics, Color}


case class DrawStyle(color: Color, lineWidth: Float = 1.0f) {

  def applyOnto(g: Graphics) {
    g.setColor( color )
    g.setLineWidth( lineWidth )
  }

  def apply(g: Graphics)(op: => Unit) = {
    val oldColor = g.getColor
    val oldLineWidth = g.getLineWidth

    applyOnto(g)
    op

    g.setColor(oldColor)
    g.setLineWidth(oldLineWidth)
  }

}

object DrawStyle {

  implicit def color2drawStyle(c: Color) = new DrawStyle(c)

}
