package com.postgressive.client.messages

import io.netty.buffer.ByteBuf;
import io.netty.channel.ChannelHandlerContext;
import java.nio.charset.Charset;


abstract trait PostgresFrontendMessage extends PostgresMessage {
  def length():Int;
  def write(buf:ByteBuf);
	//charset is inherited from PostgresMessage
  
}

abstract class PostgresFrontendStringMessage(clientCharset:Charset = null) extends PostgresMessage(clientCharset) with PostgresFrontendMessage {
  this.charset = clientCharset match {
    case null => Charset.forName("UTF-8");
    case c:Charset => c;
  };
}

class BindParam(data:ByteBuf, isNull:Boolean = false) {
  def length():Int = if (isNull) { -1 } else { data.writerIndex; }
  def data():ByteBuf = data;
}


case class Bind(destPortal:String = "", stmtName:String = "", fmtCodes:List[Short], params:List[BindParam], resultFmtCodes:List[Short], clientCharset:Charset)  extends PostgresFrontendStringMessage(clientCharset) {
  
  val destPortalBytes = destPortal.getBytes(charset);
  val stmtNameBytes = stmtName.getBytes(charset);
  var msgLength = 12 + stmtNameBytes.length + destPortalBytes.length + (fmtCodes.length * 2) + (resultFmtCodes.length * 2);
  
  //param values are variable length so there's no way around it
  params.foreach {param:BindParam =>
    msgLength += 4 + Math.max(param.length, 0);
  }
  
  def length() = msgLength + 1;
  
  def write(buf:ByteBuf) = {
	  buf.writeByte('B');
	  
	  
	  //message length calculation
	  //4 bytes for msg length, 2 null terminators for the strings, 3 shorts for fmt code count, param count, result fmt count
	  //2 bytes for each format code, 2 bytes for each result format code
	  
	  
	  //write each thing in order (see http://www.postgresql.org/docs/9.1/interactive/protocol-message-formats.html for message formats)
	  buf.writeInt(msgLength);
	  buf.writeBytes(destPortalBytes);
	  buf.writeByte(0);
	  buf.writeBytes(stmtNameBytes);
	  buf.writeByte(0);
	  buf.writeShort(fmtCodes.length);
	  fmtCodes.foreach {fmtCode:Short => buf.writeShort(fmtCode); }
	  buf.writeShort(params.length);
	  params.foreach {param:BindParam => {
			  buf.writeInt(param.length);
			  buf.writeBytes(param.data, param.length match { case -1 => 0; case n => n });
		  }
	  }
	  buf.writeShort(resultFmtCodes.length);
	  resultFmtCodes.foreach {resultFmtCode:Short => buf.writeShort(resultFmtCode); }
	  //println(buf.writerIndex, msgLength);
	} 
}

case class CancelRequest(pid:Int, key:Int) extends PostgresFrontendMessage {
  
  def length() = 16;
  
  def write(buf:ByteBuf) = {
    buf.writeInt(16);
    buf.writeInt(80877102);	//magic number for cancel request
    buf.writeInt(pid);
    buf.writeInt(key);
  }
}

abstract class CloseWhat(name:String) { def name():String = name; }
case class ClosePortal(portalName:String) extends CloseWhat(portalName)
case class CloseStatement(stmtName:String) extends CloseWhat(stmtName)

case class Close(what:CloseWhat, clientCharset:Charset = null) extends PostgresFrontendStringMessage(clientCharset) {
  
  val whatNameBytes = what.name().getBytes(charset);
  val msgLength = 4 + 1 + 1 + whatNameBytes.length;
  
  def length() = msgLength + 1;
  
  def write(buf:ByteBuf) = {
	  buf.writeByte('C');
	  
	  buf.writeInt(msgLength); //int, indicator byte, null terminator
	  what match {
	    case _:ClosePortal => buf.writeByte('P');
	    case _:CloseStatement => buf.writeByte('S');
	  }
	  buf.writeBytes(whatNameBytes);
	  buf.writeByte(0);
  }
}

case class CopyFail(cause:String, clientCharset:Charset = null) extends PostgresFrontendStringMessage(clientCharset) {
  
  val causeBytes = cause.getBytes(charset);
  val msgLength = 5 + causeBytes.length;
  
  def length() = msgLength + 1;
  
  def write(buf:ByteBuf) = {
    buf.writeByte('f');
    
    buf.writeInt(msgLength);
    buf.writeBytes(causeBytes);
    buf.writeByte(0);
  }
}

abstract class DescribeWhat(name:String) { def name():String = name; }
case class DescribePortal(portalName:String) extends DescribeWhat(portalName)
case class DescribeStatement(stmtName:String) extends DescribeWhat(stmtName)

case class Describe(what:DescribeWhat, clientCharset:Charset) extends PostgresFrontendStringMessage(clientCharset) {
  
  val whatNameBytes = what.name().getBytes(charset);
  val msgLength = 4 + 1 + 1 + whatNameBytes.length;
  
  def length() = msgLength + 1;
  
  def write(buf:ByteBuf) = {
    buf.writeByte('D');
    
    buf.writeInt(msgLength); //int, indicator byte, null terminator
    what match {
      case _:DescribePortal => buf.writeByte('P');
      case _:DescribeStatement => buf.writeByte('S');
    }
    
    buf.writeBytes(whatNameBytes);
    buf.writeByte(0);
  }
}

