package de.hpi.isg.sodap.rdfind.data

/**
 * @author sebastian.kruse 
 * @since 09.06.2015
 */
case class JoinLineLoad(var unaryLoad: Long, var binaryLoad: Long, var combinedLoad: Long) {

  def +=(that: JoinLineLoad): JoinLineLoad = {
    this.unaryLoad += that.unaryLoad
    this.binaryLoad += that.binaryLoad
    this.combinedLoad += that.combinedLoad
    this
  }

  def unaryBlockSize = calculateBlockSize(this.unaryLoad)

  def binaryBlockSize = calculateBlockSize(this.binaryLoad)

  def combinedBlockSize = calculateBlockSize(this.combinedLoad)

  def /=(parallelism: Int): JoinLineLoad =
    JoinLineLoad(
      calculateAverage(this.unaryLoad, parallelism),
      calculateAverage(this.binaryLoad, parallelism),
      calculateAverage(this.combinedLoad, parallelism)
    )

  private def calculateAverage(load: Long, parallelism: Int): Long =
    Math.round(load / parallelism.asInstanceOf[Double])

  private def calculateBlockSize(load: Long): Int =
    Math.round(Math.sqrt(load)).asInstanceOf[Int]

}

object JoinLineLoad {

  def apply(unarySize: Int, binarySize: Int): JoinLineLoad = {
    val unarySizeLong = unarySize.asInstanceOf[Long]
    val binarySizeLong = binarySize.asInstanceOf[Long]
    val combinedSizeLong = unarySize + binarySize
    JoinLineLoad(unarySize * unarySize, binarySize * binarySize, combinedSizeLong * combinedSizeLong)
  }

}
