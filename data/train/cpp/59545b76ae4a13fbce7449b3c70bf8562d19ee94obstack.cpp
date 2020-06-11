#include <cassert>
#include "obstack.h"
#include "printf.h"
#include <cstdio>
#include <cstdlib>

namespace ll {

obstack *obstack::_new(size_t initsize, page_allocator *pa) 
{
    if (!pa) {
        pa = page_allocator::global();
    }

    page *chunk; 
    initsize += ll_align_default(sizeof(obstack));
    chunk = pa->alloc(initsize);
    chunk->next = nullptr;

    obstack *ob = (obstack*)chunk->firstp;
    chunk->firstp += ll_align_default(sizeof(obstack));

    ob->_pa = pa;
    ob->_chunk = chunk;
    ob->_next_free = ob->_object_base = chunk->firstp;
    ob->_chunk_limit = chunk->endp;
    ob->_maybe_empty_object = false;
    return ob;
}

void obstack::_delete(obstack *ob)
{
    page_allocator *pa = ob->_pa;
    page *chunk = ob->_chunk;
    page *tmp;
    while (chunk) {
        tmp = chunk->next;
        pa->free(chunk);
        chunk = tmp;
    }
}

void obstack::clear()
{
    page *chunk = _chunk;
    page *tmp;
    while (1) {
        tmp = chunk->next;
        if (!tmp) {
            break;
        }
        _pa->free(chunk);
        chunk = tmp;
    }
    _chunk = chunk;
    _next_free = _object_base = chunk->firstp;
    _chunk_limit = chunk->endp;
    _maybe_empty_object = false;
}

void obstack::newchunk(size_t length)
{
    register page *old_chunk = _chunk;
    register page *new_chunk;
    register size_t new_size;
    register size_t obj_size = _next_free - _object_base;
    char *object_base;

    new_size = obj_size + length + 128;
    new_chunk = _pa->alloc(new_size);

    _chunk = new_chunk;
    new_chunk->next = old_chunk;
    _chunk_limit = new_chunk->endp;

    /* Compute an aligned object_base in the new chunk */
    object_base = new_chunk->firstp;
    memcpy(object_base, _object_base, obj_size);

    if (!_maybe_empty_object && (_object_base == old_chunk->firstp) && old_chunk->next) {
        new_chunk->next = old_chunk->next;
        _pa->free(old_chunk);
    }

    _object_base = object_base;
    _next_free = _object_base + obj_size;
    _maybe_empty_object = false;
}

void obstack::free(page *chunk, char *obj)
{
    page *tmp;
    while ((tmp = chunk->next) && (chunk->firstp >= obj || chunk->endp < obj)) {
        _pa->free(chunk);
        chunk = tmp;
        /* If we switch chunks, we can't tell whether the new current
           chunk contains an empty object, so assume that it may.  */
        _maybe_empty_object = true;
    }

    if (!tmp && (chunk->firstp > obj || chunk->endp < obj)) {
        crit_error("obstack free failed, obj is not in any of the chunks!");
    }

    _object_base = _next_free = obj;
    _chunk_limit = chunk->endp;
    _chunk = chunk;
}


int obstack::vprint(const char *fmt, va_list ap)
{
    struct obstack_vbuff : public printf_formatter::buff {
        obstack *_owner;

        int flush() {
            _owner->_next_free = curpos;
            if (_owner->_next_free >= _owner->_chunk_limit) {
                _owner->make_rome(128);
                curpos = _owner->_next_free;
                endpos = _owner->_chunk_limit;
            }
            return 0;
        }
    };

    obstack_vbuff buff;

    buff._owner = this;
    buff.curpos = _next_free;
    buff.endpos = _chunk_limit;

    int n;
    if ((n = printf_formatter::format(&buff, fmt, ap)) >= 0) {
        _next_free = buff.curpos;
    }
    return n;
}


};

