// Caramel C++ Library Test - I/O - Buffer Stream Suite

#include "CaramelTestPch.h"

#include <Caramel/Io/BufferStream.h>


namespace Caramel
{

SUITE( BufferStream )
{

TEST( BufferStream )
{
    BufferStream stream;

    CHECK( 0 == stream.Position() );
    CHECK( 0 == stream.Tell() );
    CHECK( false == stream.IsEof() );

    stream.Write( "Alice", 5 );

    CHECK( 5 == stream.Position() );
    CHECK( 0 == stream.Tell() );
    CHECK( false == stream.IsEof() );

    Char buffer[6] = { 0 };

    CHECK( 5 == stream.Read( buffer, 5 ));
    CHECK( "Alice" == std::string( buffer ));
    
    CHECK( 5 == stream.Position() );
    CHECK( 5 == stream.Tell() );
    CHECK( false == stream.IsEof() );

    // Read at the end cause eof
    stream.Read( buffer, 1 );
    CHECK( true == stream.IsEof() );

    
    stream.Write( "Marisa", 6 );

    CHECK( 11 == stream.Position() );
    CHECK( 5  == stream.Tell() );
    CHECK( false == stream.IsEof() );

    Char bigBuffer[20] = { 0 };

    // Read over the end of the stream.
    CHECK( 6 == stream.Read( bigBuffer, 20 ));
    CHECK( "Marisa" == std::string( bigBuffer ));

    CHECK( 11 == stream.Position() );
    CHECK( 11 == stream.Tell() );
    CHECK( true == stream.IsEof() );
}

} // SUITE BufferStream

} // namespace Caramel
