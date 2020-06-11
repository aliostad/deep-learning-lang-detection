

#include "stream.h"
#include <iostream>

namespace grt
{

  Stream::Stream( )
  {

  }
   
  Stream::~Stream( )
  {

  }
 
  Stream * 
  Stream::number( double d )
  {
    _buffer << d;
    return this;
  }

  Stream * 
  Stream::string( const std::string & s )
  {
    _buffer << s;
    return this;
  }

  Stream * 
  Stream::quote( const std::string & s )
  {
    _buffer << "\"" << s << "\"";
    return this;
  }

  Stream * 
  Stream::nl( void )
  {
    _buffer << std::endl;
    return this;
  }

  Stream *
  Stream::ws( void )
  {
    _buffer << " ";
    return this;
  }

  int
  Stream::flush( lua_State * L )
  {
    lua_pushlstring(L,_buffer.str( ).c_str( ),_buffer.str( ).length( ));
    /* clear */
    _buffer.str("\0");

    return 1;
  }
  
 
  const char Stream::className[] = "Stream";
  const Lua<Stream>::RegType Stream::methods[] = 
    {
      SCRIPTMETHOD(Stream,flush),
      { 0,0 }};
}
