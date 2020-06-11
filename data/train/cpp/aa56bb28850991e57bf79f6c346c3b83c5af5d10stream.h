#ifndef __LIBLLPP_STREAM_H__
#define __LIBLLPP_STREAM_H__

#include <cstdlib>
#include "page.h"
#include "file_io.h"

namespace ll {

namespace stream_helper {

struct input {
    page *_first_chunk;
    char *_firstp;
    size_t _size;

    input() noexcept : _first_chunk(), _firstp(), _size() {}
    input(const input_struct &x) noexcept : 
        _first_chunk(x._first_chunk),
        _firstp(x._firstp),
        _size(x._size) {}

    input(const input &x, size_t size) noexcept : 
        _first_chunk(x._first_chunk),
        _firstp(x._firstp),
        _size(size) {
        assert(size && x._size >= size);
    }

    input(input &&x) : noexcept {
        swap(x);
    }

    void swap(input &x) {
        std::swap(_first_chunk, x._first_chunk);
        std::swap(_firstp, x._firstp);
        std::swap(_size, x._size);
    }

    void discard(unsigned size) noexcept {
        assert(size && _size >= size);

        _size -= size;

        register page *chunk = _first_chunk;
        register size_t n = chunk->endp - _firstp;
        if (ll_likely(n >= size)) {
            _firstp += size;
        }
        else {
            while (1) {
                size -= n;

                if (!size) {
                    _firstp += n;
                    break;
                }

                chunk = chunk->next;
                _firstp = chunk->firstp;

                n = chunk->endp - _firstp;
                if (n > size) {
                    n = size;
                }
            }
            _first_chunk = chunk;
        }
    }

    static void read(input_struct *data, void *buf, size_t size) noexcept {
        assert(buf && size && _size >= size);

        _size -= size;

        register char *p = (char*)buf;
        register page *chunk = _first_chunk;
        register size_t n = chunk->endp - _firstp;
        if (ll_likely(n >= size)) {
            memcpy(p, _firstp, size);
            _firstp += size;
            return;
        }

        while (1) {
            if (ll_likely(n)) {
                memcpy(p, _firstp, n);
                size -= n;

                if (!size) {
                    _firstp += n;
                    return;
                }
                p += n;
            }

            chunk = chunk->next;
            _firstp = chunk->firstp;

            n = chunk->endp - _firstp;
            if (n > size) {
                n = size;
            }
        }
    }
};

struct output : input {
    page_allocator *_pa;
    page *_end_chunk;
    output(page_allocator *pa) noexcept : input() {
        if (!pa) {
            pa = page_allocator::global();
        }
        _pa = pa;
        init();
    }

    output(const output &x) noexcept : input(x) {
        _pa = x._pa;
        init();
        load(x);
    }

    output(output &&x) noexcept : input(std::move(x)), _end_chunk() {
        std::swap(_pa, x._pa);
        std::swap(_end_chunk, x._end_chunk);
    }

    ~output() noexcept {
        if (_end_chunk) {
            page *chunk = _end_chunk->next;
            while (1) {
                page *tmp = chunk->next;
                free_chunk(chunk);
                if (chunk == _end_chunk) {
                    break;
                }
                chunk = tmp;
            }
        }
    }

    void init(page *chunk = nullptr) noexcept {
        if (!chunk) {
            chunk = _pa->alloc();
        }
        _first_chunk = _end_chunk = chunk;
        chunk->next = chunk;
        _firstp = chunk->endp = chunk->firstp;
        _size = 0;
    }

    void swap(output &x) {
        std::swap(_pa, x._pa);
        std::swap(_end_chunk, x._end_chunk);
        input::swap(x);
    }

    page *alloc_chunk(size_t size = 1) noexcept {
        page *chunk = _pa->alloc(size);
        chunk->p = chunk->endp;
        return chunk;
    }

    void free_chunk(page *chunk) noexcept {
        _pa->free(chunk);
    }

};

}


class stream {
private:
    stream_helper::output _data;

public:
    stream(page_allocator *pa = nullptr) noexcept : _data(pa) {}

    stream(const stream &x) noexcept : _data(x._data) {}

    stream(stream &&x) noexcept : 
        _pa(x._pa), 
        _first_chunk(x._first_chunk), 
        _end_chunk(x._end_chunk),
        _firstp(x._firstp),
        _size(x._size) 
    {
        x._end_chunk = nullptr;
    }

    ~stream() noexcept {
    }

    stream &operator=(const stream &x) noexcept {
        clear();
        load(x);
        return *this;
    }

