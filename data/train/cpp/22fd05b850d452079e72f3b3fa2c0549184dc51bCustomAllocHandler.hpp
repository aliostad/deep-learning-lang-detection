#ifndef CUSTOMALLOCHANDLER_HPP
#define CUSTOMALLOCHANDLER_HPP

#include "HandlerAllocator.hpp"
#include <utility>

template <typename Handler>
class CustomAllocHandler
{
    public:
        CustomAllocHandler(HandlerAllocator& allocator, Handler handler) :
            allocator_(allocator), handler_(handler)
        {

        }

        template <typename ...Args>
        void operator()(Args&&... args)
        {
            handler_(std::forward<Args>(args)...);
        }

        friend void* asio_handler_allocate(std::size_t size,
                                           CustomAllocHandler<Handler>* handler)
        {
            return handler->allocator_.Allocate(size);
        }

        friend void asio_handler_deallocate(void* pointer, std::size_t,
                                        CustomAllocHandler<Handler>* handler)
        {
            handler->allocator_.Deallocate(pointer);
        }

    private:
        HandlerAllocator& allocator_;
        Handler handler_;
};

template <typename Handler>
inline CustomAllocHandler<Handler> MakeCustomAllocHandler(
                        HandlerAllocator& allocator, Handler handler)
{
    return CustomAllocHandler<Handler>(allocator, handler);
}

#endif

