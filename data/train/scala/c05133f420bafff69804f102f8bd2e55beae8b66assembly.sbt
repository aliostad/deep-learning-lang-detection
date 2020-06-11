import AssemblyKeys._
import play.PlayImport.PlayKeys

assemblySettings

val publicLib = """public/lib/(.)*""".r

mergeStrategy in assembly <<= (mergeStrategy in assembly) { (old) =>
  {
    case "play/core/server/ServerWithStop.class" => MergeStrategy.first
    case "logger.xml" => MergeStrategy.first
    case publicLib(_) => MergeStrategy.discard
    case x => old(x)
  }
}

mainClass in assembly := Some("play.core.server.NettyServer")

fullClasspath in assembly += Attributed.blank(PlayKeys.playPackageAssets.value)
