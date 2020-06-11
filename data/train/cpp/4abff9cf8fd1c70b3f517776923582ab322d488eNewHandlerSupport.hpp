#ifndef _NEW_HANDLER
#define _NEW_HANDLER

/**
 * Effective C++, Item 7
 */

#include <new>
#include <iostream>


template<class T>
class NewHandlerSupport {
public:
    static std::new_handler set_new_handler(std::new_handler p);
    static void* operator new(size_t size);
private:
    static std::new_handler currentHandler;
};


template<class T>
std::new_handler NewHandlerSupport<T>::set_new_handler(std::new_handler p) {
    std::new_handler oldHandler = currentHandler;
    currentHandler = p;
    return oldHandler;
}

template<class T>
void* NewHandlerSupport<T>::operator new(size_t size) {
    std::new_handler globalHandler = set_new_handler(currentHandler);
    void *mem;
    try {
        mem = ::operator new(size);
    } catch (std::bad_alloc&) {
        set_new_handler(globalHandler);
        throw;
    }
    set_new_handler(globalHandler);
    return mem;
}

template<class T>
std::new_handler NewHandlerSupport<T>::currentHandler;


#endif
