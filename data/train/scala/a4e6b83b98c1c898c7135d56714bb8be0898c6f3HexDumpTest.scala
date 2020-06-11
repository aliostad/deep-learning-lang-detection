package uvm.testutil

import org.scalatest.Matchers
import org.scalatest.FlatSpec
import uvm.utils.HexDump
import uvm.UvmTestBase

class HexDumpTest extends UvmTestBase {
  "HexDump" should "dump render 256 byte values" in {
    val hd = new HexDump(0x420)
    for (i <- 0 until 256) {
      hd.addByte(i.toByte)
    }
    val result = hd.finish()

    print(result)
  }

  "HexDump" should "dump render 256 byte values from non 16-byte-aligned starting point" in {
    val hd = new HexDump(0x424)
    for (i <- 0 until 256) {
      hd.addByte(i.toByte)
    }
    val result = hd.finish()

    print(result)
  }
}