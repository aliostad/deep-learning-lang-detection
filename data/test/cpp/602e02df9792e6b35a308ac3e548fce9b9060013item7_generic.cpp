#include "item7_generic.h"

template<class T>
new_handler NewHandlerSupport<T>::set_new_handler(new_handler p) {
        new_handler oldHandler = currentHandler;
        currentHandler = p;
        return oldHandler;
}

template <class T>
void* NewHandlerSupport<T>::operator new(size_t size) {
        new_handler globalHandler =
                std::set_new_handler(currentHandler);
        void* memory;

        try {
                memory = ::operator new(size);
        } catch (std::bad_alloc) {
                std::set_new_handler(globalHandler);
                throw;
        }

        std::set_new_handler(globalHandler);
        return memory;
}
