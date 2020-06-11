package com.hiperfabric.client.messages.maps

import java.io._

import com.hiperfabric.client.OpCodes._
import com.hiperfabric.io.rpc._
import com.hiperfabric.maps._

class PutEntriesRequest(
  localized: Boolean,
  version: Long,
  name: String,
  entries: Array[MapEntry]) extends Request {

  override val opCode = PUT_MAP_ENTRIES

  override def write(out: DataOutput) = {
    out writeBoolean localized
    out writeLong version
    out writeUTF name
    val n = entries.length
    out writeInt n
    var i = 0
    while (i < n) {
      entries(i) write out
      i += 1
    }
  }
}