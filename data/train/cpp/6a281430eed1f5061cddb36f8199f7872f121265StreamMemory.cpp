#include "StreamMemory.h"

using namespace std;

// constructor
StreamMemory::StreamMemory( iostream & s )
: stream( s ), streamSize( 0 )
{
    stream.seekg( -1, ios::end );
    if( -1 == ( streamSize = stream.tellg() ) )
    {
        cout << "Error" << endl;
    }
}

// destructor
StreamMemory::~StreamMemory()
{}

StreamMemory::value_t StreamMemory::get( address_t i )
{
    stream.seekg( i, ios::beg );
    return stream.get();
}

void StreamMemory::set( address_t i, value_t d )
{
    stream.seekp( i, ios::beg );
    stream.put( d );
}

StreamMemory::address_t StreamMemory::size() const
{
    return streamSize;
}
