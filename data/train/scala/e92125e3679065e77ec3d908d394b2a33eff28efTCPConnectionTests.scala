package varick


import java.util.UUID
import org.scalatest.FunSpec
import org.scalatest.BeforeAndAfter


class TCPConnectionTests extends FunSpec with BeforeAndAfter {

  describe("TCPConnection") {
    it("returns the number of bytes written") {
      val conn = new TCPConnection(UUID.randomUUID, new TestSelectionKey(), new TestSocketChannel())
      val data = "hello world".getBytes
      val written = conn.write(data)
      assert(written === data.length)
    }

    it("should throw an overflow exception maxWriteBufferSz is exceeded"){
      val conn = new TCPConnection(UUID.randomUUID,new TestSelectionKey(),new TestSocketChannel(), initialWriteBufferSz = 2, maxWriteBufferSz = 2)
       intercept[java.nio.BufferOverflowException] { conn.write("123".getBytes()) }
    }

    it("should let the buffer grow when maxWriteBufferSz is not exceeded"){
      val conn = new TCPConnection(UUID.randomUUID,new TestSelectionKey(), new TestSocketChannel(), initialWriteBufferSz = 2)
      conn.write("123".getBytes())
      assert(conn.writeBuffer.capacity === 3)
    }
    it("conn doesn't need_write when a write consumes entire write buffer"){
      //configure a conn backed by a socket which only writes 2 bytes per write
      val conn = new TCPConnection(UUID.randomUUID,new TestSelectionKey(), new TestSocketChannel(), initialWriteBufferSz = 2)
      conn.write("123".getBytes())
      assert(false === conn.needs_write)
    }

    it("conn needs_write when a write doesn't consume entire write buffer"){
      //configure a conn backed by a socket which only writes 2 bytes per write
      val conn = new TCPConnection(UUID.randomUUID,new TestSelectionKey(2), new TestSocketChannel(2), initialWriteBufferSz = 2)
      conn.write("123".getBytes())
      assert(conn.needs_write)
      conn.writeBuffer.flip()
      //confirm that "3" (or the byte equivalent thereof) is the 
      //next byte to be written
      assert(conn.writeBuffer.get() === "3".getBytes.head)
    }
  }
}
