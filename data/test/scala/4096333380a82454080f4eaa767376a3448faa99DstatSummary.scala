import scala.io.Source

object DstatSummary {
  def main(args: Array[String]): Unit = {
    val dstatPath = args.headOption.getOrElse(sys.error("引数が必要です"))
    println(dstatPath)
    val dstatFile = Source.fromFile(dstatPath).getLines()
    val dstatWithoutHeader = dstatFile.zipWithIndex.filter({ case (_: String, index: Int) => index > 1 }).map(_._1)
    val dstatSummary = dstatWithoutHeader.map(Record.apply)

    val withoutIdl100 = filterCpuUsageIdl100(dstatSummary.toSeq)

    val cpuAverage = CpuUsage.cpuUsageAverage(withoutIdl100.map(_.cpuUsage))

    val (loadAvg1min, loadAvg1max) = LoadAvg.edgeAverage(withoutIdl100.map(_.loadAvg1))
    val (loadAvg5min, loadAvg5max) = LoadAvg.edgeAverage(withoutIdl100.map(_.loadAvg5))
    val (loadAvg15min, loadAvg15max) = LoadAvg.edgeAverage(withoutIdl100.map(_.loadAvg15))

    println(
      s"""
        cpuAverage: $cpuAverage
        loadAverage: $loadAvg1min, $loadAvg1max, $loadAvg5min, $loadAvg5max, $loadAvg15min, $loadAvg15max
      """.stripMargin)

  }

  def filterCpuUsageIdl100(records: Seq[Record]): Seq[Record] = records.filterNot(_.cpuUsage.idl.value == 100)

}
