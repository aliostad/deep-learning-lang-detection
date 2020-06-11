#ifndef HESIOD_STREAM_HPP
#define HESIOD_STREAM_HPP

#include <ostream>

#include "hesiod/standard_formatter.hpp"

namespace hesiod {

template <class FormatterT>
class stream {
public:

    using char_t = typename FormatterT::char_t;
    using stream_t = std::basic_ostream<char_t>;
    using formatter_t = FormatterT;

    stream(stream_t &stream) 
        : stream_(stream)
    {}

    template <class T>
    void operator<<(T &&str) {
        stream_ << str;
    }

private:
    stream_t &stream_; 
};

}
#endif
