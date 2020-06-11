/**
 * Created by wanghuaq on 4/28/2016.
 */

import ALSData._
object test {
   def main (args: Array[String]) {

    val alsdata = new processALSData
    val rawData = alsdata.parseFromFile()

    val csr = alsdata.createCSR3Matrix(rawData)
    alsdata.dumpCSRMatrix(csr)
    val newData = alsdata.splitCSRMatrix(rawData, 2)
    newData(0).foreach(println)
    newData(1).foreach(println)

    def dumpMatrixInCSR(d: Array[(Int, Int, Int)]) {
      val csrData = alsdata.createCSR3Matrix(d)
      alsdata.dumpCSRMatrix(csrData)
    }

    if (newData !=())
      newData.foreach(dumpMatrixInCSR)
  }
}