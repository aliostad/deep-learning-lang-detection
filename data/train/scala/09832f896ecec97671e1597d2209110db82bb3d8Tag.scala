package com.trainologic.com.phase1

import scodec.bits.BitVector
import java.io.FileInputStream
import scodec._
import scodec.bits._
import codecs._
import com.trainologic.com.phase1.Types._
import Utils._
import scodec.bits.BitVector.Bytes
import scodec.bits.BitVector.Bytes
sealed abstract class Tag(timestamp: Long)

object Tag {
  val microsecs = uint32
  val length = uint32
  val tagCodec = (microsecs ~ length)

  def tagDec[A](c: Codec[A]) = Tag.tagCodec.flatZip(x => paddedFixedSizeBytes(x._2, c, ignore(1)))

  def decode[A, B](c: Codec[A])(f: ((((Long, Long), A)) => B)): Codec[B] =
    Tag.tagDec(c).decoderOnlyMap(f)
    
    
  def heapdumpcodec = discriminated[Tag].by(byte).typecase(1, UTF8.utf8codec(8)).
      typecase(2, LOADCLASS.loadclasscodec(8)).
      typecase(5, TRACE.tracecodec(8)).
      typecase(4, FRAME.framecodec(8)).
      typecase(12, HEAPDUMP.heapdumpcodec(8))
}

case class UTF8(timestamp: Long, id: Long, str: String) extends Tag(timestamp)
object UTF8 {
  def utf8codec(idSize: Int) = {
    val idCodec = fromIdSize(idSize)
    Tag.tagDec(int64 ~ fallback(codecs.bits.decoderOnlyMap(_ => "*unknown*"), utf8).decoderOnlyMap(_.fold(identity, identity))).
      map(z => UTF8(z._1._1, z._2._1, z._2._2)).decodeOnly

  }
}
case class LOADCLASS(timestamp: Long, serialNum: Long, classId: Long, stacktraceNum: Long, name: Long) extends Tag(timestamp)
object LOADCLASS {
  def loadclasscodec(idSize: Int) = {
    val idCodec = fromIdSize(idSize)

    Tag.decode(uint32 ~ idCodec ~ uint32 ~ idCodec) {
      case (p1, (((p2, p3), p4), p5)) => ((((p1._1, p2), p3), p4), p5)
    }.flattenLeftPairs.as[LOADCLASS]
  }
}

case class TRACE(timestamp: Long, serialNum: Long, threadNum: Long, stackFrameIds: List[Long]) extends Tag(timestamp)
object TRACE {
  def tracecodec(idSize: Int) = {
    val idCodec = fromIdSize(idSize)

    Tag.decode(uint32 ~ uint32 ~ uint32 ~ list(idCodec)) {
      case (p1, (((p2, p3), p4), p5)) => (((p1._1, p2), p3), p5)
    }.flattenLeftPairs.as[TRACE]
  }
}
case class FRAME(timestamp: Long, stackFrameId: Long, methodNameId: Long, methodSignatureId: Long,
                 sourceFileNameId: Long, classSerialNum: Long, lineNumber: Int) extends Tag(timestamp)
object FRAME {
  def framecodec(idSize: Int) = {
    val idCodec = fromIdSize(idSize)
    Tag.decode(idCodec ~ idCodec ~ idCodec ~ idCodec ~ uint32 ~ int32) {
      case (p1, (((((p2, p3), p4), p5), p6), p7)) => ((((((p1._1, p2), p3), p4), p5), p6), p7)
    }.flattenLeftPairs.as[FRAME]
  }
}

