package com.github.eclipse.gef.example.editor.commands

import org.eclipse.draw2d.geometry.Rectangle
import com.github.eclipse.gef.example.editor.model.Employe

class EmployeChangeLayoutCommand extends AbstractLayoutCommand {

  private var model: Employe = _
  private var layout: Rectangle = _
  private var oldLayout: Rectangle = _

  override def execute(): Unit = model.setLayout(layout)

  def setConstraint(rect: Rectangle): Unit = this.layout = rect

  def setModel(model: Any): Unit = {
    this.model = model.asInstanceOf[Employe]
    this.oldLayout = model.asInstanceOf[Employe].getLayout()
  }

  override def undo(): Unit = this.model.setLayout(this.oldLayout)

}