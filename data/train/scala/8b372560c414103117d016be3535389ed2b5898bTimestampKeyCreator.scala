package com.unclehulka.bdbplayground.model

import com.sleepycat.je.{DatabaseEntry, SecondaryDatabase, SecondaryKeyCreator}
import com.unclehulka.bdbplayground.serialization.{ReadBuffer, WriteBuffer}

object TimestampKeyCreator extends SecondaryKeyCreator {
  def createSecondaryKey(secondary: SecondaryDatabase,
                         key: DatabaseEntry,
                         data: DatabaseEntry,
                         result: DatabaseEntry): Boolean = {
    val writeBuffer = new WriteBuffer(8)
    val readBuffer = new ReadBuffer(data.getData)
    writeBuffer.writeLong(readBuffer.readVarLong())

    result.setData(writeBuffer.finish())
    true
  }
}
