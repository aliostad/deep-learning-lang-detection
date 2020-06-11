#include "item7.h"

new_handler X::set_new_handler(new_handler p) {
        new_handler oldHandler = currentHandler;
        currentHandler = p;
        return oldHandler;
}

void * X::operator new(size_t size) {
        //X의 핸들러를 설치
        //명시적으로 std의 set_new_handler 사용
        new_handler globalHandler =
                std::set_new_handler(currentHandler);

        void * memory;

        try {
                // 전역 operator new를 호출 하여 할당 시도
                memory = ::operator new(size);
        } catch (std::bad_alloc) {
                //핸들러 복원
                std::set_new_handler(globalHandler);
                //예외 발생
                throw;
        }

        std::set_new_handler(globalHandler); //핸들러 복원
        
        return memory;
}
