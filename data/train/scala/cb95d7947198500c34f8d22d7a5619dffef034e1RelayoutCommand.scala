package com.github.mdr.graphospasm.grapheditor.model.commands

import com.github.mdr.graphospasm.grapheditor.AutoLayouter
import com.github.mdr.graphospasm.grapheditor.model._
import org.eclipse.draw2d.geometry.Dimension
import org.eclipse.draw2d.geometry.Point
import org.eclipse.draw2d.geometry.Rectangle
import org.eclipse.gef.commands.Command
import org.eclipse.draw2d.Animation

class RelayoutCommand(diagram: GraphDiagram) extends Command {

  private var oldLocations: Map[Node, Rectangle] = _

  override def execute() {
    //    Animation.markBegin()
    oldLocations = AutoLayouter.autolayoutDiagram(diagram)
    //    Animation.run(400)
  }

  override def undo() =
    oldLocations.foreach { case (node, bounds) ⇒ node.bounds = bounds }

}