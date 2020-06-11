// BindHandler.h

#ifndef _FRAMEWORK_NETWORK_BIND_HANDLER_H_
#define _FRAMEWORK_NETWORK_BIND_HANDLER_H_

namespace framework
{
    namespace network
    {
        
        class BindHandler
        {
        public:
            BindHandler()
                : handler_(NULL)
                , invoke_handler_(NULL)
                , delete_handler_(NULL)
            {
            }

            template <
                typename Handler
            >
            BindHandler(
                Handler const & handler)
            {
                bind(handler);
            }

            ~BindHandler()
            {
                clear();
            }

        public:
            template <
                typename Handler
            >
            void bind(
                Handler const & handler)
            {
                assert(handler_ == NULL);
                handler_ = create_handler(handler);
                invoke_handler_ = invoke_handler<Handler>;
                delete_handler_ = delete_handler<Handler>;
            }

            void clear()
            {
                if (handler_) {
                    delete_handler_(handler_);
                    handler_ = NULL;
                }
            }

        public:
            void operator()()
            {
                invoke_handler_(handler_);
            }

        private:
            // non copyable
            BindHandler(
                BindHandler const & r);

            BindHandler & operator=(
                    BindHandler const & r);

        private:
            template <
                typename Handler
            >
            static void * create_handler(
                Handler const & handler)
            {
                void * ptr = boost_asio_handler_alloc_helpers::allocate(sizeof(Handler), &handler);
                new (ptr) Handler(handler);
                return ptr;
            }

            template <
                typename Handler
            >
            static void invoke_handler(
                void * handler)
            {
                Handler * handler2 = (Handler *)handler;
                boost_asio_handler_invoke_helpers::invoke(*handler2, handler2);
            }

            template <
                typename Handler
            >
            static void delete_handler(
                void * handler)
            {
                Handler * handler2 = (Handler *)handler;
                handler2->~Handler();
                boost_asio_handler_alloc_helpers::deallocate(handler, sizeof(Handler), handler2);
            }

        private:
            void * handler_;
            void (* invoke_handler_)(void *);
            void (* delete_handler_)(void *);
        };

    } // namespace network
} // namespace framework

#endif // _FRAMEWORK_NETWORK_BIND_HANDLER_H_
