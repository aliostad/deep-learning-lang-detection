#ifndef FALCON_FUNCTIONAL_INVOKE_ADAPTER_HPP
#define FALCON_FUNCTIONAL_INVOKE_ADAPTER_HPP

#include <falcon/c++1x/syntax.hpp>
#include <falcon/functional/invoke.hpp>
#include <falcon/functional/invoke_partial_param_loop.hpp>
#include <falcon/functional/invoke_partial_recursive_param_loop.hpp>
#include <falcon/parameter/keep_parameter_index.hpp>

namespace falcon {

///\brief Tag for used @p invoke_partial_param_loop() with @c invoke_adapter
template<std::size_t NumArg>
struct invoke_partial_param_loop_tag {};

///\brief Tag for used @p invoke_partial_recursive_param_loop() with @c invoke_adapter
template<std::size_t NumArg>
struct invoke_partial_recursive_param_loop_tag {};


/**
 * \brief Functor for used \link call-arguments \p invoke(), \p invoke_partial_param_loop() and \p invoke_partial_recursive_param_loop() \endlink
 *
 * Tag is \p invoke_partial_param_loop_tag for used \p invoke_partial_param_loop(), \p invoke_partial_recursive_param_loop_tag for used \p invoke_partial_recursive_param_loop(), each tag of \link indexes-tag indexes-tag \endlink or \p parameter_index
 * @{
 */
template <class Tag = full_parameter_index_tag>
struct invoke_adapter
{
  constexpr invoke_adapter() noexcept {}

  template<
    class Func, class... Args
  , class BuildIndexes = typename keep_parameter_index<
      typename parameter_index_or_tag_to_tag<Tag>::type, sizeof...(Args)
    >::type
  >
  constexpr CPP1X_DELEGATE_FUNCTION_NOEXCEPT(
    operator()(Func && f, Args&&... args) const
  , invoke(BuildIndexes(), std::forward<Func>(f), std::forward<Args>(args)...))
};

template <std::size_t NumArg>
struct invoke_adapter<invoke_partial_param_loop_tag<NumArg>>
{
  template<class Func, class... Args>
  constexpr CPP1X_DELEGATE_FUNCTION_NOEXCEPT(
    operator()(Func && f, Args&&... args) const
  , invoke_partial_param_loop<NumArg>(
    std::forward<Func>(f), std::forward<Args>(args)...
  ))
};

template <std::size_t NumArg>
struct invoke_adapter<invoke_partial_recursive_param_loop_tag<NumArg>>
{
  template<class Func, class... Args>
  constexpr CPP1X_DELEGATE_FUNCTION_NOEXCEPT(
    operator()(Func && f, Args&&... args) const
  , invoke_partial_recursive_param_loop<NumArg>(
    std::forward<Func>(f), std::forward<Args>(args)...
  ))
};

//@}

template <class Tag>
invoke_adapter<Tag> make_invoke_adapter(Tag)
{ return {};  }


template<std::size_t Keep = 1>
using invoke_first_param_fn = invoke_adapter<first_parameter_index_tag<Keep>>;

template<std::size_t Keep = 1, class Function, class... Args>
constexpr CPP1X_DELEGATE_FUNCTION_NOEXCEPT(
  invoke_first_param(Function && func, Args&&... args)
, invoke_first_param_fn<Keep>()(
    std::forward<Function>(func), std::forward<Args>(args)...
))


template<std::size_t Keep = 1>
using invoke_last_param_fn = invoke_adapter<last_parameter_index_tag<Keep>>;

template<std::size_t Keep = 1, class Function, class... Args>
constexpr CPP1X_DELEGATE_FUNCTION_NOEXCEPT(
  invoke_last_param(Function && func, Args&&... args)
, invoke_last_param_fn<Keep>()(
    std::forward<Function>(func), std::forward<Args>(args)...
))


template<std::size_t Start, std::size_t Len>
using invoke_range_param_fn
  = invoke_adapter<range_parameter_index_tag<Start, Len>>;

template<std::size_t Start, std::size_t Len, class Function, class... Args>
constexpr CPP1X_DELEGATE_FUNCTION_NOEXCEPT(
  invoke_range_param(Function && func, Args&&... args)
, invoke_range_param_fn<Start, Len>()(
    std::forward<Function>(func), std::forward<Args>(args)...
))


template<std::size_t Pos, std::size_t Ignore = 1>
using invoke_ignore_param_fn
  = invoke_adapter<ignore_parameter_index_tag<Pos, Ignore>>;

template<std::size_t Pos, std::size_t Ignore = 1, class Function, class... Args>
constexpr CPP1X_DELEGATE_FUNCTION_NOEXCEPT(
  invoke_ignore_param(Function && func, Args&&... args)
, invoke_ignore_param_fn<Pos, Ignore>()(
    std::forward<Function>(func), std::forward<Args>(args)...
))


template<std::size_t Start = 0, std::size_t Len = -1u>
using invoke_reverse_param_fn
  = invoke_adapter<reverse_parameter_index_tag<Start, Len>>;

template<
  std::size_t Start = 0, std::size_t Len = -1u
, class Function, class... Args>
constexpr CPP1X_DELEGATE_FUNCTION_NOEXCEPT(
  invoke_reverse_param(Function && func, Args&&... args)
, invoke_reverse_param_fn<Start, Len>()(
    std::forward<Function>(func), std::forward<Args>(args)...
))

}

#endif
