//
// Created by kubas1129 on 30.03.17.
//

#ifndef JIMP_EXERCISES_MEMORYCHUNK_H
#define JIMP_EXERCISES_MEMORYCHUNK_H

#include <cstdint>
#include <algorithm>

namespace memorychunk{

    class MemoryChunk {

    public:

        MemoryChunk(size_t sz);
        int8_t *MemoryAt(size_t offset) const;
        size_t ChunkSize() const;

        //Rule of five://
        //1. konstruktor kopiujący
        MemoryChunk(const MemoryChunk &memorychunk);
        //2. konstruktor przenoszący
        MemoryChunk(MemoryChunk &&memorychunk);
        //3. operator przypisania kopiujący
        MemoryChunk &operator=(const MemoryChunk &memorychunk);
        //4. operator przypisania przenoszący
        MemoryChunk &operator=(MemoryChunk &&memorychunk);
        //5. Destruktor
        ~MemoryChunk();

    private:
        size_t size_;
        int8_t *ptr_;

        void Copy(const MemoryChunk &memorychunk);

        void Move(MemoryChunk &&memorychunk);
    };
}




#endif //JIMP_EXERCISES_MEMORYCHUNK_H
