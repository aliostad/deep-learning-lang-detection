package com.github.eclipse.opm.diagram.commands

import org.eclipse.draw2d.geometry.Rectangle
import com.github.eclipse.opm.model.OPMThing
import org.eclipse.gef.commands.Command

class OPMThingChangeConstraintCommand extends Command {

  var oldConstraint: Rectangle = _
  var newConstraint: Rectangle = _
  var model: OPMThing = _

  override def execute(): Unit = {
    if (oldConstraint == null)
      oldConstraint = model.getConstraints()
    model.setConstraints(newConstraint)
  }

  override def undo(): Unit = model.setConstraints(oldConstraint);

  def setModel(model: OPMThing): Unit = this.model = model

  def setNewConstraint(constraint: Rectangle): Unit = this.newConstraint = constraint

}