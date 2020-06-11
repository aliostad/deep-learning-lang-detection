// vim:ts=2:sw=2:expandtab:autoindent:filetype=cpp:
#ifndef REST_INPUT_STREAM_HPP
#define REST_INPUT_STREAM_HPP

#include <iosfwd>

namespace rest {

class input_stream {
public:
  input_stream() : stream(0), own(false) {}

  explicit input_stream(std::istream &stream)
    : stream(&stream), own(false) {}

  explicit input_stream(std::istream *stream, bool own = true)
    : stream(stream), own(own)
  {}

  input_stream(input_stream &o)
    : stream(o.stream), own(o.own)
  { o.stream = 0; }

  void move(input_stream &x) {
    x.reset();
    x.stream = stream;
    x.own = own;
    stream = 0;
  }

  void reset();

  std::istream &operator*() const { return *stream; }
  std::istream *operator->() const { return stream; }
  std::istream *get() const { return stream; }
  ~input_stream() { reset(); }

  bool operator!() const { return !stream; }

private:
  std::istream *stream;
  bool own;

  input_stream &operator=(input_stream const &); //DUMMY
};

}

#endif
