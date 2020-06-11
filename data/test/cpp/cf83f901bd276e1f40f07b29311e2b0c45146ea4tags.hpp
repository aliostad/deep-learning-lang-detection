#ifndef FAS_JSONRPC_INVOKE_TAGS_HPP
#define FAS_JSONRPC_INVOKE_TAGS_HPP

namespace fas{ namespace jsonrpc{

struct _invoke_request_;
struct _invoke_result_;
struct _invoke_notify_;
struct _invoke_error_;
struct _invoke_other_error_;

// invoke errors
struct _not_impl_;
struct _invoke_invalid_id_;
struct _notify_not_found_;
struct _request_not_found_;
struct _result_not_found_;
struct _error_not_found_;

struct _request_group_;
struct _notify_group_;
struct _result_group_;
struct _error_group_;

struct _check_range_;
struct _check_name_;

struct _id_;


  /*
struct _parse_incoming_;
struct _process_incoming_;
struct _parse_object_;
struct _parse_array_;
struct _process_object_;

struct _foreach_notify_;
struct _foreach_request_;


struct _remote_id_;
*/

}}

#endif
