#include "vl_mempool.h"

#include <stdlib.h>
#include <new>

DECLARE_HB_NAMESPACE(common)

vl_mempool::vl_mempool(int64_t chunk_size, int64_t chunk_num)
: _chunks_list(NULL), _current_chunk(NULL), _chunk_size(chunk_size),
  _chunk_num(chunk_num), _used_chunk_num(0), _init(false)
{
    if(_chunk_size <= 0)
    {
        _chunk_size = DEFAULT_CHUNK_SIZE; // 8M
    }
    if (_chunk_num <= 0)
    {
        _chunk_num = 0;
    }
}

vl_mempool::~vl_mempool()
{
    _destroy();
}

bool vl_mempool::init(void)
{
    bool retval = false;
    chunk_t* chunk_tmp = NULL;
    int64_t i = 0;
    if (!_init)
    {
        if (_chunk_num > 0)
        {
            _chunks_list = (chunk_t*)_alloc_chunk();
            if (NULL != _chunks_list)
            {
                _current_chunk = _chunks_list;
                for(i = 0; i < _chunk_num -1; i++)
                {
                    chunk_tmp = (chunk_t*)_alloc_chunk();
                    if (NULL == chunk_tmp)
                    {
                        break;
                    }
                    _current_chunk->_next = chunk_tmp;
                    _current_chunk = chunk_tmp;
                }// end for loop
                if(i == _chunk_num - 1)
                {
                    retval = true;
                }
            }// end if (NULL != _chunks_list)
        }
        else
        {
            _chunks_list = NULL;
            retval = true;
        }
        _init = retval;

        if(_init)
        {
            _current_chunk = _chunks_list;
        }
        else
        {
            _destroy();
        }
    }
    return _init;
}

void* vl_mempool::_alloc_chunk(void)
{
    chunk_t* chunk_tmp = NULL;
    chunk_tmp = (chunk_t*)malloc(sizeof(chunk_t));
    if (NULL != chunk_tmp)
    {
        chunk_tmp->_next = 0;
        chunk_tmp->_alloc_pos = 0;
        chunk_tmp->_data = malloc((size_t)_chunk_size);
        if (NULL == chunk_tmp->_data)
        {
            free(chunk_tmp);
            chunk_tmp = NULL;
        }
    }
    return chunk_tmp;
}

void vl_mempool::_reset_chunk(chunk_t* chunk, int64_t valid_pos)
{
    chunk_t* next_chunk = chunk;
    if(valid_pos < 0 || valid_pos > _chunk_size)
    {
        valid_pos = 0;
    }
    if (NULL != next_chunk)
    {
        next_chunk->_alloc_pos = valid_pos;
        while(NULL != (next_chunk = next_chunk->_next))
        {
            next_chunk->_alloc_pos = 0;
        }
    }
}

void vl_mempool::_destroy(void)
{
    chunk_t* chunk_tmp = NULL;
    while (NULL != _chunks_list)
    {
        chunk_tmp = _chunks_list;
        _chunks_list = _chunks_list->_next;
        if (NULL != chunk_tmp)
        {
            if(NULL != chunk_tmp->_data)
            {
                free(chunk_tmp->_data);
                chunk_tmp->_data = NULL;
            }
            free(chunk_tmp);
            chunk_tmp = NULL;
        }
    }
    _current_chunk = NULL;
    _chunk_num = 0;
    _used_chunk_num = 0;
}

int vl_mempool::reset(void)
{
    int retval = -1;
    if (_init)
    {
        _reset_chunk(_chunks_list);
        _current_chunk = _chunks_list;
        _used_chunk_num = 0;
        retval = 0;
    }
    return retval;
}

int vl_mempool::recycle(void)
{
    int retval = -1;
    if (_init)
    {
        _destroy();
        retval = 0;
    }
    return retval;
}

END_DECLARE_HB_NAMESPACE(common)
