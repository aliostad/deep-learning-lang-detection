package org.shelmet.heap

import java.io.File

import org.shelmet.heap.model.{JavaHeapObject, JavaClass, Snapshot}
import org.shelmet.heap.model.Snapshot._
import org.shelmet.heap.model.create.{ObjectPassDumpVisitor, AbstractDumpVisitor, InitialPassDumpVisitor}
import org.shelmet.heap.parser.HprofReader
import org.shelmet.heap.shared.FieldType

object QuickMain {
  def main(args: Array[String]): Unit = {
    if (args.length != 1)
      throw new IllegalArgumentException("Usage: QuickMain <dumpfile>")


    val dumpFile = new File(args(0))
    val hpr = new HprofReader(dumpFile.getAbsolutePath)
    log.info("Loading file " + dumpFile.getAbsolutePath)
    val snapshot = new Snapshot()
    Snapshot.setInstance(snapshot)
    log.info("Resolving structure")
    val initialVisitor = new InitialPassDumpVisitor(snapshot, false)
    hpr.readFile(initialVisitor, skipFields = true, skipPrimitiveArrays = true)
    log.info(" found:")
    log.info(s"   ${initialVisitor.classCount} class(es)")
    log.info(s"   ${initialVisitor.objectCount} object(s)")
    log.info("Resolving instances")
    hpr.readFile(new StructuralDumpVisitor(snapshot, false), skipFields = false, skipPrimitiveArrays = true)

  }
}
class StructuralDumpVisitor(snapshot : Snapshot,callStack: Boolean) extends AbstractDumpVisitor(callStack) {

  // required by instance load - provided
  override def getClassFieldInfo(classHeapId : HeapId) : Option[List[FieldType]] = {
    snapshot.findHeapObject(classHeapId) match {
      case Some(clazz : JavaClass) => Some(clazz.getFieldsForInstance.map(_.fieldType))
      case Some(other : JavaHeapObject) => throw new IllegalStateException("Requested class id " + classHeapId + "not correct type")
      case None => None
    }
  }


}
