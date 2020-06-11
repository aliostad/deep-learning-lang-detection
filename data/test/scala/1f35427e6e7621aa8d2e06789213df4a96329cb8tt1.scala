import scodec.bits.BitVector
import java.io.FileInputStream
import scodec._
import scodec.bits._
import codecs._
import com.trainologic.com.phase1._
import com.trainologic.com.phase2

object tt1 extends App {
  def const[A, B](a: => A): B => A = _ => a

  val path = """f:\todelete\eclipse.hprof"""

  val fc = new FileInputStream(path).getChannel
  try {

    val bitVector = BitVector.fromMmap(fc, 1024 * 1000 * 150)
    println(s"size: ${bitVector.size}")
    val result = (Header.headerCodec ~ list(Tag.heapdumpcodec)).decodeValue(bitVector)

    val strings = result.fold(const(???), {case (_, tags) => phase2.strings(tags)})
    val classes = result.fold(const(???), {
      case (_, tags) =>
        tags.collect {
          case LOADCLASS(_, _, classId, _, name) => (classId, strings.get(name))
        }.toMap
    })
    val instancesByClz = result.fold(const(???), {
      case (_, tags) =>
        (tags.collect {
          case HEAPDUMP(_, heapDumpRecords) => {
            heapDumpRecords.collect {
              case INSTANCE_DUMP(objId, _, clzId, content) => (clzId, objId, content)
            }
          }
        }.flatten).groupBy(_._1)
    })
    
    val primarrs = result.fold(const(???), {
      case (_, tags) =>
        (tags.collect {
          case HEAPDUMP(_, heapDumpRecords) => {
            heapDumpRecords.collect {
              case PRIMITIVE_ARRAY_DUMP(objId, _, elementType, content) => (objId, content)
              case OBJECT_ARRAY_DUMP(objId, _, _, content) => (objId, content)
            }
          }
        }.flatten).toMap
    })
    
    val instancesById = instancesByClz.values.flatten.groupBy(_._2).mapValues(_.map(x => (x._2, x._3)))
    
    
    
    val clzdatas = result.fold(const(???), {
      case (_, tags) =>
        (tags.collect {
          case HEAPDUMP(_, heapDumpRecords) => {
            heapDumpRecords.collect {
              case HPROF_GC_CLASS_DUMP(clzId, _, _,_, _, _,_, cp, statics, instanceFields) => (clzId, instanceFields)
            }
          }
        }.flatten).toMap
    })
    
   val xxxxxxx =  for {
      hmclz <- classes.find(_._2 == Some("java/util/HashMap"))
      hmclzId = hmclz._1
      hminst <- instancesByClz.get(hmclzId)
      instIds = hminst.map(_._3)
      clzData <- clzdatas.get(hmclzId)
      y = clzData.takeWhile {
        case InstanceField(fieldName, fieldType) => strings.get(fieldName).fold(true)(_ != "table")
      }
      z = y.foldLeft(0)((acc,e) => acc + e.fieldType.size(8))
      k = instIds.map(_.drop(z).take(8).toLong(false, ByteOrdering.BigEndian))
      arrs = k.map(primarrs.get)
    } yield arrs
println(xxxxxxx)
  } finally {
    fc.close()
  }

}