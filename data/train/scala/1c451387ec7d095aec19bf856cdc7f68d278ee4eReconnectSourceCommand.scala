package com.github.mdr.graphospasm.grapheditor.model.commands

import org.eclipse.gef.commands.Command
import com.github.mdr.graphospasm.grapheditor.model.Connection
import com.github.mdr.graphospasm.grapheditor.model.Node

class ReconnectSourceCommand(initialConnection: Connection, newSource: Node) extends Command {

  private var connection: Connection = initialConnection

  private var oldSource: Node = _

  override def execute() {
    oldSource = connection.source
    connection.source = newSource
  }

  override def undo() {
    connection.source = oldSource
  }
}