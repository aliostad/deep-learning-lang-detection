package rtmp.amf.amf0

import akka.util.ByteStringBuilder
import rtmp.amf.{Serializer, AmfObjectWriter}



/**
 * AMF0 object writer ( actually MAP writer , for writing object please implement CustomSerializable in it )
 */
class ObjectWriter(serializer:Serializer) extends AmfObjectWriter[Map[String, Any]] with Amf0StringWriter {

  override def write(builder: ByteStringBuilder, value: Map[String, Any]) = {

    def writeProperties(properties: Map[String, Any]):Unit = {

      if (!properties.isEmpty) {

        val property = properties.head

        writeString(builder, property._1)
        serializer.writeObject(property._2)

        writeProperties(properties.tail)
      }
    }

    builder.putByte(Amf0Types.TYPE_OBJECT)
    writeProperties(value)

    writeString(builder, "")
    serializer.writeEndObject()
  }
}
