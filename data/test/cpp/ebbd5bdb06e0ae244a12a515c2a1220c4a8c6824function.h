#ifndef LBB_FUNCTIONAL_FUNCTION_H_
#define LBB_FUNCTIONAL_FUNCTION_H_

#include <lbb/meta.h>
#include <lbb/utility.h>

#include "function_/functor.h"
#include "function_/bad_call.h"
#include "function_/invoke_of.h"

#include "mem_fn.h"


namespace lbb {
namespace functional {

using namespace lbb::meta::introspection_;

template<typename T>
class function;


template<typename ResultType>
class function<ResultType()> : public safe_bool<function<ResultType()> > {

	typedef ResultType (*invoke_t)(function_::functor&);

public:
	typedef ResultType result_type;

	function() : _invoke(&function_::bad_call_of<ResultType>) { }

	template<typename Callable>
	function(Callable callable) :
		_functor(callable),
		_invoke(&function_::invoke_of<Callable, ResultType>) {
	}

	ResultType operator()() const {
		return _invoke(_functor);
	}

	void swap(function& other) {
		function_::functor tmp_functor = other._functor;
		invoke_t tmp_invoke = other._invoke;

		other._functor = _functor;
		other._invoke = _invoke;

		_functor = tmp_functor;
		_invoke = tmp_invoke;
	}

	bool boolean_value() const {
		return _invoke != (invoke_t) &function_::bad_call_of<ResultType>;
	}

private:
	mutable function_::functor _functor;
	invoke_t _invoke;
};




template<typename ResultType, typename A1>
class function<ResultType(A1)> : public safe_bool<function<ResultType(A1)> > {

	typedef ResultType (*invoke_t)(function_::functor&, A1);

public:
	typedef ResultType result_type;

	function() : _invoke(&function_::bad_call_of<ResultType, A1>) { }

	template<typename Callable>
	function(Callable callable, 
			 typename enable_if_<!signature_::is_member_<Callable>::value, void>::type* = 0) :
		_functor(callable),
		_invoke(&function_::invoke_of<Callable, ResultType, A1>) {
	}

	template<typename Callable>
	function(Callable callable, 
			 typename lbb::enable_if_<signature_::is_member_<Callable>::value, void>::type* = 0) :
		_functor(mem_fn(callable)),
		_invoke(&function_::invoke_of<typename mem_fn_of_<Callable>::type, ResultType, A1>) {
	}

	ResultType operator()(A1 arg1) const {
		return _invoke(_functor, forward(arg1));
	}

	void swap(function& other) {
		function_::functor tmp_functor = other._functor;
		invoke_t tmp_invoke = other._invoke;

		other._functor = _functor;
		other._invoke = _invoke;

		_functor = tmp_functor;
		_invoke = tmp_invoke;
	}

	bool boolean_value() const {
		return _invoke != (invoke_t) &function_::bad_call_of<ResultType, A1>;
	}

private:
	mutable function_::functor _functor;
	invoke_t _invoke;
};


/**
 * function with two arguments 
 */
template<typename ResultType, typename A1, typename A2>
class function<ResultType(A1, A2)> : public safe_bool<function<ResultType(A1, A2)> > {

	typedef ResultType (*invoke_t)(function_::functor&, A1, A2);

public:
	typedef ResultType result_type;

	function() : _invoke(&function_::bad_call_of<ResultType, A1, A2>) { }

	template<typename Callable>
	function(Callable callable,
	         typename enable_if_<!signature_::is_member_<Callable>::value, void>::type* = 0) :
		_functor(callable),
		_invoke(&function_::invoke_of<Callable, ResultType, A1, A2>) {
	}

	template<typename Callable>
	function(Callable callable,
	         typename lbb::enable_if_<signature_::is_member_<Callable>::value, void>::type* = 0) :
		_functor(mem_fn(callable)),
		_invoke(&function_::invoke_of<typename mem_fn_of_<Callable>::type, ResultType, A1, A2>) {
	}

	ResultType operator()(A1 arg1, A2 arg2) const {
		return _invoke(_functor, forward(arg1), forward(arg2));
	}

	void swap(function& other) {
		function_::functor tmp_functor = other._functor;
		invoke_t tmp_invoke = other._invoke;

		other._functor = _functor;
		other._invoke = _invoke;

		_functor = tmp_functor;
		_invoke = tmp_invoke;
	}

	bool boolean_value() const {
		return _invoke != (invoke_t) &function_::bad_call_of<ResultType, A1, A2>;
	}

private:
	mutable function_::functor _functor;
	invoke_t _invoke;
};


/*
 * function with three arguments 
 */
template<typename ResultType, typename A1, typename A2, typename A3>
class function<ResultType(A1, A2, A3)> : public safe_bool<function<ResultType(A1, A2, A3)> > {

	typedef ResultType (*invoke_t)(function_::functor&, A1, A2, A3);

public:
	typedef ResultType result_type;

	function() : _invoke(&function_::bad_call_of<ResultType, A1, A2, A3>) { }

