import AssemblyKeys._

assemblySettings

mergeStrategy in assembly <<= (mergeStrategy in assembly) { (old) =>
  {
    case PathList("org", "objectweb", xs @ _*) => MergeStrategy.first
    case PathList("org", "apache", xs @ _*) => MergeStrategy.first
    case PathList("javax", "servlet", xs @ _*) => MergeStrategy.first
    case PathList("javax", "xml", xs @ _*) => MergeStrategy.first
    case PathList("META-INF", "MANIFEST.MF") => MergeStrategy.discard
    case PathList("com", "esotericsoftware", xs @ _*) => MergeStrategy.first
    case x => old(x)
  }
}

test in assembly := {}