/**
 *  @file    cceByteStream.cpp
 *  @brief   This file is a part of cocos2dx-extra
 *
 *  @author  Master.G, mg@whatstool.com
 *
 *  @internal
 *  Created:  2014/08/12
 *  Company:  whatstool
 *  (C) Copyright 2014 whatstool All rights reserved.
 *
 * The copyright to the contents herein is the property of whatstool
 * The contents may be used and/or copied only with the written permission of
 * whatstool or in accordance with the terms and conditions stipulated in
 * the agreement/contract under which the contents have been supplied.
 * =====================================================================================
 */

#include "cceByteStream.h"
#include "cceBitwise.h"

#define BS_DEFAULT      0
#define BS_INCOMING     1
#define BS_OUTGOING     2

CCE_NS_BEGIN

void ByteStream_Open(bytestream_t *stream, void *buffer, size_t length)
{
    stream->stream = (uint8_t *)buffer;
    stream->length = length;
    stream->pos = 0;
    stream->mode = BS_DEFAULT;
}

void ByteStream_OpenIncoming(bytestream_t *stream, void *buffer, size_t length)
{
    ByteStream_Open(stream, buffer, length);
    stream->mode = BS_INCOMING;
}

void ByteStream_OpenOutgoing(bytestream_t *stream, void *buffer, size_t length)
{
    ByteStream_Open(stream, buffer, length);
    stream->mode = BS_OUTGOING;
}

/* ************************************************************
 * read / write
 * ************************************************************/

void ByteStream_Skip(bytestream_t *stream, size_t size)
{
    if (stream->pos + size > stream->length)
        stream->pos = stream->length;
    else
        stream->pos += size;
}

void ByteStream_SetPosition(bytestream_t *stream, size_t pos)
{
    if (pos > stream->length)
        return;
    else
        stream->pos = pos;
}

size_t ByteStream_ReadRaw(bytestream_t *stream, void *dst, size_t size)
{
    if (stream->pos + size > stream->length)
        return 0;
    
    memcpy(dst, &stream->stream[stream->pos], size);
    stream->pos += size;
    
    return size;
}

size_t ByteStream_WriteRaw(bytestream_t *stream, const void *src, size_t size)
{
    if (stream->pos + size > stream->length)
        return 0;
    
    memcpy(&stream->stream[stream->pos], src, size);
    stream->pos += size;
    
    return size;
}

unsigned char ByteStream_ReadByte(bytestream_t *stream, int *result)
{
    unsigned char ret = 0;
    if (stream->pos + 1 > stream->length)
    {
        if (result != NULL)
            *result = 0;
        
        return ret;
    }
    
    ret = *(unsigned char *)&stream->stream[stream->pos];
    stream->pos++;
    
    return ret;
}

int ByteStream_WriteByte(bytestream_t *stream, const unsigned char data)
{
    if (stream->pos + 1 > stream->length)
    {
        return 0;
    }
    
    *(unsigned char *)&stream->stream[stream->pos] = data;
    
    return 1;
}

char ByteStream_ReadChar(bytestream_t *stream, int *result)
{
    char ret = 0;
    if (stream->pos + 1 > stream->length)
    {
        if (result != NULL)
            *result = 0;
        
        return ret;
    }
    
    ret = *(char *)&stream->stream[stream->pos];
    stream->pos++;
    
    return ret;
}

int ByteStream_WriteChar(bytestream_t *stream, const char data)
{
    if (stream->pos + 1 > stream->length)
    {
        return 0;
    }
    
    *(char *)&stream->stream[stream->pos] = data;
    
    return 1;
}

int16_t ByteStream_ReadInt16(bytestream_t *stream, int *result)
{
    int16_t ret = 0;
    int sizetoread = sizeof(int16_t);
    if (stream->pos + sizetoread > stream->length)
    {
        if (result != NULL)
            *result = 0;
        
        return ret;
    }
    
    ret = *(int16_t *)&stream->stream[stream->pos];
    stream->pos += sizetoread;
    
    if (stream->mode == BS_INCOMING)
        ret = BWSwapInt16BigToHost(ret);
    
    return ret;
}

int ByteStream_WriteInt16(bytestream_t *stream, const int16_t data)
{
    int16_t actualData = data;
    int sizetowrite = sizeof(int16_t);
    if (stream->pos + sizetowrite > stream->length)
    {
        return 0;
    }
    
    if (stream->mode == BS_OUTGOING)
        actualData = BWSwapInt16HostToBig(data);
    
    *(int16_t *)&stream->stream[stream->pos] = actualData;
    stream->pos += sizetowrite;
    
    return sizetowrite;
}

uint16_t ByteStream_ReadUInt16(bytestream_t *stream, int *result)
{
    uint16_t ret = 0;
    int sizetoread = sizeof(uint16_t);
    if (stream->pos + sizetoread > stream->length)
    {
        if (result != NULL)
            *result = 0;
        
        return ret;
    }
    
    ret = *(uint16_t *)&stream->stream[stream->pos];
    stream->pos += sizetoread;
    
    if (stream->mode == BS_INCOMING)
        ret = BWSwapInt16BigToHost(ret);
    
    return ret;
}

