import java.util.HashMap

import scala.collection.mutable

val words = List("swap", "gandhi", "ssss", "ssss", "wwww")
// Transform into word and count.
var counts = words.map(word => (word, 1))



//only + reducer method
counts.groupBy(_._1).map(k => (k._1, k._2.map(_._2).reduce(_ + _)))


class PairedIterable[K, V](x: Iterable[(K, V)]) (implicit manifest: Manifest[V]){


  def reduceByKey(func: (V, V) => V) = {

    //using java hashmap here because
    //if scala hashmap throws exception in case no key is present
    //I am not able to parametrize it
    val map = new HashMap[K, V]
    x foreach {
      pair =>
        val old = map.get(pair._1)
        map.put(pair._1, if (old == null) pair._2 else func(old, pair._2))
    }
    map
  }


  private val default = manifest.newArray(1)(0)
  //parameterize it with this manifests thing
  def reduceByKey2(func: (V, V) => V) = {


    val map = new scala.collection.mutable.HashMap[K, V]

    x foreach {
      pair =>
       val old = map.getOrElse(pair._1,default)
        map.put(pair._1, if (old == None) pair._2 else func(old, pair._2))
    }
    map
  }

}

implicit def iterableToPairedIterable[K, V](x: Iterable[(K, V)]) = {
  new PairedIterable(x)
}
var pairedList = words.map(x => (x, 1))
pairedList.reduceByKey(_ + _)


//val old = map.get(pair._1) _ match {
//  case None => None
//  case Some(v: Option) => v
//}