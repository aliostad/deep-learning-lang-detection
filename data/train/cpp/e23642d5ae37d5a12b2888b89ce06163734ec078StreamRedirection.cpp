#include "StreamRedirection.hpp"

namespace JEBIO {

StreamRedirection::StreamRedirection(std::ios& stream, std::ios& replacement)
    : m_Stream(stream),
      m_OriginalBuffer(stream.rdbuf(replacement.rdbuf()))
{}

StreamRedirection::StreamRedirection(std::ios& stream,
                                     std::streambuf* replacement)
    : m_Stream(stream),
      m_OriginalBuffer(stream.rdbuf(replacement))
{}

StreamRedirection::StreamRedirection(StreamRedirection&& other)
    : m_Stream(other.m_Stream),
      m_OriginalBuffer(other.m_OriginalBuffer)
{
    other.m_OriginalBuffer = nullptr;
}

StreamRedirection::~StreamRedirection()
{
    if (m_OriginalBuffer)
        m_Stream.rdbuf(m_OriginalBuffer);
}

}