    stream &operator=(stream &&x) noexcept {
        std::swap(_pa, x._pa);
        std::swap(_first_chunk, x._first_chunk);
        std::swap(_end_chunk, x._end_chunk);
        std::swap(_firstp, x._firstp);
        std::swap(_size, x._size);
        return *this;
    }

    size_t size() noexcept {
        return _size;
    }

    void clear() {
        page *chunk = _end_chunk->next;
        while (chunk != _end_chunk) {
            page *tmp = chunk->next;
            _pa->free(chunk);
            chunk = tmp;
        }
        init(chunk);
    }

    void reclaim() {
        if (!_size) {
            _first_chunk = _end_chunk;
            _firstp = _first_chunk->endp = _first_chunk->firstp;
        }
        else if (_firstp == _first_chunk->endp) {
            _first_chunk = _first_chunk->next;
            _firstp = _first_chunk->firstp;
        }

        page *chunk = _end_chunk->next;
        while (chunk != _first_chunk) {
            page *tmp = chunk->next;
            _pa->free(chunk);
            chunk = tmp;
        }
        _end_chunk->next = _first_chunk;
    }

    void write(const void *buf, size_t size) noexcept {
        assert(size);
        
        _size += size;

        register char *p = (char*)buf;
        register page *chunk = _end_chunk;
        register size_t n = chunk->p - chunk->endp;
        if (ll_likely(n >= size)) {
            memcpy(chunk->endp, p, size);
            chunk->endp += size;
            return;
        }

        while (1) {
            memcpy(chunk->endp, p, n);
            chunk->endp += n;

            size -= n;
            if (!size) {
                return;
            }

            p += n;

            chunk = chunk->next;
            if (chunk == _first_chunk) {
                chunk = alloc_chunk();
                chunk->next = _end_chunk->next;
                _end_chunk->next = chunk;
            }
            _end_chunk = chunk;
            chunk->endp = chunk->firstp;
            n = chunk->p - chunk->endp;
            if (n > size) {
                n = size;
            }
        }
    }

    void *blank(size_t size) {
        assert(size);

        page *chunk = _end_chunk;
        void *p;

        _size += size;

        size_t n = chunk->p - chunk->endp;
        if (n >= size) {
            p = chunk->endp;
            chunk->endp += size;
            return p;
        }

        chunk = chunk->next;
        if (chunk == _first_chunk || (chunk->p < (chunk->firstp + size))) {
            chunk = alloc_chunk(size);
            chunk->next = _end_chunk->next;
            _end_chunk->next = chunk;
        }
        _end_chunk = chunk;
        chunk->endp = chunk->firstp + size;
        return chunk->firstp;
    }

    template <typename _F>
    void foreach_chunk(_F &&f) const noexcept {
        register page *chunk = _first_chunk;
        register char *p = _firstp;
        while (1) {
            if (chunk->endp != p) {
                if (!f(p, chunk->endp)) {
                    break;
                }
            }
            if (chunk == _end_chunk) {
                break;
            }
            chunk = chunk->next;
            p = chunk->firstp;
        }
    }

    void load(const stream &x) noexcept {
        x.foreach_chunk([this](const char *firstp, const char *endp) {
            write(firstp, endp - firstp);
            return true;
        });
    }

    int load(int fd) noexcept {
        page *chunk = _end_chunk;
        int count = 0;
        int n;

        while (1) {
            size_t csize = chunk->p - chunk->endp;
            if (csize) {
                ll_failed_return(n = file_io::read(fd, chunk->endp, csize));
                chunk->endp += n;
                csize -= n;
                count += n;
                if (csize) {
                    return count;
                }
            }

            chunk = chunk->next;
            if (chunk == _first_chunk) {
                chunk = alloc_chunk();
                chunk->next = _end_chunk->next;
                _end_chunk->next = chunk;
            }
            _end_chunk = chunk;
            chunk->endp = chunk->firstp;
        }
    }

    int load(file_io &io) noexcept {
        return load((int)io);
    }

    void output(stream &stream) noexcept {
        stream.load(*this);
        clear();
    }

    int output(int fd) noexcept {
        int count = 0;
        int n;
        unsigned size;
        while (1) {
            size = _first_chunk->endp - _firstp;
            if (size) {
                ll_failed_return(n = file_io::write(fd, _firstp, size));
                _firstp += n;
                count += n;
                size -= n;
                _size -= n;
                if (size) {
                    break;
                }
            }
            if (_first_chunk == _end_chunk) {
                break;
            }
            _first_chunk = _first_chunk->next;
            _firstp = _first_chunk->firstp;
        }
        return count;
    }

    int output(file_io &io) noexcept {
        return output((int)io);
    }

};

}
#endif

