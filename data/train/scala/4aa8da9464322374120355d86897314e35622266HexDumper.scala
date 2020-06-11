package stealthnet.scala.util

import suiryc.scala.util.{HexDumper => sHexDumper}

/** Hexadecimal data dumper proxy. */
object HexDumper {

  import sHexDumper._

  /**
   * Dumps data.
   *
   * @param data data to dump
   * @param offset data offset
   * @param length data length, negative value means whole array
   * @param result where to dump the hexadecimal representation of data
   * @return result containing the hexadecimal representation of data
   */
  def dump(data: Array[Byte], offset: Int = 0, length: Int = -1,
      result: StringBuilder = new StringBuilder()): StringBuilder =
  {
    val settings = Settings(output = Output(result), offset = offset.toLong, length = length.toLong, endWithEOL = false)
    sHexDumper.dump(data, settings)
    result
  }

}
