/*
 * StreamConsolePrinter.h
 *
 *  Created on: 15-05-2012
 *      Author: root
 */

#ifndef STREAMCONSOLEPRINTER_H_
#define STREAMCONSOLEPRINTER_H_

// =================================================

#include <Arduino.h>

// =================================================

#include "DebugPrinter.h"

// =================================================

class StreamConsolePrinter : public Stream
{
	public:

		StreamConsolePrinter();
		StreamConsolePrinter( Stream* _underlyingStream );

		size_t write( uint8_t b );
		int available();
		int read();
		int peek();
		void flush();

		void setStream( Stream* _underlyingStream );

		Stream* underlyingStream;

	protected:

		DebugPrinter dp;
};

// =================================================

#endif /* STREAMCONSOLEPRINTER_H_ */

