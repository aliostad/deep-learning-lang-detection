import AssemblyKeys._

assemblySettings

test in assembly := {}

jarName in assembly := "jubaql-gateway-assembly-" + version.value + ".jar"

/// We MUST include Scala libraries, otherwise scalalogging won't
/// be included: <https://github.com/sbt/sbt-assembly/issues/116>
// assemblyOption in assembly ~= {
//   _.copy(includeScala = false)
// }

mergeStrategy in assembly <<= (mergeStrategy in assembly) {
  (old) => {
    case x if x.startsWith("META-INF/io.netty.versions.properties") => MergeStrategy.last
    case x => old(x)
  }
}
