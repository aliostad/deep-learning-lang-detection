package System.IO

import System.NotImplementedException
import System.NotImplementedException
import java.nio.ByteBuffer
import java.nio.ByteOrder
import System.Text.Encoding

class BinaryWriter(_s:Stream)
{
  final val BaseStream:Stream = _s;

  def Write(b:Byte)
  {
    _s._output.write(b);
  }
  
  def Write(bytes:Array[Byte])
  {
    _s._output.write(bytes);
  }
  
  private final val _internalBuffer = new Array[Byte](8);
  private final val _byteBuffer = ByteBuffer.wrap(_internalBuffer);
  _byteBuffer.order(ByteOrder.LITTLE_ENDIAN);
  
  private def WriteInternalBuffer(num:Int) 
  {
    _s._output.write(_internalBuffer, 0, num);
  }
  
  def Write(i:Int)
  {
    _byteBuffer.putInt(0, i);
    WriteInternalBuffer(4);
  }
  
  def Write(s:Short)
  {
    _byteBuffer.putShort(0, s);
    WriteInternalBuffer(2);
  }
  
  def Write(l:Long)
  {
    _byteBuffer.putLong(0, l);
    WriteInternalBuffer(8);
  }
  
  def Write(f:Float)
  {
    _byteBuffer.putFloat(0, f);
    WriteInternalBuffer(4);
  }
  
  def Write(d:Double)
  {
    _byteBuffer.putDouble(0, d);
    WriteInternalBuffer(8);
  }
  def Write_UInt16(i:Int)
  {
    _byteBuffer.putInt(0, i);
    WriteInternalBuffer(2);
  }
  def Write_UInt32(i:Long)
  {
    _byteBuffer.putInt(0, i.toInt);
    WriteInternalBuffer(4);
  }
  

  def Write(b:Boolean)
  {
    if (b)
      _s._output.write(1);
    else
      _s._output.write(0);
  }
  
  def Write7BitEncodedInteger(value:Int)
  {
    var num = value;
	while (num >= 128)
	{
		this.Write((num | 128).toByte);
		
		num >>= 7;
	}
	this.Write(num.toByte);

  }
  
  def Write(s:String)
  {
    val bytes = Encoding.UTF8.GetBytes(s);
    Write7BitEncodedInteger(bytes.length);
    
    Write(bytes);
  }
}