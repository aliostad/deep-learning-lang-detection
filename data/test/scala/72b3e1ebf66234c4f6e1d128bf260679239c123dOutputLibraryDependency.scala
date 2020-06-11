package com.github.madoc.create_sbt_project.model.output

import com.github.madoc.create_sbt_project.io.{Output, Write}
import com.github.madoc.create_sbt_project.model.LibraryDependency

object OutputLibraryDependency extends Output[LibraryDependency] {
  def apply(the:LibraryDependency)(write:Write) {
    write inQuotes {_ stringEscaped (the groupID)}
    if(the addScalaVersion) write(" %% ") else write(" % ")
    write inQuotes {_ stringEscaped (the artifactID)}
    write(" % ") inQuotes {_ stringEscaped (the revision)}
    (the configuration) foreach {configuration ⇒ write(" % ") inQuotes {_ stringEscaped configuration}}
    if(the withSources) write(" withSources()")
  }
}
