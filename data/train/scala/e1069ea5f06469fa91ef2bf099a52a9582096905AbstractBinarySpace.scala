package bom.bin

abstract class AbstractBinarySpace extends BinarySpace {

  // contains the bit offset after bytePosition
  protected var offset: Long = 0

  def getBits(count: Int): Int = {
    var result = 0;
    for (i <- 0 until count) {
      result = (result << 1) | getBit
    }
    result
  }

  def getBit: Int = {
    val old = bytePosition * 8
    val bit = (getByte >> (7 - offset)) & 1
    offset = (offset + 1) % 8
    if (offset < 8) position(old + offset)
    if (offset == 0) position(old + 8)
    bit
  }
  
  /**
   * the current position in bytes regardless of the bit offset
   */
  protected[this] def bytePosition: Long
}
