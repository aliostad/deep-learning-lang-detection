import java.math.BigInteger
import java.util
import scala.util

/**
 * Created by lurker on 2014. 8. 15..
 */
object CF261_4 extends App {
  @inline def tokenizeLine = new java.util.StringTokenizer(readLine)

  def readInts(n: Int) = {
    val tl = tokenizeLine; Array.fill(n)(tl.nextToken.toInt)
  }

  val Array(n) = readInts(1)
  val arr = readInts(n)

  val lMap = new java.util.HashMap[Int, Int]()
  val rMap = new java.util.HashMap[Int, Int]()

//  val lMap = collection.mutable.HashMap[Int, Int]()
//  val rMap = collection.mutable.HashMap[Int, Int]()
  val larr = Array.fill(n)(0)
  val rarr = Array.fill(n)(0)

  var i = 0
  while(i<n){
    val cur = arr(i)
    val old = lMap.get(cur)
    val newv = if(old == null) 1 else old + 1
    lMap.put(cur, newv)
    larr(i) = newv
    i = i + 1
  }
  i = n - 1
  while(i > 0){
    val cur = arr(i)
    val old = rMap.get(cur)
    val newv = if(old == null) 1 else old + 1
    rMap.put(cur, newv)
    rarr(i) = newv
    i = i - 1
  }

  i = 0
  var curval = 0
  while(i < n){
    var j = i + 1
    while(j < n){
      if(larr(i) > rarr(j)){
        curval += 1
      }
      j += 1
    }
    i += 1
  }
  println(curval)
}
