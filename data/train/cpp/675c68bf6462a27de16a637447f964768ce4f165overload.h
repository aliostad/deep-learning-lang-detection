// Example implementation of polymorphic overload in C++11
//
// Usage:
//   using namespace overload;
//
//   struct A {
//     void operator()() {
//       cout << "void()" << endl;
//     }
//     int operator()(int) {
//       cout << "int(int)" << endl;
//     }
//   };
//
//   Overload<void(), int(int)> o = A();
//   o();
//   cout << o(100) << endl;
#ifndef OVERLOAD_H_
#define OVERLOAD_H_

#include <type_traits>
#include <utility>

namespace overload {

namespace detail {

template <typename... Types> struct TypeList {};

template <typename Sig> struct SigTraits;

template <typename R, typename... Args> struct SigTraits<R(Args...)> {
  typedef R ReturnType;
  typedef TypeList<Args...> ArgsType;
  typedef R (*InvokeFnType)(void*, Args&&...);
};

template <typename... Sigs> class InvokeFnTable;

template <> class InvokeFnTable<> {
 public:
  typedef void (*Deleter)(void*);

  constexpr InvokeFnTable(Deleter d) : deleter_(d) {}

  Deleter deleter() const {
    return deleter_;
  }

 private:
  const Deleter deleter_;
};

template <typename Sig, typename... Sigs>
class InvokeFnTable<Sig, Sigs...> : public InvokeFnTable<Sigs...> {
 public:
  typedef void (*Deleter)(void*);
  typedef typename SigTraits<Sig>::InvokeFnType InvokeFnType;

  constexpr InvokeFnTable(Deleter d, InvokeFnType fn,
                          typename SigTraits<Sigs>::InvokeFnType... fns)
      : InvokeFnTable<Sigs...>(d, fns...), invoke_fn_(fn) {}

  InvokeFnTable(const InvokeFnType&) = delete;
  InvokeFnTable(InvokeFnType&&) = delete;
  InvokeFnType& operator=(const InvokeFnType&) = delete;
  InvokeFnType& operator=(InvokeFnType&&) = delete;

  template <typename S>
  typename std::enable_if<std::is_same<S, Sig>::value, InvokeFnType>::type
  Get() const {
    return invoke_fn_;
  }

  template <typename S>
  typename std::enable_if<!std::is_same<S, Sig>::value,
                          typename SigTraits<S>::InvokeFnType>::type
  Get() const {
    return InvokeFnTable<Sigs...>::template Get<S>();
  }

  operator InvokeFnType() const {
    return invoke_fn_;
  }

 private:
  const InvokeFnType invoke_fn_;
};

template <typename T, typename Sig> struct Invoker;

template <typename T, typename R>
struct Invoker<T, R()> {
  static R Invoke(void* obj) {
    constexpr R (T::*fn)() = &T::operator();
    return (static_cast<T*>(obj)->*fn)();
  }
};

template <typename T, typename R, typename... Args>
struct Invoker<T, R(Args...)> {
  static R Invoke(void* obj, Args&&... args) {
    constexpr R (T::*fn)(Args...) = &T::operator();
    return (static_cast<T*>(obj)->*fn)(std::forward<Args>(args)...);
  }
};

template <typename T>
void Delete(void* obj) {
  delete static_cast<T*>(obj);
}

template <typename T, typename... Sigs>
constexpr InvokeFnTable<Sigs...> InitInvokeFnTable() {
  return InvokeFnTable<Sigs...>(&Delete<T>, &Invoker<T, Sigs>::Invoke...);
}

template <typename T, typename... Sigs>
struct InvokeFnTableHolder {
  constexpr InvokeFnTableHolder() : table(InitInvokeFnTable<T, Sigs...>()) {}
  const InvokeFnTable<Sigs...> table;
  static const InvokeFnTableHolder singleton;
};

template <typename T, typename... Sigs>
const InvokeFnTableHolder<T, Sigs...> InvokeFnTableHolder<T, Sigs...>::singleton;

template <typename T, typename... Sigs>
constexpr const InvokeFnTable<Sigs...>* GetTable() {
  return &InvokeFnTableHolder<T, Sigs...>::singleton.table;
}

template <typename ArgsType, typename... Sigs> struct DispatchReturnType;

template <typename ArgsType>
struct DispatchReturnType<ArgsType> {
//  typedef struct {} Type;
  struct Type;
};

template <typename ArgsType, typename Sig, typename... Sigs>
struct DispatchReturnType<ArgsType, Sig, Sigs...> {
  typedef typename std::conditional<
    std::is_same<ArgsType, typename SigTraits<Sig>::ArgsType>::value,
    typename SigTraits<Sig>::ReturnType,
    typename DispatchReturnType<ArgsType, Sigs...>::Type
  >::type Type;
};

}  // namespace detail

template <typename... Sigs>
class Overload {
 public:
  template <typename T>
  Overload(const T& obj)
      : obj_(new T(obj)), invoke_fn_table_(detail::GetTable<T, Sigs...>()) {}

  Overload(const Overload&) = delete;
  Overload& operator=(const Overload&) = delete;

  Overload(Overload&& o) : obj_(o.obj_), invoke_fn_table_(o.invoke_fn_table_) {
    o.obj_ = nullptr;
  }
  Overload& operator=(Overload&& o) {
    obj_ = o.obj_;
    o.obj_ = nullptr;
    invoke_fn_table_ = o.invoke_fn_table_;
  }

  ~Overload() {
    auto del = invoke_fn_table_->deleter();
    (*del)(obj_);
  }

  template <typename... Args>
  typename detail::DispatchReturnType<detail::TypeList<Args...>, Sigs...>::Type
  operator()(Args&&... args) {
    typedef detail::TypeList<Args...> ArgsType;
    typedef typename detail::DispatchReturnType<ArgsType, Sigs...>::Type Ret;
    typedef Ret Sig(Args...);
    //const auto fn = invoke_fn_table_->template Get<Sig>();
    const typename detail::SigTraits<Sig>::InvokeFnType fn = *invoke_fn_table_;
    return (*fn)(obj_, std::forward<Args>(args)...);
  }

 private:
  void* obj_;
  const detail::InvokeFnTable<Sigs...>* invoke_fn_table_;
};

}  // namespace overload

#endif  // OVERLOAD_H_
