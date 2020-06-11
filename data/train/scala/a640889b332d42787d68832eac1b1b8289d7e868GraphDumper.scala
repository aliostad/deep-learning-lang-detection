package edu.hku.cs.dft.datamodel

import java.io.{BufferedWriter, File, FileWriter, PrintWriter}

import edu.hku.cs.dft.DFTEnv
import edu.hku.cs.dft.checker.TrafficGlobal
import edu.hku.cs.dft.traffic.{DependentTagger, PartitionScheme, PartitionSchemeTagger, PartitionSchemes}



/**
  * Created by jianyu on 3/10/17.
  */
class GraphDumper(fn: String) {
  private val filename = fn
  private var fileWriter: BufferedWriter = _
  def open(): Boolean = {
    val file = new File(filename)
    fileWriter = new BufferedWriter(new FileWriter(file))
    true
  }

  def writeData(dataModel: DataModel): Unit = {
    fileWriter.write(dataModel.toString)
  }

  def close(): Unit = {
    fileWriter.close()
  }

  def dumpGraph(graphManager: TrafficGlobal):Unit = {
    var dumpList = graphManager.rootData
    var dumpedSet: Set[Int] = Set()
    while(dumpList.nonEmpty) {
      var v = dumpList.last
      if (!dumpedSet.contains(v.ID.asInstanceOf[Int])) {
        dumpedSet = dumpedSet + v.ID.asInstanceOf[Int]
        v.sons().foreach(son => {
          dumpList = son :: dumpList
        })
        writeData(v)
      }
      dumpList = dumpList.init
    }
    fileWriter.close()
    val analyser: PartitionSchemeTagger = new DependentTagger
    analyser.entry(graphManager)
//    analyser.firstRoundEntry()
    analyser.exitPoint()
    DependentTagger.serializeTagger("analyzer.obj", analyser.asInstanceOf[DependentTagger])
    if (true) {
      analyser.firstRoundEntry()
      analyser.tagScheme()
      analyser.chooseScheme()
      analyser.printScheme()
      analyser.serializeToFiles("a.out")
    }
  }

}
