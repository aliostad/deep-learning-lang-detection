#include "acsetup.hpp"
#include "fastcgi-daemon/details/standard_handler.hpp"

#include "fastcgi-daemon/http_error.hpp"
#include "fastcgi-daemon/request_handler.hpp"


namespace fcgid { namespace details {

standard_handler::standard_handler() :
	mask_(http_method_mask::none), handler_()
{
}

standard_handler::~standard_handler() {
}

standard_handler::standard_handler(standard_handler const &other) :
	mask_(other.mask_), handler_(other.handler_)
{
}

standard_handler&
standard_handler::operator = (standard_handler const &other) {
	standard_handler copy(other);
	swap(copy);
	return *this;
}

void
standard_handler::swap(standard_handler &other) throw () {
	using std::swap;
	swap(mask_, other.mask_);
	swap(handler_, other.handler_);
}

standard_handler::standard_handler(boost::shared_ptr<request_handler> const &handler, http_method_mask const &m) :
	mask_(m), handler_(handler)
{
}

void
standard_handler::handle(boost::shared_ptr<standard_handler::context_type> ctx, logger &log) const {
	handler_->handle_request(ctx->request(), ctx->response(), log);
}

standard_handler::operator standard_handler::bool_convertible const* () const {
	return handler_ ? reinterpret_cast<bool_convertible const*>(handler_.get()) : reinterpret_cast<bool_convertible const*>(0);
}

}} // namespaces