int ByteStream_WriteUInt16(bytestream_t *stream, const uint16_t data)
{
    uint16_t actualData = data;
    int sizetowrite = sizeof(uint16_t);
    if (stream->pos + sizetowrite > stream->length)
    {
        return 0;
    }
    
    if (stream->mode == BS_OUTGOING)
        actualData = BWSwapInt16HostToBig(data);
    
    *(uint16_t *)&stream->stream[stream->pos] = actualData;
    stream->pos += sizetowrite;
    
    return sizetowrite;
}

int32_t ByteStream_ReadInt32(bytestream_t *stream, int *result)
{
    int32_t ret = 0;
    int sizetoread = sizeof(int32_t);
    if (stream->pos + sizetoread > stream->length)
    {
        if (result != NULL)
            *result = 0;
        
        return ret;
    }
    
    ret = *(int32_t *)&stream->stream[stream->pos];
    stream->pos += sizetoread;
    
    if (stream->mode == BS_INCOMING)
        ret = BWSwapInt32BigToHost(ret);
    
    return ret;
}

int ByteStream_WriteInt32(bytestream_t *stream, const int32_t data)
{
    int32_t actualData = data;
    int sizetowrite = sizeof(int32_t);
    if (stream->pos + sizetowrite > stream->length)
    {
        return 0;
    }
    
    if (stream->mode == BS_OUTGOING)
        actualData = BWSwapInt32HostToBig(data);
    
    *(int32_t *)&stream->stream[stream->pos] = actualData;
    stream->pos += sizetowrite;
    
    return sizetowrite;
}

uint32_t ByteStream_ReadUInt32(bytestream_t *stream, int *result)
{
    uint32_t ret = 0;
    int sizetoread = sizeof(uint32_t);
    if (stream->pos + sizetoread > stream->length)
    {
        if (result != NULL)
            *result = 0;
        
        return ret;
    }
    
    ret = *(uint32_t *)&stream->stream[stream->pos];
    stream->pos += sizetoread;
    
    if (stream->mode == BS_INCOMING)
        ret = BWSwapInt32BigToHost(ret);
    
    return ret;
}

int ByteStream_WriteUInt32(bytestream_t *stream, const uint32_t data)
{
    uint32_t actualData = data;
    int sizetowrite = sizeof(uint32_t);
    if (stream->pos + sizetowrite > stream->length)
    {
        return 0;
    }
    
    if (stream->mode == BS_OUTGOING)
        actualData = BWSwapInt32HostToBig(data);
    
    *(uint32_t *)&stream->stream[stream->pos] = actualData;
    stream->pos += sizetowrite;
    
    return sizetowrite;
}

int64_t ByteStream_ReadInt64(bytestream_t *stream, int *result)
{
    int64_t ret = 0;
    int sizetoread = sizeof(int64_t);
    if (stream->pos + sizetoread > stream->length)
    {
        if (result != NULL)
            *result = 0;
        
        return ret;
    }
    
    ret = *(int64_t *)&stream->stream[stream->pos];
    stream->pos += sizetoread;
    
    if (stream->mode == BS_INCOMING)
        ret = BWSwapInt64BigToHost(ret);
    
    return ret;
}

int ByteStream_WriteInt64(bytestream_t *stream, const int64_t data)
{
    int64_t actualData = data;
    int sizetowrite = sizeof(int64_t);
    if (stream->pos + sizetowrite > stream->length)
    {
        return 0;
    }
    
    if (stream->mode == BS_OUTGOING)
        actualData = BWSwapInt64HostToBig(data);
    
    *(int64_t *)&stream->stream[stream->pos] = actualData;
    stream->pos += sizetowrite;
    
    return sizetowrite;
}

uint64_t ByteStream_ReadUInt64(bytestream_t *stream, int *result)
{
    uint64_t ret = 0;
    int sizetoread = sizeof(uint64_t);
    if (stream->pos + sizetoread > stream->length)
    {
        if (result != NULL)
            *result = 0;
        
        return ret;
    }
    
    ret = *(uint64_t *)&stream->stream[stream->pos];
    stream->pos += sizetoread;
    
    if (stream->mode == BS_INCOMING)
        ret = BWSwapInt64BigToHost(ret);
    
    return ret;
}

int ByteStream_WriteUInt64(bytestream_t *stream, const uint64_t data)
{
    uint64_t actualData = data;
    int sizetowrite = sizeof(uint64_t);
    if (stream->pos + sizetowrite > stream->length)
    {
        return 0;
    }
    
    if (stream->mode == BS_OUTGOING)
        actualData = BWSwapInt64HostToBig(data);
    
    *(uint64_t *)&stream->stream[stream->pos] = actualData;
    stream->pos += sizetowrite;
    
    return sizetowrite;
}


CCE_NS_END