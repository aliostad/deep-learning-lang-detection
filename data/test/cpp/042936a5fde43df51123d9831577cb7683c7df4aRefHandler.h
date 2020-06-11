// RefHandler.h

#ifndef _FRAMEWORK_NETWORK_REF_HANDLER_H_
#define _FRAMEWORK_NETWORK_REF_HANDLER_H_

#include <boost/asio/detail/handler_invoke_helpers.hpp>

namespace framework
{
    namespace network
    {
        
        template <
            typename Handler
        >
        class RefHandler
        {
        public:
            RefHandler()
                : handler_(NULL)
            {
            }

            RefHandler(
                Handler & handler)
                : handler_(&handler)
            {
            }

        public:
            void operator()()
            {
                assert(handler_);
                boost_asio_handler_invoke_helpers::invoke(*handler_, handler_);
            }

        private:
            Handler * handler_;
        };

    } // namespace network
} // namespace framework

#endif // _FRAMEWORK_NETWORK_REF_HANDLER_H_
