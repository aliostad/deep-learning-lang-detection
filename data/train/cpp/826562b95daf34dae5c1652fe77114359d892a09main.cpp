#include <iostream>
#include <string>
#include <vector>
#include "Widget.h"

using namespace std;

class NewHandlerHolder 
{
    public:
        explicit NewHandlerHolder(std::new_handler nh): handler(nh)
        {
        }

        ~NewHandlerHolder()
        {
            std::set_new_handler(handler);
        }

    private:
        std::new_handler handler;

        NewHandlerHolder(const NewHandlerHolder&);
        NewHandlerHolder& operator=(const NewHandlerHolder&);
};

template<typename T>
std::new_handler NewHandlerSupport<T>::currentHandler = 0;

    template<typename T>
std::new_handler NewHandlerSupport<T>::set_new_handler(std::new_handler p) throw()
{
    std::new_handler oldHandler = currentHandler;
    currentHandler = p;

    return oldHandler;
}

template<typename T>
void* NewHandlerSupport<T>::operator new(std::size_t size) throw(std::bad_alloc)
{
    NewHandlerHolder h(std::set_new_handler(currentHandler));
    return ::operator new(size);
}

void OutOfMem()
{
    cout << __func__ << endl;
}

int main()
{
    Widget::set_new_handler(OutOfMem);

    Widget* pw1 = new Widget;

    std::string* ps = new std::string;

    Widget::set_new_handler(0);

    Widget* pw2 = new Widget;
}
