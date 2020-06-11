package com.ambiata.promulgate.assembly

import sbt._, Keys._
import sbtassembly.Plugin._, AssemblyKeys._

object AssemblyPlugin extends Plugin {
  def promulgateAssemblySettings = (assemblySettings: Seq[Sett]) ++ Seq(
    test          in assembly   :=   {},
    mergeStrategy in assembly   <<=  (mergeStrategy in assembly).apply(merge)
  )

  def merge(old: String => MergeStrategy): String => MergeStrategy = x => {
    val oldstrat = old(x)
    if (oldstrat == MergeStrategy.deduplicate) MergeStrategy.first  else oldstrat
  }
}
