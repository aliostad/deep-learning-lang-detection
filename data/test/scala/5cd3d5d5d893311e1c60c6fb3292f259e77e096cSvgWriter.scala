package com.hiperfabric.flow.layout.svg

import java.io._
import com.hiperfabric.flow.layout.visuals._

class SvgWriter(writer: Writer) {

  private val padding = 15

  def start(root: Visual) = {

    // Bounds.
    val width = 2 * padding + root.width.asInstanceOf[Int]
    val height = 2 * padding + root.height.asInstanceOf[Int]

    // Start.
    writer write s"<svg xmlns='http://www.w3.org/2000/svg' width='$width' height='$height' style='padding: $padding'>"
    writer write "<defs>"
    writer write "<marker id='arrow' markerWidth='6' markerHeight='6' refX='5' refY='3' orient='auto' markerUnits='userSpaceOnUse'>"
    writer write "<path d='M0,0 L0,6 L6,3 L0,0' style='fill: #bcbcbc;'/>"
    writer write "</marker>"
    writer write "<marker id='smallArrow' markerWidth='5' markerHeight='5' refX='4' refY='2.5' orient='auto' markerUnits='userSpaceOnUse'>"
    writer write "<path d='M0,0 L0,5 L5,2.5 L0,0' style='fill: #bcbcbc;'/>"
    writer write "</marker>"
    writer write "</defs>"
  }

  def write(text: String) = writer write text
  def end = writer write "</svg>"
}