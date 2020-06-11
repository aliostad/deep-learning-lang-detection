package com.github.madoc.create_sbt_project.model.output

import com.github.madoc.create_sbt_project.io.{Output, Write}
import com.github.madoc.create_sbt_project.model.PluginsDefinition

object OutputPluginsDefinition extends Output[PluginsDefinition] {
  def apply(the:PluginsDefinition)(write:Write) {
    var isFirst = true
    for(plugin ← (the plugins).toSeq.sortBy(_ toString)) {
      if(!isFirst) write.lineBreak().lineBreak() else isFirst=false
      write("addSbtPlugin(")(plugin); write(')')
    }
    write.lineBreak()
  }
}
