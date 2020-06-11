package freezer.serialisers
import freezer.collection.ArrayView

class ShortSerialiser extends Serialiser[Short]{
  def store(i : Short) : Array[Byte] = {
    Array(
      (i >>> 8).toByte,
       i.toByte
    )
  }
  
  def load(stored:ArrayView[Byte]) : LoadResult[Short] = {
    if(stored.length >=2) {
       val i : Short = 
	      ((stored(0) << 8) |
	       (stored(1) & 0xFF)).shortValue()
	   new LoadResult(i,stored.drop(4))
    }
    else {
    	new LoadResult(0.shortValue,stored) 
    }   
  }
}