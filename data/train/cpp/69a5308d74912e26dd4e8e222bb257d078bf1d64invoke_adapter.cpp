#include <test/test.hpp>
#include <falcon/functional/invoker.hpp>
#include <falcon/functional/invoke_adapter.hpp>
#include <falcon/functional/operators.hpp>
#include "invoke_adapter.hpp"

void invoke_adapter_test() {
  using namespace falcon;

	CHECK_EQUAL_VALUE(12, invoke_last_param<2>(plus<>(), 0, 1, 2, 4, 8));
	CHECK_EQUAL_VALUE(3, invoke_first_param<2>(plus<>(), 1, 2, 4, 8));
	CHECK_EQUAL_VALUE(9, invoke_ignore_param<1, 2>(plus<>(), 1, 2, 4, 8));

	CHECK_EQUAL_VALUE(12, invoke_partial_param_loop<2>(plus<>(), 1, 2, 4, 8));
	CHECK_EQUAL_VALUE(15, invoke_partial_recursive_param_loop<2>(plus<>(), 1, 2, 4, 8));
	CHECK_EQUAL_VALUE(25, invoke_partial_recursive_param_loop<2>(plus<>(), 1, 2, 4, 8, 10));
	CHECK_EQUAL_VALUE(5, invoke_partial_recursive_param_loop<2>(plus<>(), 1, 4));

	CHECK_EQUAL_VALUE(6, invoke_range_param<1, 2>(plus<>(), 1, 2, 4, 8));

	CHECK_EQUAL_VALUE(-2, invoke_reverse_param<0, 2>(minus<>(), 4, 2));

  typedef invoke_adapter<range_parameter_index_tag<1, 2>> adapter_type;
  adapter_type adapter;
  CHECK_EQUAL_VALUE(6, adapter(plus<>(), 1, 2, 4, 8));
  CHECK_EQUAL_VALUE(11, adapter(plus<>(), 1, 7, 4, 8));
  CHECK_EQUAL_VALUE(12, adapter(plus<>(), 1, 7, 5, 8));

  CHECK_EQUAL_VALUE(6, make_invoker(adapter, plus<>(), 1)(2, 4, 8));
}

FALCON_TEST_TO_MAIN(invoke_adapter_test)