case class Execute(portalName:String, maxRows:Int, clientCharset:Charset) extends PostgresFrontendStringMessage(clientCharset) {
  
  val portalNameBytes = portalName.getBytes(charset);
  val msgLength = 4 + 4 + 1 + portalNameBytes.length;
  
  def length() = msgLength + 1;
  
  def write(buf:ByteBuf) = {
    buf.writeByte('E');
    
    buf.writeInt(msgLength);
    buf.writeBytes(portalNameBytes);
    buf.writeByte(0);
    buf.writeInt(maxRows);
  }
}

case class Flush() extends PostgresFrontendMessage {
  def length() = 5;
  def write(buf:ByteBuf) = {
    buf.writeByte('H');
    buf.writeInt(4);
  }
}


class FunctionArgument(length:Int, data:ByteBuf) {
  def length():Int = length;
  def data():ByteBuf = data;
}

case class FunctionCall(funcOid:Int, argFmtCodes:Array[Short], args:Array[FunctionArgument], resultFmt:Short) extends PostgresFrontendMessage {
  
  //have to compute msg length
  //msg length (4), oid (4), numArgFmtCodes (2), array of shorts, num args (2), result format (2)
  var msgLength = 4 + 4 + 2 + (argFmtCodes.length * 2) + 2 + 2;
  //each one has length l (4) + l bytes
  args.foreach { arg:FunctionArgument => msgLength += arg.length + 4; }
  
  def length() = msgLength + 1;
  
  def write(buf:ByteBuf) = {
    buf.writeByte('F');
    
    //now write stuff
    buf.writeInt(msgLength);
    buf.writeInt(funcOid);
    buf.writeShort(argFmtCodes.length);
    argFmtCodes.foreach { argFmtCode:Short => buf.writeShort(argFmtCode); }
    
    buf.writeShort(args.length);
    args.foreach { arg:FunctionArgument => {
    	buf.writeInt(arg.length());
    	buf.writeBytes(arg.data());
      }
    }
    
    buf.writeShort(resultFmt);
  }
}

case class Parse(stmtName:String, query:String, paramTypes:List[Int], clientCharset:Charset = null) extends PostgresFrontendStringMessage(clientCharset) {
  
  val stmtNameBytes = stmtName.getBytes(charset);
  val queryBytes = query.getBytes(charset);
  val msgLength = 4 + 1 + 1 + 2 + stmtNameBytes.length + queryBytes.length + (paramTypes.length * 4);
  
  def length() = msgLength + 1;
  
  def write(buf:ByteBuf) = {

    buf.writeByte('P');
    buf.writeInt(msgLength);
    buf.writeBytes(stmtName.getBytes(charset));
    buf.writeByte(0);
    buf.writeBytes(queryBytes);
    buf.writeByte(0);
    buf.writeShort(paramTypes.length);
    paramTypes.foreach { oid:Int => buf.writeInt(oid); }
  }
}

// used for NUL-terminated plaintext password string OR encrypted password data.
// If passing a NUL-terminated string, MUST include the NUL byte at the end of the array.
case class PasswordMessage(data:Array[Byte]) extends PostgresFrontendMessage {
  
  def length() = 6 + data.length;
  
  def write(buf:ByteBuf) = {
    buf.writeByte('p');
    buf.writeInt(5 + data.length);
    buf.writeBytes(data);
    buf.writeByte(0);
  }
}

case class Query(query:String, clientCharset:Charset = null) extends PostgresFrontendStringMessage(clientCharset) {
  
  val queryBytes = query.getBytes(charset);
  val msgLength = 4 + queryBytes.length;
  
  def length() = msgLength + 1;
  
  def write(buf:ByteBuf) = {
    
    buf.writeByte('Q');
    buf.writeInt(msgLength);
    buf.writeBytes(queryBytes);
  }
}

case class SSLRequest() extends PostgresFrontendMessage {
  
  def length() = 8;
  
  def write(buf:ByteBuf) = {
    buf.writeInt(8);
    buf.writeInt(196608);	//magic number for SSL request
  }
}

case class StartupMessage(user:String, dbname:String = null, clientCharset:Charset = null) extends PostgresFrontendStringMessage(clientCharset) {
  
  val userBytes = user.getBytes(charset);
  var msgLength = 4 + 4 + "user".length + 1 + userBytes.length + 2;
  val dbnameBytes = dbname match { 
    	case null => new Array[Byte](0); 
    	case other:String => {
    		val bytes = other.getBytes(charset);
    		msgLength += "database".length + 1 + bytes.length + 1;
    		bytes;
    	}
    };
    
  def length() = msgLength + 1;
  
  def write(buf:ByteBuf) = {
    
    buf.writeInt(msgLength);
    
    buf.writeInt(196608);	//protocol version number for protocol v3.0
    
    buf.writeBytes("user".getBytes(charset));
    buf.writeByte(0);
    buf.writeBytes(userBytes);
    buf.writeByte(0);
    if(dbname != null) {
        buf.writeBytes("database".getBytes(charset));
        buf.writeByte(0);
        buf.writeBytes(dbnameBytes);
        buf.writeByte(0);
        
    }
    buf.writeByte(0);
    Unit;
  }
}

case class Sync() extends PostgresFrontendMessage {
  
  def length() = 5;
  
  def write(buf:ByteBuf) = {
    buf.writeByte('S');
    buf.writeInt(4);
  }
}

case class Terminate() extends PostgresFrontendMessage {
  
  def length() = 5;
  
  def write(buf:ByteBuf) = {
    buf.writeByte('X');
    buf.writeInt(4);
  }
}