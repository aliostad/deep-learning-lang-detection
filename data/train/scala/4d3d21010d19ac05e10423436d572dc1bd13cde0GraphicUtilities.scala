package com.lordjoe.bridge.ui

import java.awt.{Color, Graphics}
import javax.swing.JComponent

/**
 * solitarius.ui.GraphicUtilities 
 * User: Steve
 * Date: 8/4/2015
 */
object GraphicUtilities {
  // fill the component with a specific color
  def colorComponent(me: JComponent, g: Graphics, c: Color): Unit = {
    val r = me.getVisibleRect
    val oldColor = g.getColor
    g.setColor(c)
    g.fillRect(r.x, r.y, r.width, r.height)
    g.setColor(oldColor)
  }

}

class BlankRectangle extends JComponent
{
  override def paint(g: Graphics) {
    GraphicUtilities.colorComponent(this,g,Color.GRAY)
   }

}
