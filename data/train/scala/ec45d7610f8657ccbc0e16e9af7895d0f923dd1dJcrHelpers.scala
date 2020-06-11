package net.liftweb.jcrrecord

import javax.jcr.Node

object JcrHelpers {

  def dump(node: Node, depth:Int = 0) {
    import Extensions._
    val indent = "  " * depth
    
    println(indent + "[Node] " + node.getName)

    for (property <- node.properties) {
      if (property.getDefinition.isMultiple)
        for (value <- property.getValues)
          println(indent + "  " + property.getPath + " = " + value)
      else
        println(indent + "  " + property.getPath + " = " + property.getString)
    }

    for (child <- node.childNodes)
      dump(child, depth + 1)
  }
}