	template<typename Callable>
	function(Callable callable,
	         typename enable_if_<!signature_::is_member_<Callable>::value, void>::type* = 0) :
		_functor(callable),
		_invoke(&function_::invoke_of<Callable, ResultType, A1, A2, A3>) {
	}

	template<typename Callable>
	function(Callable callable,
	         typename lbb::enable_if_<signature_::is_member_<Callable>::value, void>::type* = 0) :
		_functor(mem_fn(callable)),
		_invoke(&function_::invoke_of<typename mem_fn_of_<Callable>::type, ResultType, A1, A2, A3>) {
	}

	ResultType operator()(A1 arg1, A2 arg2, A3 arg3) const {
		return _invoke(_functor, forward(arg1), forward(arg2), forward(arg3));
	}

	void swap(function& other) {
		function_::functor tmp_functor = other._functor;
		invoke_t tmp_invoke = other._invoke;

		other._functor = _functor;
		other._invoke = _invoke;

		_functor = tmp_functor;
		_invoke = tmp_invoke;
	}

	bool boolean_value() const {
		return _invoke != (invoke_t) &function_::bad_call_of<ResultType, A1, A2, A3>;
	}

private:
	mutable function_::functor _functor;
	invoke_t _invoke;
};


/*
 * function with four arguments 
 */
template<typename ResultType, typename A1, typename A2, typename A3, typename A4 >
class function<ResultType(A1, A2, A3, A4)> : public safe_bool<function<ResultType(A1, A2, A3, A4)> > {

	typedef ResultType (*invoke_t)(function_::functor&, A1, A2, A3, A4);


public:
	typedef ResultType result_type;

	function() : _invoke(&function_::bad_call_of<ResultType, A1, A2, A3, A4>) { }

	template<typename Callable>
	function(Callable callable,
	         typename enable_if_<!signature_::is_member_<Callable>::value, void>::type* = 0) :
		_functor(callable),
		_invoke(&function_::invoke_of<Callable, ResultType, A1, A2, A3, A4>) {
	}

	template<typename Callable>
	function(Callable callable,
	         typename lbb::enable_if_<signature_::is_member_<Callable>::value, void>::type* = 0) :
		_functor(mem_fn(callable)),
		_invoke(&function_::invoke_of<typename mem_fn_of_<Callable>::type, ResultType, A1, A2, A3, A4>) {
	}

	ResultType operator()(A1 arg1, A2 arg2, A3 arg3, A4 arg4) const {
		return _invoke(_functor, forward(arg1), forward(arg2), forward(arg3), forward(arg4));
	}

	void swap(function& other) {
		function_::functor tmp_functor = other._functor;
		invoke_t tmp_invoke = other._invoke;

		other._functor = _functor;
		other._invoke = _invoke;

		_functor = tmp_functor;
		_invoke = tmp_invoke;
	}

	bool boolean_value() const {
		return _invoke != (invoke_t) &function_::bad_call_of<ResultType, A1, A2, A3, A4>;
	}

private:
	mutable function_::functor _functor;
	invoke_t _invoke;
};


/*
 * function with five arguments 
 */
template<typename ResultType, typename A1, typename A2, typename A3, typename A4, typename A5 >
class function<ResultType(A1, A2, A3, A4, A5)> : public safe_bool<function<ResultType(A1, A2, A3, A4, A5)> > {

	typedef ResultType (*invoke_t)(function_::functor&, A1, A2, A3, A4, A5);

public:
	typedef ResultType result_type;

	function() : _invoke(&function_::bad_call_of<ResultType, A1, A2, A3, A4, A5>) { }

	template<typename Callable>
	function(Callable callable,
	         typename enable_if_<!signature_::is_member_<Callable>::value, void>::type* = 0) :
		_functor(callable),
		_invoke(&function_::invoke_of<Callable, ResultType, A1, A2, A3, A4, A5>) {
	}

	template<typename Callable>
	function(Callable callable,
	         typename lbb::enable_if_<signature_::is_member_<Callable>::value, void>::type* = 0) :
		_functor(mem_fn(callable)),
		_invoke(&function_::invoke_of<typename mem_fn_of_<Callable>::type, ResultType, A1, A2, A3, A4, A5>) {
	}


	ResultType operator()(A1 arg1, A2 arg2, A3 arg3, A4 arg4, A5 arg5) const {
		return _invoke(_functor, forward(arg1), forward(arg2), forward(arg3), forward(arg4), forward(arg5));
	}

	void swap(function& other) {
		function_::functor tmp_functor = other._functor;
		invoke_t tmp_invoke = other._invoke;

		other._functor = _functor;
		other._invoke = _invoke;

		_functor = tmp_functor;
		_invoke = tmp_invoke;
	}

	bool boolean_value() const {
		return _invoke != (invoke_t) &function_::bad_call_of<ResultType, A1, A2, A3, A4, A5>;
	}

private:
	mutable function_::functor _functor;
	invoke_t _invoke;
};


}  // namespace functionnal
}  // namespace lbb


#endif /* LBB_FUNCTIONAL_FUNCTION_H_ */
