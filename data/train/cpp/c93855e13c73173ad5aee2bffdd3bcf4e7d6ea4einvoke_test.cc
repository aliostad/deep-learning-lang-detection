#include <cstddef>
#include <cstdint>
#include <type_traits>

#include "etl/invoke.h"

/*
 * Exercise Invoke, for if it fails, many other things will fail in unexpected
 * and obscure ways.
 */

static_assert(std::is_same<int, etl::Invoke<etl::TypeConstant<int>>>::value,
              "Invoke should trivially unwrap TypeConstant.");

static_assert(std::is_same<int,
                           etl::Invoke<std::conditional<true, int, bool>>
                           >::value,
              "Invoke should also unwrap std::conditional.");
