// vim:ts=2:sw=2:expandtab:autoindent:filetype=cpp:
#ifndef REST_OUTPUT_STREAM_HPP
#define REST_OUTPUT_STREAM_HPP

#include <iosfwd>

namespace rest {

class output_stream {
public:
  output_stream() : stream(0), own(false) {}

  explicit
  output_stream(std::ostream &stream)
    : stream(&stream), own(false)
  {}

  explicit
  output_stream(std::ostream *stream, bool own = true)
    : stream(stream), own(own)
  {}

  output_stream(output_stream &o)
    : stream(o.stream), own(o.own)
  { o.stream = 0; }

  void move(output_stream &x) {
    x.reset();
    x.stream = stream;
    x.own = own;
    stream = 0;
  }

  std::ostream &operator*() const { return *stream; }
  std::ostream *operator->() const { return stream; }
  std::ostream *get() const { return stream; }
  ~output_stream() { reset(); }

  void reset();

private:
  std::ostream *stream;
  bool own;

  output_stream &operator=(output_stream const &); //DUMMY
};

}

#endif
