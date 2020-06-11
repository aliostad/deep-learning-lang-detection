package edu.uccs.summers.data.dto.geometry

import edu.uccs.summers.data.dto.DTOType
import edu.uccs.summers.data.geometry.shapes.Shape
import java.awt.Graphics2D
import org.jbox2d.common.Vec2
import java.awt.Color

class Wall(val shape : Shape) extends StaticEntity with DTOType{

  def getColor() : Color = {
    Color.WHITE
  }

  override def draw(g : Graphics2D, convertScalar : Float => Float, convertVec2 : Vec2 => Vec2) : Unit = {
    val oldColor = g.getColor
    g.setColor(getColor)
    shape.draw(g, convertScalar, convertVec2)
    g.setColor(oldColor)
  }

}