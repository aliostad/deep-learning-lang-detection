/*
 * OutStream.cpp
 *
 *  Created on: Dec 15, 2013
 *      Author: baron
 */

#include "OutStream.h"
#include "IOutStream.h"
#include "EnumConverter.h"
#include <string>

namespace Core_TypeWrappers {
	OutStream::OutStream(std::ostream &stream) : stream(stream) {}

	OutStream::~OutStream() {
		stream.flush();
	}

	const Interfaces::IOutStream& OutStream::operator<<(const char* message) const {
		stream << message;

		return *this;
	}

	const Interfaces::IOutStream& OutStream::operator<<(const std::string &message) const {
		stream << message;

		return *this;
	}

	const Interfaces::IOutStream& OutStream::operator<<(std::ostream& (*func)(std::ostream&)) const {
		func(stream);

		return *this;
	}
}


