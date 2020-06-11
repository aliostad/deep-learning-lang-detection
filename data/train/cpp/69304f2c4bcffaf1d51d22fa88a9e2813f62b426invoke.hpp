#ifndef NODEBIND_INVOKE_HPP
#define NODEBIND_INVOKE_HPP

#include "functiontraits.hpp"
#include "argumenttransform.hpp"

namespace nodebind
{
	namespace detail
	{
		template<size_t N>
		struct FreeInvoke
		{};

		template<size_t N>
		struct MemberInvoke
		{};

#include "detail/invoke_rep.hpp"

		template<typename Function, typename Tuple>
		typename GetReturnStorage<typename FunctionTraits<Function>::Return>::type freeInvoke(Function func, Tuple& args)
		{
			return FreeInvoke< FunctionTraits<Function>::Arity >::invoke(func, args);
		}

		template<typename Function, typename Tuple>
		typename GetReturnStorage<typename FunctionTraits<Function>::Return>::type memberInvoke(Function func, Tuple& args)
		{
			return MemberInvoke< FunctionTraits<Function>::Arity >::invoke(func, args);
		}
	}
}
#endif