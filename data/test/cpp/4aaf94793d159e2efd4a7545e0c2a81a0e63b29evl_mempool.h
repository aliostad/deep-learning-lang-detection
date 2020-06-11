#ifndef _HYPERBIRDER_COMMON_VL_MEM_POOL_H_
#define _HYPERBIRDER_COMMON_VL_MEM_POOL_H_

#include <new>

#include "comm_def.h"

DECLARE_HB_NAMESPACE(common)

const int64_t DEFAULT_CHUNK_SIZE = 8l * 1024l * 1024l;
const int64_t DEFAULT_CHUNK_NUM = 1;

class vl_mempool
{
public:
    vl_mempool(int64_t chunk_size = DEFAULT_CHUNK_SIZE, int64_t chunk_num = DEFAULT_CHUNK_NUM);

    virtual ~vl_mempool();

    bool init(void);

    void* alloc(int64_t item_size);

    int recycle(void);

    virtual int reset(void);

    inline int64_t get_memory(void) const
    {
        int64_t retval = 0;
        if(_init)
        {
            retval = _chunk_size * _chunk_num;
        }
        return retval;
    };

    inline int64_t get_used_memory(void) const
    {
        int64_t retval = 0;
        if (_init)
        {
            retval = _chunk_size * _used_chunk_num;
            if (NULL != _current_chunk)
            {
                retval += _current_chunk->_alloc_pos;
            }
        }
        return retval;
    }

protected:
    typedef struct _chunk_t
    {
        void* _data;
        int64_t _alloc_pos;
        _chunk_t* _next;
    } chunk_t;

    chunk_t* _chunks_list;
    chunk_t* _current_chunk;
    int64_t _chunk_size;
    int64_t _chunk_num;
    int64_t _used_chunk_num;
    bool _init;

protected:
    void _destroy(void);
    void* _alloc_chunk(void);
    void _reset_chunk(chunk_t*, int64_t valid_pos = 0);
};

inline void* vl_mempool::alloc(int64_t item_size)
{
    void* ret = NULL;
    chunk_t* add_chunk = NULL;
    if (item_size <= 0 || item_size > _chunk_size)
    {
        ret = NULL;
    }
    else if (!_init)
    {
        ret = NULL;
    }
    else
    {
        if (NULL == _chunks_list && NULL ==_current_chunk)
        {
            _chunks_list = (chunk_t*)_alloc_chunk();
            _chunk_num++;
            _current_chunk = _chunks_list;
        }
        if (NULL != _current_chunk)
        {
            if (_current_chunk->_alloc_pos + item_size > _chunk_size)
            {
                if (NULL == _current_chunk->_next)
                {
                    add_chunk = (chunk_t*)_alloc_chunk();
                    if (NULL != add_chunk)
                    {
                        _current_chunk->_next = add_chunk;
                        _chunk_num++;
                    }
                }
                _current_chunk = _current_chunk->_next;
                if (NULL != _current_chunk)
                {
                    _used_chunk_num++;
                    ret = _current_chunk->_data;
                    _current_chunk->_alloc_pos = item_size;
                }
            }
            else
            {
                ret = (char*)_current_chunk->_data + _current_chunk->_alloc_pos;
                _current_chunk->_alloc_pos += item_size;
            }
        }
    }
    return ret;
}

END_DECLARE_HB_NAMESPACE(common)

#endif
