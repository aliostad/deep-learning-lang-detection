#ifndef __WHEN_ALL_H__
#define __WHEN_ALL_H__

#include <functional>

class WhenAll {
public:
  template<class Handler> WhenAll(const Handler& handler)
    : _instance_count(new size_t(0))
    , _handler(handler)
  {}

  std::function<void()> make_continuation() {
    if (!_handler) return [](){};

    auto handler = _handler;
    auto count   = _instance_count;

    ++*count;

    return [handler, count]() {
      if (--*count == 0) {
        handler();
      }
    };
  }

private:
  std::shared_ptr<size_t> _instance_count;
  std::function<void()>   _handler;
};

#endif // ifndef __WHEN_ALL_H__
