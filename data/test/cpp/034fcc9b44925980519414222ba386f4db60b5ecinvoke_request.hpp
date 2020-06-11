#ifndef FAS_SERIALIZATION_JSON_RPC_METHOD_INVOKE_REQUEST_HPP
#define FAS_SERIALIZATION_JSON_RPC_METHOD_INVOKE_REQUEST_HPP

#include <fas/aop/advice.hpp>
#include <fas/serialization/json/rpc/method/tags.hpp>
#include <fas/serialization/json/rpc/method/value_json.hpp>



namespace fas{ namespace json{ namespace rpc{ namespace method{

template<typename V  >
struct invoke_request
  : advice<_invoke_request_, value<V> > 
{
};

template<typename J  >
struct invoke_request_json
  : advice<_invoke_request_json_, json<J> > 
{
};


}}}}

#endif
