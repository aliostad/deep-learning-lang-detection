
import akka.util.ByteString
import java.io.{FileInputStream, FileNotFoundException, File}
import org.scalatest.FlatSpec
import rtmp.OutgoingMessage
import utils.HexBytesUtil

/**
 * Common trait for tests depends on the some binary data from external dump files.
 */
trait BinaryTester extends FlatSpec {

  protected def dumpDir:String = "dump"

  protected def serializeOut(out: List[OutgoingMessage]):ByteString = {

    val builder = ByteString.newBuilder

    out.foreach((message)=>{
      builder.append(message.data)
    })

    builder.result()
  }

  protected def readData(fileName:String):ByteString = {
    ByteString.fromArray(readBytes(fileName))
  }

  protected def readBytes(fileName:String):Array[Byte] = {

    val file: File = new File(dumpDir+"/"+fileName)
    if (!file.exists()) {
      throw new FileNotFoundException(fileName)
    }

    val fis: FileInputStream = new FileInputStream(file)
    val data: Array[Byte] = new Array[Byte](file.length.asInstanceOf[Int])
    fis.read(data)
    fis.close()

    data
  }

  protected def compare(data:ByteString, testDump:String) = {

    val binaryData = readData(testDump)
    if (!binaryData.equals(data)) {
      // TODO: Print both dumps and raise exception
      // log.debug("Public key bytes:{} ", HexBytesUtil.bytes2hex(publicKey))

      info("DUMP IS NOT MATCHED: ")
      info(HexBytesUtil.arraysVisualMatch(binaryData.toArray,"Dump    ", data.toArray, "Produced"))

      throw new Exception("Binary dumps is not matched")
    }
  }

}
