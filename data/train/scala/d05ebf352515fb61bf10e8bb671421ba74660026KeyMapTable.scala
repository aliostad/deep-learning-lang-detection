package sae.interpreter.utils

/**
 * @author Mirko Köhler
 */
import idb.Relation
import idb.observer.NotifyObservers

import scala.collection.mutable

class KeyMapTable[K,V](val keyGenerator : KeyGenerator[K]) extends Relation[(K, V)] with NotifyObservers[(K, V)] {

	private val materializedMap : mutable.Map[K,V] = mutable.HashMap.empty[K,V]

	/**
	 * Runtime information whether a compiled query is a set or a bag
	 */
	override def isSet: Boolean = true

	override protected def children: Seq[Relation[_]] = Seq()

	override protected def lazyInitialize() { }


	override def foreach[T](f: ((K, V)) => T) {
		materializedMap.foreach(f)
	}

	def apply(k : K) : V = {
		materializedMap(k)
	}

	def add(v : V) : K = {
		val id  = keyGenerator.fresh()
		materializedMap.put(id, v)
		notify_added((id,v))
		id
	}

	def update(oldKey : K, newV : V) : K = {
		if (!materializedMap.contains(oldKey))
			throw new IllegalStateException("Key could not be updated, because it does not exist. Key: " + oldKey)
		val Some(oldV) = materializedMap.put(oldKey,newV)

		notify_updated((oldKey, oldV), (oldKey, newV))
		oldKey
	}

	/*def put(k : K, v : V) = {
		if (materializedMap.contains(k)) {
			println("Warning[IntMapTable.put]: Key already existed")
			update(k, v)
		}

		freshInt = k
		materializedMap.put(k, v)
		notify_added((k,v))
	}  */

}