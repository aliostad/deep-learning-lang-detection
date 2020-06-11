package monnef.core.utils

import scalautils._
import java.io.File
import java.nio.file.{Paths, Files}
import java.nio.charset.StandardCharsets
import scala.collection.JavaConverters._
import scalagameutils._

object GameObjectsDumper {
  def dump(fileName: String) {
    Files.write(Paths.get(fileName), createDump.asJava, StandardCharsets.UTF_8)
  }

  def createDump: Seq[String] = {
    Seq("name, displayName, class, item block") ++ GameDataHelper.extractAllItemStacks().map {
      stack => Seq(
        stack.getUnlocalizedName, stack.getDisplayName, stack.getItem.getClass.getName, stack.getItem.getBlock.fold("")(b => b.getClass.getName)
      )
    }.map(_.toCSV)
  }
}
