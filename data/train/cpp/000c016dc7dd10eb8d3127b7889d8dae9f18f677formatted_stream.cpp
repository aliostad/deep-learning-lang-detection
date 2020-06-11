//
//  formatted_stream.cpp
//  grace
//
//  Created by Simon Ask Ulsnes on 29/07/12.
//  Copyright (c) 2012 Simon Ask Consulting. All rights reserved.
//

#include "io/formatted_stream.hpp"
#include "io/formatters.hpp"

#include <string.h>

namespace grace {
	FormattedStream& operator<<(FormattedStream& stream, const char *cstr) {
		stream.write((const byte*)cstr, strlen(cstr));
		return stream;
	}
	
	FormattedStream& operator<<(FormattedStream& stream, const String& str) {
		stream.write((const byte*)str.data(), str.size());
		return stream;
	}
	
	FormattedStream& operator<<(FormattedStream& stream, bool b) {
		stream << (b ? "true" : "false");
		return stream;
	}
	
	FormattedStream& operator<<(FormattedStream& stream, uint8 n) {
		stream << format("%u", n);
		return stream;
	}
	
	FormattedStream& operator<<(FormattedStream& stream, uint16 n) {
		stream << format("%u", n);
		return stream;
	}
	
	FormattedStream& operator<<(FormattedStream& stream, uint32 n) {
		stream << format("%u", n);
		return stream;
	}
	
	FormattedStream& operator<<(FormattedStream& stream, uint64 n) {
		stream << format("%llu", n);
		return stream;
	}
	
	FormattedStream& operator<<(FormattedStream& stream, char c) {
		stream.write((const byte*)&c, 1);
		return stream;
	}
	
	FormattedStream& operator<<(FormattedStream& stream, int8 n) {
		stream << format("%d", n);
		return stream;
	}
	
	FormattedStream& operator<<(FormattedStream& stream, int16 n) {
		stream << format("%d", n);
		return stream;
	}
	
	FormattedStream& operator<<(FormattedStream& stream, int32 n) {
		stream << format("%d", n);
		return stream;
	}
	
	FormattedStream& operator<<(FormattedStream& stream, int64 n) {
		stream << format("%lld", n);
		return stream;
	}
	
	FormattedStream& operator<<(FormattedStream& stream, float32 f) {
		stream << format("%f", f);
		return stream;
	}
	
	FormattedStream& operator<<(FormattedStream& stream, float64 f) {
		stream << format("%llf", f);
		return stream;
	}
	
	FormattedStream& operator<<(FormattedStream& stream, void* ptr) {
		return stream << format("%p", ptr);
	}

	FormattedStream& operator<<(FormattedStream& stream, const StringRef& str) {
		stream.write((byte*)str.data(), str.size());
		return stream;
	}
}
