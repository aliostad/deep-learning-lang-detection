package edu.depauw.scales.graphics

import java.awt.Paint

/**
 * Specifies a `Paint` to be used when rendering a graphic's stroke
 */
case class Outline(paint: Paint, g: Graphic) extends Graphic {
  
  /*
   * render graphic with the outline paint
   */
  def render(gc: GraphicsContext) {
    // keep old paint ref
    val oldPaint = gc.outlinePaint
    
    // switch to specified one
    gc.outlinePaint = paint
    
    // render with it
    g.render(gc)
    
    // restore old paint
    gc.outlinePaint = oldPaint
  }
  
  /**
   *  same as graphic
   */ 
  override lazy val bounds = g.bounds
  
  /**
   * same as graphic
   */
  override lazy val shape = g.shape
  
  /**
   * same as graphic
   */
  def withName(name: String) = g.withName(name)
  
  def names: Set[String] = g.names
}
