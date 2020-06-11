#ifndef IO_DATABUFFER_H_
#define IO_DATABUFFER_H_

#include "../common/common.h"
#include "../chunkpool/chunkpool.h"
#include "../fallocator/fallocator.h"

typedef void* dataStream_t;
typedef void* dataStreamIterator_t;

/* data buffer API */
void*                dataStreamBufferAllocate(chunkpool_t chunkpool, fallocator_t fallocator,  u_int32_t size);
void                 dataStreamBufferFree(void* buffer);
void                 dataStreamBufferPrint(void* buffer);

/* data stream API */
dataStream_t         dataStreamCreate(void);
void                 dataStreamDelete(dataStream_t dataStream);
u_int32_t            dataStreamGetSize(dataStream_t dataStream);
u_int32_t            dataStreamTotalSize(dataStream_t dataStream);
int                  dataStreamAppendData(dataStream_t dataStream, void* buffer, u_int32_t offset, u_int32_t length);
int                  dataStreamAppendDataStream(dataStream_t dataStream, dataStream_t toAppend);
int                  dataStreamFindEndOfLine(dataStream_t dataStream);

int                  dataStreamTruncateFromStart(dataStream_t dataStream, u_int32_t finalSize);
int                  dataStreamTruncateFromEnd(dataStream_t dataStream, u_int32_t finalSize);
void                 dataStreamPrint(dataStream_t dataStream);
dataStream_t         dataStreamSubStream(fallocator_t fallocator, dataStream_t dataStream, u_int32_t offset, u_int32_t length);
char*                dataStreamToString(dataStream_t dataStream);



/* data stream iterator API */

dataStreamIterator_t dataStreamIteratorCreate(fallocator_t fallocator, dataStream_t dataStream, u_int32_t offset, u_int32_t length);
void                 dataStreamIteratorDelete(fallocator_t fallocator, dataStreamIterator_t iterator);
u_int32_t            dataStreamIteratorGetSize(dataStreamIterator_t iterator);
u_int32_t            dataStreamIteratorGetBufferCount(dataStreamIterator_t iterator);
void*                dataStreamIteratorGetBufferAtIndex(dataStreamIterator_t iterator, u_int32_t index, u_int32_t* offset, u_int32_t* length);
char*                dataStreamIteratorGetString(fallocator_t fallocator, dataStreamIterator_t iterator, u_int32_t offset, u_int32_t length);


/* data stream clone API */
dataStream_t         dataStreamClone(chunkpool_t chunkpool, dataStream_t dataStream);

#endif /* IO_DATABUFFER_H_ */
