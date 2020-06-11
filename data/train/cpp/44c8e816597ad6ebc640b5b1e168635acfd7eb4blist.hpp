
#ifndef __LIST_HPP__
#define __LIST_HPP__

#include "mmemory.hpp"

namespace mlib
{
    template <typename T, std::size_t size_T = sizeof(T)>
    class List
    {
        private:

            template <typename TT>
            class Chunk
            {
                private:
                    std::size_t size;
                    Chunk<TT> * next;
                    Chunk<TT> * back;
                    unsigned char * data;

                public:

                    Chunk<TT>(std::size_t s)
                    {
                        size = s;
                        data = new_memory<unsigned char>(size * sizeof(TT), sizeof(TT));
                        next = 0;
                        back = 0;
                    }

                    Chunk<TT> * AddChunk()
                    {
                        Chunk<TT> * chunk = new Chunk<TT>(size);
                        Chunk<TT> * tmp = this;
                        while (tmp->next != 0) tmp = tmp->next;
                        tmp->next = chunk;
                        chunk->back = tmp;
                        return chunk;
                    }

                    void* Get(std::size_t num)
                    {
                        return reinterpret_cast<void*>(data + num * sizeof(TT));
                }

                    Chunk<TT>* GetNext()
                    {
                        return next;
                }

                    Chunk<TT>* GetBack()
                    {
                        return back;
                }

                    ~Chunk<TT>()
                    {
                        Chunk<TT> * tmp = this;
                        while (tmp->next != 0)
                        {
                                del_memory(static_cast<void*>(data));
                                tmp->next->back = tmp;
                                tmp = tmp->next;
                                tmp->back->~Chunk();
                        }
                    }

            };

            Chunk<T> * chunks;
            std::size_t chunk_size;
            std::size_t chunk_count;
            std::size_t lenght; // first empty , if lenght=size then this chank is full (only for last chunk)

            Chunk<T> * first;
            Chunk<T> * last;

            Chunk<T> * current;
            std::size_t current_n;

        public:

            List(std::size_t size_chunk = 1)
            {
                chunks = new Chunk<T>(size_chunk);

                chunk_size = size_chunk;
                chunk_count = 1;
                lenght = 0;
                first = chunks;
                current = first;
                last = first;
                current_n = 0;
            }

            ~List()
            {
                delete chunks;
            }

            void Add(T & item)
            {
                if (lenght >= chunk_size)
                {
                    last = chunks->AddChunk();
                    chunk_count++;
                    lenght = 0;
                }

                new(last->Get(lenght)) T(item);
                lenght++;
            }

            T Get(std::size_t index)
            {
                std::size_t num_chunk   = index / chunk_size;
                std::size_t delta_chunk = index % chunk_size;

                while (num_chunk != current_n)
                {
                    if (num_chunk < current_n)
                    {
                        current_n += -1;
                        current = current->GetBack();
                    }
                    else
                    {
                        current_n += 1;
                        current = current->GetNext();
                    }
                }

                return *(reinterpret_cast<T*>(current->Get(delta_chunk)));
            }

            std::size_t Count()
            {
                return chunk_count * chunk_size + lenght;
            }
    };
}

#endif
