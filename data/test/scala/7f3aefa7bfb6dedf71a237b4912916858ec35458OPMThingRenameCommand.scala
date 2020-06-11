package com.github.eclipse.opm.diagram.commands

import com.github.eclipse.opm.model.OPMThing
import org.eclipse.gef.commands.Command

class OPMThingRenameCommand extends Command {

  var oldName: String = _
  var newName: String = _
  var model: OPMThing = _

  override def execute(): Unit = {
    if (oldName == null)
      oldName = model.getName()
    model.setName(newName)
  }

  override def undo(): Unit = model.setName(oldName);

  def setModel(model: OPMThing): Unit = this.model = model

  def setNewName(name: String): Unit = this.newName = name

}