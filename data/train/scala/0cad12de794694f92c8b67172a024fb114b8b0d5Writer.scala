import java.io.{FileOutputStream, DataOutputStream}

/**
 * User: mthorpe
 * Date: 09/02/2013
 * Time: 03:07
 */
final class Writer(img: Image, fileName: String) {

  val outFile = new FileOutputStream(fileName)
  val dat = new DataOutputStream(outFile)

  writeInitialHeader()
  writeFloats()

  def writeInitialHeader() {
    dat.writeBytes("PF\n")
    dat.writeBytes(img.xDim.toString);
    dat.writeBytes(" ");
    dat.writeBytes(img.yDim.toString);
    dat.writeBytes("\n")
    dat.writeBytes("-1.000000\n")
  }

  def writeFloats() {
    img.foreach {
      x => dat.writeFloat(x.r.toFloat); dat.writeFloat(x.g.toFloat); dat.writeFloat(x.b.toFloat)
    }
  }
}
