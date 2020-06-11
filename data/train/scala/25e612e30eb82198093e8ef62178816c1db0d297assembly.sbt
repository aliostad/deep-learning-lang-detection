import AssemblyKeys._ // put this at the top of the file

assemblySettings

// your assembly settings here

mergeStrategy in assembly <<= (mergeStrategy in assembly) { (old) =>
  {
    case PathList("javax", "servlet", xs @ _*)         => MergeStrategy.first
    case PathList("com", "sotericsoftware", "minlog", xs @ _*)         => MergeStrategy.first
    case PathList(ps @ _*) if ps.last endsWith ".html" => MergeStrategy.first
    case "application.conf" => MergeStrategy.concat
    case "unwanted.txt"     => MergeStrategy.discard
    case x => old(x)
  }
}

jarName in assembly := "rdf-partitioner-1.0.jar"
