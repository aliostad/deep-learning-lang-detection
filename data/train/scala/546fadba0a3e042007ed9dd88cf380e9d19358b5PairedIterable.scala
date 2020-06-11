import java.util.HashMap
import scala.collection.JavaConversions._
import scala.collection.JavaConverters._
	
class PairedIterable[K, V](x: Iterable[(K, V)]) {
	def reduceByKey(func: (V,V) => V) = {
		val map = new HashMap[K, V]
		x.foreach { pair =>
			val old = map.get(pair._1)
			map.put(pair._1, if (old == null) pair._2 else func(old, pair._2))
		}
		map
	}
	
	override def toString(): String = {	
		def toStringEl(y: Iterable[(K, V)]): String = {
			if(y.tail.isEmpty) y.head.toString
			else y.head.toString + ", " + toStringEl(y.tail)
		}
		
		"PairedIterable(" + toStringEl(x) + ")"
	}
}

implicit def iterableToPairedIterable[K, V](x: Iterable[(K, V)]) = { new PairedIterable(x) }
implicit def javaHashMapToPairedIterable[K, V](x: HashMap[K, V]) = { new PairedIterable(x.asScala) }