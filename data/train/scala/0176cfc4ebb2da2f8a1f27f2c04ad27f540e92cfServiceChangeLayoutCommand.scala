package com.github.eclipse.gef.example.editor.commands

import com.github.eclipse.gef.example.editor.model.Service
import org.eclipse.draw2d.geometry.Rectangle

class ServiceChangeLayoutCommand extends AbstractLayoutCommand {

  private var model: Service = _
  private var layout: Rectangle = _
  private var oldLayout: Rectangle = _

  override def execute(): Unit = model.setLayout(layout)

  def setConstraint(rect: Rectangle): Unit = this.layout = rect

  def setModel(model: Any): Unit = {
    this.model = model.asInstanceOf[Service]
    this.oldLayout = model.asInstanceOf[Service].getLayout()
  }

  override def undo(): Unit = this.model.setLayout(this.oldLayout)

}