package heap.core

import heap.persistence.{ClassStore, StringStore}
import heap.records._

import scala.collection.mutable.{Map => MMap}

/**
  * Created by mehmetgunturkun on 12/02/17.
  */
class HeapDump(val stream: HeapDumpStream) {

  loadCommonMaps()

  def hasNext = stream.hasNext

  private def loadCommonMaps(): Unit = {
    def iterateUntilHeapDumpStart(f: HeapDumpRecord => Unit): Unit = {
      val record: HeapDumpRecord = nextInternalRecord()
      record.tag match {
        case HeapDumpStartTag => {}
        case other =>
          f(record)
          iterateUntilHeapDumpStart(f)
      }
    }

    iterateUntilHeapDumpStart {
      case StringRecord(id, content) =>
        StringStore.store(id, content)
      case LoadClassRecord(classSerialNumber: Int, classObjectId: Long, stackTraceSerialNumber: Int, classNameStringId: Long) =>
        val classNameString = StringStore.get(classNameStringId).get
        val clazz = Class(classObjectId, classNameString)
        ClassStore.store(classObjectId, clazz)
      case other =>
        //unrecognized tag - do nothing
    }
  }

  private def nextInternalRecord(): HeapDumpRecord = {
    val tagByte = stream.read()
    val tag: HeapDumpInternalRecordTag = HeapDumpInternalRecordTag(tagByte)

    val ts: Int = stream.readInt()
    val length: Int = stream.readInt()

    HeapDumpRecord(tag, length, stream)
  }

  def nextRecord(): HeapDumpRecord = {
    val tagByte = stream.read()
    val tag: HeapDumpRecordTag = HeapDumpRecordTag(tagByte)

    HeapDumpRecord(tag, 100, stream)
  }

}
