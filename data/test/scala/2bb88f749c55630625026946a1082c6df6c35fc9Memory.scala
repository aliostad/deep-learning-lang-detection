import scala.collection.mutable.ArrayBuffer
import util.Random

object Memory {

  /**
   * refresh rate 100ms くらいでグラフを書くといいかんじに見えるかも
   */
  def test() {
    type Block = Array[Byte]
    // old 領域にいれるために、ある程度の期間保持する
    val oldSeq = ArrayBuffer[Block]()

    // リークさせるために、ずっと保持する
    val leakSeq = ArrayBuffer[Block]()

    val rand = new Random()

    while (true) {
      val block = new Block(1000 * 100)
      if (rand.nextInt(100) == 0)
        oldSeq.clear()
      if (rand.nextInt(2) == 0)
        oldSeq += block
      if (rand.nextInt(1000) == 0)
        leakSeq += block
      Thread.sleep(10)
    }
  }

  def main(args: Array[String]) {
    test()
  }
}