abstract sealed class HeapDumpRecord
object HeapDumpRecord {
  def heapDumpRecordCodec(idSize: Int) = {
    val idCodec = fromIdSize(idSize)
    discriminated[HeapDumpRecord].by(byte).
    typecase(-1, idCodec.as[HPROF_GC_ROOT_UNKNOWN]).
    typecase(8, (idCodec ~ uint32 ~ uint32).flattenLeftPairs.as[HPROF_GC_ROOT_THREAD_OBJ]).
    typecase(1, (idCodec ~ idCodec).flattenLeftPairs.as[HPROF_GC_ROOT_JNI_GLOBAL]).
    typecase(2, (idCodec ~ uint32 ~ uint32).flattenLeftPairs.as[HPROF_GC_ROOT_JNI_LOCAL]).
    typecase(4, (idCodec ~ uint32).flattenLeftPairs.as[HPROF_GC_ROOT_NATIVE_STACK]).
    typecase(6, (idCodec ~ uint32).flattenLeftPairs.as[HPROF_GC_ROOT_THREAD_BLOCK]).
    typecase(5, (idCodec).as[HPROF_GC_ROOT_STICKY_CLASS]).
    typecase(7, (idCodec).as[HPROF_GC_ROOT_MONITOR_USED]).
    typecase(3, (idCodec ~ uint32 ~ uint32).flattenLeftPairs.as[HPROF_GC_ROOT_JAVA_FRAME]).
    typecase(32, ((idCodec ~ uint32 ~ idCodec ~ idCodec ~ idCodec ~ idCodec <~ ignore(128)) ~ uint32 ~
      ConstantPool.codec(idCodec) ~ HPROF_GC_CLASS_DUMP.staticFieldsCodec(idCodec) ~
      HPROF_GC_CLASS_DUMP.instanceFieldsCodec(idCodec)).flattenLeftPairs.as[HPROF_GC_CLASS_DUMP]).
    typecase(33, (idCodec ~ uint32 ~ idCodec ~ variableSizeBytesLong(uint32, bytes)).flattenLeftPairs.as[INSTANCE_DUMP]).
    typecase(34, (idCodec ~ uint32 ~ uint32.flatMap { ne =>
      idCodec ~ listOfN(provide(ne.toInt), idCodec)
    }.decodeOnly).decoderOnlyMap {
      case ((x1, x2), (x3, x4)) => (((x1, x2), x3), x4)
    }.flattenLeftPairs.as[OBJECT_ARRAY_DUMP]).
    typecase(35, (idCodec ~ uint32 ~ (uint32.flatZip(ne => BasicType.decoder.flatZip {
      typ => bytes(ne.toInt * typ.size(idSize))
    }))).decoderOnlyMap {
      case ((x1_1, x1_2), (x2, (bt, vl))) => (((x1_1, x1_2), bt), vl)
    }.flattenLeftPairs.as[PRIMITIVE_ARRAY_DUMP])
  }
}
case class HPROF_GC_ROOT_UNKNOWN(objId: Long) extends HeapDumpRecord
case class HPROF_GC_ROOT_THREAD_OBJ(threadObjId: Long, seqNum: Long, stackTraceSeqNum: Long) extends HeapDumpRecord
case class HPROF_GC_ROOT_JNI_GLOBAL(objId: Long, jniGlobalRefId: Long) extends HeapDumpRecord
case class HPROF_GC_ROOT_JNI_LOCAL(objId: Long, threadSerNum: Long, frameNum: Long) extends HeapDumpRecord
case class HPROF_GC_ROOT_JAVA_FRAME(objId: Long, threadSerNum: Long, frameNum: Long) extends HeapDumpRecord
case class HPROF_GC_ROOT_NATIVE_STACK(objId: Long, threadSerNum: Long) extends HeapDumpRecord
case class HPROF_GC_ROOT_THREAD_BLOCK(objId: Long, threadSerNum: Long) extends HeapDumpRecord
case class StaticField(fieldName: Long, fieldType: BasicType, value: Value)
object StaticField {
  def codec(idCodec: Codec[Long]): Codec[StaticField] = ((idCodec ~ BasicType.decoder).flatZip(_._2.codec(idCodec).decodeOnly)).flattenLeftPairs.as[StaticField]

}

case class InstanceField(fieldName: Long, fieldType: BasicType)
object InstanceField {
  def codec(idCodec: Codec[Long]): Codec[InstanceField] = (idCodec ~ BasicType.decoder).flattenLeftPairs.as[InstanceField]

}
case class ConstantPoolEntry(index: Int, entryType: BasicType, value: Value)
object ConstantPoolEntry {
  def codec(idCodec: Codec[Long]): Codec[ConstantPoolEntry] = (uint16 ~ BasicType.decoder).flatZip(_._2.codec(idCodec).decodeOnly).flattenLeftPairs.as[ConstantPoolEntry]
}
case class ConstantPool(entries: List[ConstantPoolEntry])
object ConstantPool {
  def codec(idCodec: Codec[Long]): Codec[ConstantPool] = listOfN(uint16, ConstantPoolEntry.codec(idCodec)).decodeOnly.as[ConstantPool]
}

case class HPROF_GC_CLASS_DUMP(clzObjId: Long, stackTraceSeqNum: Long, superClzObjId: Long,
                               clzLoaderObjId: Long, signersObjId: Long, protectionDomainObjId: Long,
                               instanceSize: Long, constantPool: ConstantPool, staticFields: List[StaticField], instanceFields: List[InstanceField]) extends HeapDumpRecord
object HPROF_GC_CLASS_DUMP {
  def staticFieldsCodec(idCodec: Codec[Long]): Codec[List[StaticField]] =
    listOfN(uint16, StaticField.codec(idCodec)).decodeOnly
  def instanceFieldsCodec(idCodec: Codec[Long]): Codec[List[InstanceField]] =
    listOfN(uint16, InstanceField.codec(idCodec)).decodeOnly
}

case class HPROF_GC_ROOT_STICKY_CLASS(objId: Long) extends HeapDumpRecord
case class HPROF_GC_ROOT_MONITOR_USED(objId: Long) extends HeapDumpRecord

case class PRIMITIVE_ARRAY_DUMP(objId: Long, stackTraceSeqNum: Long, elementType: BasicType, elements: ByteVector) extends HeapDumpRecord
case class OBJECT_ARRAY_DUMP(objId: Long, stackTraceSeqNum: Long, elementClzId: Long, elements: List[Long]) extends HeapDumpRecord
case class INSTANCE_DUMP(objId: Long, stackTraceSeqNum: Long, clzId: Long, content: ByteVector) extends HeapDumpRecord

case class HEAPDUMP(timestamp: Long, heapDumpRecords: List[HeapDumpRecord]) extends Tag(timestamp)
object HEAPDUMP {
  def heapdumpcodec(idSize: Int) = {
    Tag.decode(list(HeapDumpRecord.heapDumpRecordCodec(idSize))) {
      case (p1, x) => (p1._1, x)
    }.flattenLeftPairs.as[HEAPDUMP]
  }
}

case class Header(version: String, sizeOfIdentifiers: Long, timestamp: Long)
object Header {
  val headerCodec = (cstring :: uint32 :: int64).as[Header]
}
