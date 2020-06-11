package edu.depauw.scales.graphics

import java.awt.font.FontRenderContext
import java.awt.geom.AffineTransform
import java.awt.font.TextLayout
import java.awt.{Font => jFont}

import FontStyleType._

case class Text(str: String,
				font: Font = new Font(),
				frc: FontRenderContext = new FontRenderContext(new AffineTransform(), true, true)
		   ) extends Graphic {
  
  val text: TextLayout = new TextLayout(str, font.toJavaFont, frc)
  
  def render(gc : GraphicsContext) = text.draw(gc.g2d, 0, 0)
  
  /** 
   * calculates the bounds of the text
   */  
  override lazy val bounds = text.getBounds
  
  /**
   * @return the shape of the outline of the text
   */
  override lazy val shape = text.getOutline(new AffineTransform())
  
  /** No name info */
  def withName(name: String) = Nil
  
  def names: Set[String] = Set()
  
  /**
   * @return Text with specified Font
   */
  def setFont(name: String, style: FontStyleType, size: Int): Text = {
    new Text(str, new Font(name, style, size), frc)
  }
  
  /**
   * @return Text with specified font size
   */
  def setSize(size: Int): Text = {
    font match {
      case Font(oldName, oldStyle, oldSize) =>
        new Text(str, new Font(oldName, oldStyle, size), frc)
    }
  }
  
  /**
   * @return Text with specified font family
   */
  def setFontFamily(name: String): Text = {
    font match {
      case Font(oldName, oldStyle, oldSize) =>
        new Text(str, new Font(name, oldStyle, oldSize), frc)
    }
  }
  
  /**
   * @return Text with specified font style
   */
  def setStyle(style: FontStyleType): Text = {
    font match {
      case Font(oldName, oldStyle, oldSize) =>
        new Text(str, new Font(oldName, style, oldSize), frc)
    }
  }
}
