package heap.records

/**
  * Created by mehmetgunturkun on 12/02/17.
  */
trait AbstractHeapDumpRecordTag {
  val tag: Byte
}
abstract class HeapDumpRecordTag(override val tag: Byte) extends AbstractHeapDumpRecordTag
abstract class HeapDumpInternalRecordTag(override val tag: Byte) extends AbstractHeapDumpRecordTag

case object StringTag extends HeapDumpInternalRecordTag(0x01)
case object LoadClassTag extends HeapDumpInternalRecordTag(0x02)
case object UnloadClassTag extends HeapDumpInternalRecordTag(0x03)
case object StackFrameTag extends HeapDumpInternalRecordTag(0x04)
case object StackTraceTag extends HeapDumpInternalRecordTag(0x05)
case object AllocSitesTag extends HeapDumpInternalRecordTag(0x06)
case object HeapSummaryTag extends HeapDumpInternalRecordTag(0x07)
case object StartThreadTag extends HeapDumpInternalRecordTag(0x0A)
case object EndThreadTag extends HeapDumpInternalRecordTag(0x0B)
case object HeapDumpStartTag extends HeapDumpInternalRecordTag(0x0C)
case object HeapDumpSegmentTag extends HeapDumpInternalRecordTag(0x1C)
case object HeapDumpEndTag extends HeapDumpInternalRecordTag(0x2C)
case object CpuSamplesTag extends HeapDumpInternalRecordTag(0x0D)
case object ControlSettingsTag extends HeapDumpInternalRecordTag(0x0E)

object HeapDumpInternalRecordTag {
  private val internalRecords: Map[Byte, HeapDumpInternalRecordTag] = {
    val tagList = List(
      StringTag,
      LoadClassTag,
      UnloadClassTag,
      StackFrameTag,
      StackTraceTag,
      AllocSitesTag,
      HeapSummaryTag,
      StartThreadTag,
      EndThreadTag,
      HeapDumpStartTag,
      HeapDumpSegmentTag,
      HeapDumpEndTag,
      CpuSamplesTag,
      ControlSettingsTag
    )

    tagList.map(tag => tag.tag -> tag).toMap
  }

  def apply(tag: Byte): HeapDumpInternalRecordTag = internalRecords(tag)
}

case object RootUnknown extends HeapDumpRecordTag(0xFF.toByte)
case object RootJniGlobal extends HeapDumpRecordTag(0x01)
case object RootJniLocal extends HeapDumpRecordTag(0x02)
case object RootJavaFrame extends HeapDumpRecordTag(0x03)
case object RootNativeStack extends HeapDumpRecordTag(0x04)
case object RootStickyClass extends HeapDumpRecordTag(0x05)
case object RootThreadBlock extends HeapDumpRecordTag(0x06)
case object RootMonitorUsed extends HeapDumpRecordTag(0x07)
case object RootThreadObject extends HeapDumpRecordTag(0x08)
case object ClassDump extends HeapDumpRecordTag(0x20)
case object InstanceDump extends HeapDumpRecordTag(0x21)
case object ObjectArrayDump extends HeapDumpRecordTag(0x22)
case object PrimitiveArrayDump extends HeapDumpRecordTag(0x23)

object HeapDumpRecordTag {
  private val internalRecords: Map[Byte, HeapDumpRecordTag] = {
    val tagList = List(
      RootUnknown,
      RootJniGlobal,
      RootJniLocal,
      RootJavaFrame,
      RootNativeStack,
      RootStickyClass,
      RootThreadBlock,
      RootMonitorUsed,
      RootThreadObject,
      ClassDump,
      InstanceDump,
      ObjectArrayDump,
      PrimitiveArrayDump
    )

    tagList.map(tag => tag.tag -> tag).toMap
  }

  def apply(tag: Byte): HeapDumpRecordTag = internalRecords.getOrElse(tag, UnrecognizedHeapDumpRecordTag)
}