package arx.core.serialization

import java.io.ObjectInput
import java.io.ObjectOutput

import arx.core.datastructures.AtomicMapi

import scala.collection.mutable.ArrayBuffer

/**
 * Created by IntelliJ IDEA.
 * User: nvt
 * Date: 10/9/11
 * Time: 12:21 PM
 * Created by nonvirtualthunk
 */

class ArxOutputStream(val stream: ObjectOutput ) {
	def writeNBHM[K,V] ( map: overlock.atomicmap.AtomicMap[K,V] ) {
		stream.writeInt( map.size )
		for ( (k,v) <- map ) {
			stream.writeObject(k)
			stream.writeObject(v)
		}
	//	stream.writeObject(map.toMap)
	}

	def writeNBHMi[K,V] ( map: AtomicMapi[K,V] ) {
		stream.writeInt( map.size )
		for ( (k,v) <- map ) {
			stream.writeObject(k)
			stream.writeObject(v)
		}
	//	stream.writeObject(map.toMap)
	}

//	def writeNBHMi[K,V] ( map: NonBlockingHashMapi[K,V] ) {
//		stream.writeInt( map.size )
//		for ( (k,v) <- map ) {
//			stream.writeObject(k)
//			stream.writeObject(v)
//		}
//	//	stream.writeObject(map.toMap)
//	}

	def writeArrayBuffer[T] ( list : ArrayBuffer[T] , func : (T) => Unit ) {
		stream.writeInt(list.size);
		list.foreach ( func(_) )
	}
	def writeList[T] ( list : List[T] , func : (T) => Unit ) {
		stream.writeInt(list.size);
		list.foreach ( func(_) )
	}
	def write ( o : AnyRef ) { stream.writeObject(o) }
	def write ( i : Int ) { stream.writeInt(i) }
	def write ( f : Float ) { stream.writeFloat(f) }
	def write ( f : Long ) { stream.writeLong(f) }
	def write ( f : Boolean ) { stream.writeBoolean(f) }
	def writeUTF8 ( s : String ) { stream.writeUTF(s) }

	def writeChar ( i : Char ) { stream.writeChar(i) }
	def writeInt ( i : Int ) { stream.writeInt(i) }
	def writeFloat ( f : Float ) { stream.writeFloat(f) }
	def writeLong ( f : Long ) { stream.writeLong(f) }
	def writeShort ( s : Int ) { stream.writeShort(s) }
	def writeByte ( s : Int ) { stream.writeByte(s) }
	def writeBoolean ( f : Boolean ) { stream.writeBoolean(f) }

}

object ArxOutputStream {
	implicit def outputStream2ArxOutputStream ( stream : ObjectOutput ) : ArxOutputStream = new ArxOutputStream(stream)
}

class ArxInputStream(val stream: ObjectInput ) {

	def readNBHM[K,V] : overlock.atomicmap.AtomicMap[K,V] = {
//		val m = readAs[ Map[K,V] ]
//		val r = overlock.atomicmap.AtomicMap.atomicNBHM[K,V]
//		for ( e <- m ) {
//			r( e._1 ) = e._2
//		}
//		r
		val n = stream.readInt
		val r = overlock.atomicmap.AtomicMap.atomicNBHM[K,V]
		for ( i <- 0 until n ) {
			r(readAs[K]) = readAs[V]
		}
		r
	}

//	def readNBHMi[K,V] : NonBlockingHashMapi[K,V] = {
//		val n = stream.readInt
//		val r = new NonBlockingHashMapi[K,V]
//		for ( i <- 0 until n ) {
//			r.put(readAs[K],readAs[V])
//		}
//		r
//	}

	def readNBHMi[K,V] : AtomicMapi[K,V] = {
		val n = stream.readInt
		val r = new AtomicMapi[K,V]
		for ( i <- 0 until n ) {
			r.put(readAs[K],readAs[V])
		}
		r
	}


	def readAs[T] : T = { stream.readObject.asInstanceOf[T] }
	def read[T] : T = { stream.readObject.asInstanceOf[T] }

	class ImplicitReader(val ais: ArxInputStream) {}
	object ImplicitReader {
		implicit def impRead[T] (ir: ImplicitReader) : T = { ir.ais.readAs[T] }
	}
	def readImplicitly = new ImplicitReader(this)

	def readArrayBuffer[T] ( func : () => T ) : ArrayBuffer[T] = {
		val numElements = stream.readInt
		val ret = new ArrayBuffer[T](numElements)
		for ( i <- 0 until numElements ) {
			ret.append(func())
		}
		ret
	}
	def readList[T] ( func : () => T ) : List[T] = {
		val numElements = stream.readInt
		var ret = List[T]()
		for ( i <- 0 until numElements ) {
			ret ::= func()
		}
		ret.reverse
	}
	def readInt = stream.readInt
	def readLong = stream.readLong
	def readFloat = stream.readFloat
	def readBoolean = stream.readBoolean
	def readChar = stream.readChar
	def readShort = stream.readShort
	def readByte = stream.readByte
	def readUTF8 = stream.readUTF
}

object ArxInputStream {
	implicit def inputStream2ArxInputStream ( stream : ObjectInput ) : ArxInputStream = new ArxInputStream(stream)
}