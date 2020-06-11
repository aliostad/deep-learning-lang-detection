// Copyright David Abrahams 2004. Distributed under the Boost
// Software License, Version 1.0. (See accompanying
// file LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)
#ifndef INVOKE_TAG_DWA2004917_HPP
# define INVOKE_TAG_DWA2004917_HPP

namespace boost { namespace langbinding { namespace function { namespace aux { 

template <bool void_return, bool member>
struct invoke_tag_ {};

// from BPL
template <class R, class F>
struct invoke_tag
  : invoke_tag_<
        is_same<R,void>::value
      , is_member_function_pointer<F>::value
    >
{
};

}}}} // namespace boost::langbinding::function::aux_

#endif // INVOKE_TAG_DWA2004917_HPP
