#ifndef FAS_SERIALIZATION_JSON_RPC_METHOD_INVOKE_RESPONSE_HPP
#define FAS_SERIALIZATION_JSON_RPC_METHOD_INVOKE_RESPONSE_HPP

#include <fas/aop/advice.hpp>
#include <fas/serialization/json/rpc/method/tags.hpp>
#include <fas/serialization/json/rpc/method/value_json.hpp>
namespace fas{ namespace json{ namespace rpc{ namespace method{

  /*
template<typename VJ =value_json >
struct invoke_response
  : advice<_invoke_response_, VJ > 
{
};
*/

template<typename V>
struct invoke_response
  : advice<_invoke_response_, value<V> > 
{
};

template<typename J>
struct invoke_response_json
  : advice<_invoke_response_json_, json<J> > 
{
};

}}}}

#endif

