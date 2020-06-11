package svl.interviews.simpledb

class MemoryDatabase[K,V] extends Database[K,V]{
    val keyValueIndex = new scala.collection.mutable.HashMap[K, V]
    val valueKeyIndex = new scala.collection.mutable.HashMap[V, scala.collection.mutable.Set[K]]

    def set(key: K, value: V) = {
        val oldValue = keyValueIndex.get(key)

        removeFromValueIndex(key, oldValue)

        keyValueIndex.put(key, value)
        valueKeyIndex.get(value).map{keys=>
            keys.add(key)
        }.orElse(valueKeyIndex.put(value, scala.collection.mutable.Set(key)))

        oldValue
    }

    def get(key: K) = keyValueIndex.get(key)

    def delete(key: K) = {
        val oldValue = keyValueIndex.get(key)

        oldValue.map{v=>
            removeFromValueIndex(key, oldValue)
            keyValueIndex.remove(key)
        }

        oldValue
    }

    def count(value: V) = valueKeyIndex.get(value).map(_.size).getOrElse(0)

    private def removeFromValueIndex(key:K, oldValue:Option[V]) {
        oldValue.map{value=>
            valueKeyIndex.get(value).map(_.remove(key))
        }
    }
}

