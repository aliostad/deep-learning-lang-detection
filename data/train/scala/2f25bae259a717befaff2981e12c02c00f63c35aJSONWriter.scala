package xyz.hyperreal.json

import java.io.{FileOutputStream, OutputStream, PrintStream, File, ByteArrayOutputStream}

import collection.Map


object DefaultJSONWriter
{
	private val default = new JSONWriter( 2 )
	
	def toString( m: Map[String, Any] ) = default.toString( m )
	
	def write( m: Map[String, Any], file: File ) = default.write( m, file )
	
	def write( m: Map[String, Any], file: String ) = default.write( m, file )
	
	def write( m: Map[String, Any], out: PrintStream ) = default.write( m, out )
	
	def write( m: Map[String, Any] ) = default.write( m )
}

class JSONWriter( indent: Int )
{
	def toString( m: Map[String, Any] ) =
	{
	val bytes = new ByteArrayOutputStream
	
		write( m, bytes )
		new String( bytes.toByteArray, "UTF-8" )
	}
	
	def write( m: Map[String, Any], file: File )
	{
	val out = new FileOutputStream( file )
	
		write( m, out )
		out.close
	}
	
	def write( m: Map[String, Any], file: String )
	{
	val out = new FileOutputStream( file )
	
		write( m, out )
		out.close
	}
	
	def write( m: Map[String, Any] )
	{
		write( m, Console.out, true )
	}

	def write( m: Map[String, Any], out: OutputStream, nl: Boolean = false )
	{
		Console.withOut( new PrintStream(out, true, "UTF-8") )	// force JSON encoding to be UTF-8
		{
			def scope( level: Int ) = print( " "*(level*indent) )
			
			def writeMap( level: Int, m: Map[String, Any] )
			{
				if (m.isEmpty)
					print( "{}" )
				else
				{
					def writeString( s: String )
					{
						print( '"' )
						
						for (ch <- s)
							escaped.get( ch ) match
							{
								case None => print( ch )
								case Some( e ) => print( e )
							}
						
						print( '"' )
					}
				
					def writeValue( level: Int, v: Any ): Unit =
						v match
						{
							case s: String => writeString( s )
							case m: Map[String, Any] => writeMap( level, m )
							case s: Seq[Any] =>
								val l = s.toList
								
								if (l isEmpty)
									print( "[]" )
								else
								{
									println( '[' )
									
									def members( l: List[Any] ): Unit =
										l match
										{
											case e :: Nil =>
												scope( level + 1 )
												writeValue( level + 1, e )
												println()
											case e :: tail =>
												scope( level + 1 )
												writeValue( level + 1, e )
												println( ',' )
												members( tail )
										}
									
									members( l )
									scope( level )
									print( ']' )
								}
							case _ => print( v )
						}
				
					def pair( k: String, v: Any )
					{
						scope( level + 1 )
						writeString( k )
						print( ": " )
						writeValue( level + 1, v )
					}
					
					def pairs( l: List[(String, Any)] )
					{
						l match
						{
							case (k, v) :: Nil => pair( k, v )
							case (k, v) :: tail =>
								pair( k, v )
								println( "," )
								pairs( tail )
						}
					}
				
					println( "{" )
					pairs( m.toList )
					println()
					scope( level )
					print( "}" )
				}
			}
			
			writeMap( 0, m )
			
			if (nl)
				println()
		}
	}

	private val escaped = Map( '\\' -> "\\\\", '"' -> "\\\"", '\t' -> "\\t", '\b' -> "\\b", '\f' -> "\\f", '\n' -> "\\n", '\r' -> "\\r", '\b' -> "\\b" )
}
