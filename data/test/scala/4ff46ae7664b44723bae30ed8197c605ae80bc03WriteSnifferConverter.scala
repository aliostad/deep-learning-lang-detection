package com.tooe.core.db.mongo.converters

import org.springframework.data.convert.{ReadingConverter, WritingConverter}
import org.springframework.core.convert.converter.Converter
import com.tooe.core.db.mongo.domain.CacheWriteSniffer
import com.mongodb.DBObject
import com.tooe.core.domain.{WriteSnifferCacheId, UserId}
import java.util.Date


@WritingConverter
class WriteSnifferWriteConverter extends Converter[CacheWriteSniffer, DBObject] with WriteSnifferConverter {

  def convert(source: CacheWriteSniffer): DBObject = writeSnifferCacheConverter.serialize(source)


}

@ReadingConverter
class WriteSnifferReadConverter extends Converter[DBObject, CacheWriteSniffer] with WriteSnifferConverter {
  def convert(source: DBObject): CacheWriteSniffer = writeSnifferCacheConverter.deserialize(source)
}

trait WriteSnifferConverter {

  import DBObjectConverters._

  implicit val writeSnifferCacheConverter = new DBObjectConverter[CacheWriteSniffer] {

    def serializeObj(obj: CacheWriteSniffer) = DBObjectBuilder()
      .id.value(obj.id)
      .field("uid").value(obj.userId)
      .field("t").value(obj.createdAt)

    def deserializeObj(source: DBObjectExtractor) = CacheWriteSniffer(
      id = source.id.value[WriteSnifferCacheId],
      userId = source.field("uid").value[UserId],
      createdAt = source.field("t").value[Date]
    )

  }

}

