package com.github.mdr.graphospasm.grapheditor.model.commands

import com.github.mdr.graphospasm.grapheditor.model._
import com.github.mdr.graphospasm.core.graph._
import org.eclipse.gef.commands.Command
import org.eclipse.draw2d.geometry.Rectangle
import org.eclipse.gef.commands.Command;

class RenameAttributeNameCommand(val attributeName: AttributeName, val newName: String) extends Command {

  private var oldName: Name = _

  override def execute() {
    oldName = attributeName.name
    attributeName.name = oldName.copy(simpleName = newName)
  }

  override def undo() {
    attributeName.name = oldName
  }

}