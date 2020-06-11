#include "tool/log/LogStream.hpp"

LogStream::LogStream(std::ostream* stream) : AbstractLog(~0), _stream(stream) {

}

LogStream::LogStream(std::ostream* stream, int type_accept) : AbstractLog(type_accept), _stream(stream) {

}

LogStream::LogStream(const LogStream& origin) : AbstractLog(0), _stream(0) {
    operator=(origin);
}

void LogStream::send(std::string message) {
    *_stream << message;
	_stream->flush();
}

LogStream& LogStream::operator=(const LogStream& origin) {
    _stream = origin._stream;
    _type_accept = origin._type_accept;
    return *this;
}
