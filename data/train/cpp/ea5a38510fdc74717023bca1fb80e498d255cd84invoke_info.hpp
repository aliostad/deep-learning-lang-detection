#ifndef INVOKE_INFO_HPP
#define INVOKE_INFO_HPP

namespace r5 {
  class Method;
  class GCImpl;

  class InvokeInfo {
    InvokeInfo* previous_;
    int ip_;
    Method* method_;

    friend class GCImpl;
  public:
    InvokeInfo(InvokeInfo* p, int ip, Method* m)
      : previous_(p)
      , ip_(ip)
      , method_(m)
    {}

    InvokeInfo(int ip, Method* m)
      : previous_(0)
      , ip_(ip)
      , method_(m)
    {}

    InvokeInfo* previous() {
      return previous_;
    }

    Method* method() {
      return method_;
    }

    int ip() {
      return ip_;
    }
  };
}

#endif
