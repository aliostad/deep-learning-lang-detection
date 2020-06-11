/*
 * zrtp.org is a ZRTP protocol implementation  
 * Copyright (C) 2010 - PrivateWave Italia S.p.A.
 *  
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as
 * published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 *  
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *  
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *  
 * For more information, please contact PrivateWave Italia S.p.A. at
 * address zorg@privatewave.com or http://www.privatewave.com
 */

#include <stdio.h>
#include <stdarg.h>

#include <zorg/zorg.h>
#include <zorg/log.h>

namespace ZORG
{
namespace Log
{
namespace Internals
{

static char * dumpChar(char c, char * dump)
{
    *dump ++ = c;
    return dump;
}

static char * dumpRawByte(unsigned char b, char * dump)
{
    char c;

    if(b < 32 || b >= 127)
	c = '.';
    else
	c = static_cast<char>(b);

    return dumpChar(c, dump);
}

static char * dumpHexNybble(unsigned char n, char * dump)
{
    char c;

    if(n < 10)
	c = '0' + n;
    else if(n < 16)
	c = 'A' + (n - 10);
    else
    {
	assert(false);
	c = '?';
    }

    return dumpChar(c, dump);
}

static char * dumpHexByte(unsigned char b, char * dump)
{
    dump = dumpHexNybble((b & 0xf0) >> 4, dump);
    dump = dumpHexNybble((b & 0x0f) >> 0, dump);
    return dump;
}

static char * dumpOffset(size_t off, char * dump)
{
    for(size_t shift = (sizeof(off) - 1) * CHAR_BIT, mask = 0xff << shift; mask != 0; mask >>= CHAR_BIT, shift -= CHAR_BIT)
	dump = dumpHexByte(static_cast<unsigned char>((off & mask) >> shift), dump);

    return dump;
}

const char * hexDump(const void * p, size_t n, char * dump)
{
    static const size_t BYTES_PER_LINE = 16;
    const unsigned char * pb = static_cast<const unsigned char *>(p);
    const char * ret = dump;

    for(size_t cb = n, o = 0; cb > 0; cb -= BYTES_PER_LINE, pb += BYTES_PER_LINE, o += BYTES_PER_LINE)
    {
	if(o)
	    dump = dumpChar('\n', dump);

	size_t lineSize = std::min(cb, BYTES_PER_LINE);

	dump = dumpOffset(o, dump);
	dump = dumpChar(' ', dump);

	for(size_t i = 0; i < lineSize; ++ i)
	{
	    dump = dumpHexByte(pb[i], dump);
	    dump = dumpChar(' ', dump);
	}

	for(size_t i = lineSize; i < BYTES_PER_LINE; ++ i)
	{
	    dump = dumpChar(' ', dump);
	    dump = dumpChar(' ', dump);
	    dump = dumpChar(' ', dump);
	}

	for(size_t i = 0; i < lineSize; ++ i)
	    dump = dumpRawByte(pb[i], dump);

	if(lineSize < BYTES_PER_LINE)
	    break;
    }

    *dump ++ = 0;

    return ret;
}

const char * textDump(const void * p, size_t n, char * dump)
{
    const char * ret = dump;
    const unsigned char * pb = static_cast<const unsigned char *>(p);

    for(size_t i = 0; i < n; ++ i)
	dump = dumpRawByte(pb[i], dump);

    *dump ++ = 0;
    return ret;
}

const char * hexLineDump(const void * p, size_t n, char * dump)
{
    const char * ret = dump;
    const unsigned char * pb = static_cast<const unsigned char *>(p);

    for(size_t i = 0; i < n; ++ i)
	dump = dumpHexByte(pb[i], dump);

    *dump ++ = 0;
    return ret;
}

}
}
}

extern "C"
{
void Zorg_Log_Wrapper1(const char * context, const char * format, ...)
{
    va_list ap;
    va_start(ap, format);
    Zorg_Log(1, context, format, ap);
    va_end(ap);
}

void Zorg_Log_Wrapper2(const char * context, const char * format, ...)
{
    va_list ap;
    va_start(ap, format);
    Zorg_Log(2, context, format, ap);
    va_end(ap);
}

void Zorg_Log_Wrapper3(const char * context, const char * format, ...)
{
    va_list ap;
    va_start(ap, format);
    Zorg_Log(3, context, format, ap);
    va_end(ap);
}

void Zorg_Log_Wrapper4(const char * context, const char * format, ...)
{
    va_list ap;
    va_start(ap, format);
    Zorg_Log(4, context, format, ap);
    va_end(ap);
}

void Zorg_Log_Wrapper5(const char * context, const char * format, ...)
{
    va_list ap;
    va_start(ap, format);
    Zorg_Log(5, context, format, ap);
    va_end(ap);
}
}

// EOF
