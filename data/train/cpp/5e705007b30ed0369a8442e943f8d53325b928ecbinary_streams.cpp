#include "common/system_specific.h"
#include "binary_streams.h"

#include <iostream.h>

BinaryOutputStream::BinaryOutputStream( ostream& o )
  : _output_stream( o ) {
}

BinaryOutputStream::~BinaryOutputStream() {}

void BinaryOutputStream::write_byte( Byte b ) {
  _output_stream.put(b);
  _bytes_written++;
}


BinaryInputStream::BinaryInputStream( ObjectFactory* of, istream& i )
   : InputStream( of ), _input_stream( i ) {
}

BinaryInputStream::~BinaryInputStream() {}

Byte BinaryInputStream::read_byte() {
  int i = _input_stream.get();
  kernel_assert_message( i != EOF, ("End of file found") );
  return i;
}

