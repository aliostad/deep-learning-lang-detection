package com.github.mdr.graphospasm.grapheditor.model.commands

import com.github.mdr.graphospasm.grapheditor.model._
import com.github.mdr.graphospasm.core.graph._
import org.eclipse.gef.commands.Command
import org.eclipse.draw2d.geometry.Rectangle
import org.eclipse.gef.commands.Command;

class RenameNodeCommand(val node: Node, val newName: String) extends Command {

  private var oldName: Name = _

  override def execute() {
    oldName = node.name
    node.name = oldName.copy(simpleName = newName)
  }

  override def undo() {
    node.name = oldName
  }

}