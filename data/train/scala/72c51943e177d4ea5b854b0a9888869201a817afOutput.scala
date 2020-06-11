package termware.util

import java.nio.charset.StandardCharsets

trait Output
{
   def write(value: Array[Byte], offset: Int, limit:Int): Unit

   def write(value: Array[Byte]): Unit = write(value,0,value.length)

   def write(value: Byte): Unit 

   def writeByte(value: Byte): Unit = write(value)

   def writeBoolean(value: Boolean): Unit =
     writeByte( if (value) 1 else 0 )

   def writeChar(v:Char): this.type =
     writeInt(v.toInt)   

   def <<(v:Char): this.type = writeChar(v)

   def writeInt(v:Int): this.type =
   { write((v >> 24).toByte)     
     write((v >> 16).toByte)     
     write((v >> 8).toByte )     
     write((v     ).toByte )     
     this
   }
         
   def <<(v:Int): this.type = writeInt(v)

   def writeLong(v:Long): this.type =
   {
     writeInt( (v>>32).toInt ).writeInt( (v & 0xFFFFFFFF).toInt )
   }

   def <<(v:Long): this.type = writeLong(v)

   def writeString(s: String): this.type =
   {
     val bytes = s.getBytes(StandardCharsets.UTF_8)
     writeInt(bytes.length).write(bytes)
     this
   }
  
   def <<(s:String): this.type = writeString(s)

   def writeDouble(v:Double): this.type = 
     writeLong(java.lang.Double.doubleToLongBits(v))

   def <<(v:Double): this.type = writeDouble(v)

   def <<(v:Array[Byte]): this.type = {
     writeInt(v.length)
     write(v)
     this
   }

}


object Output
{


}
