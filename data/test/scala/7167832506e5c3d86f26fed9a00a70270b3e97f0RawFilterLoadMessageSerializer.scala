package org.bitcoins.spvnode.serializers.messages.control

import org.bitcoins.core.number.UInt32
import org.bitcoins.core.protocol.CompactSizeUInt
import org.bitcoins.core.serializers.RawBitcoinSerializer
import org.bitcoins.core.util.BitcoinSUtil
import org.bitcoins.spvnode.bloom.{BloomFilter, BloomFlag}
import org.bitcoins.spvnode.messages.FilterLoadMessage
import org.bitcoins.spvnode.messages.control.FilterLoadMessage

/**
  * Created by chris on 7/19/16.
  * Serializes and deserializes a [[FilterLoadMessage]]
  * https://bitcoin.org/en/developer-reference#filterload
  */
trait RawFilterLoadMessageSerializer extends RawBitcoinSerializer[FilterLoadMessage] {

  override def read(bytes: List[Byte]): FilterLoadMessage = {
    val filter = RawBloomFilterSerializer.read(bytes)
    FilterLoadMessage(filter)
  }

  override def write(filterLoadMessage: FilterLoadMessage): String = {
    RawBloomFilterSerializer.write(filterLoadMessage.bloomFilter)
  }
}

object RawFilterLoadMessageSerializer extends RawFilterLoadMessageSerializer