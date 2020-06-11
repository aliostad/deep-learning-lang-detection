typedef struct _stream_t stream_t;

typedef struct  
{
#ifdef _WIN32
	uint32 (__fastcall *readData)(void *object, void *buffer, uint32 len);
	uint32 (__fastcall *writeData)(void *object, void *buffer, uint32 len);
	uint32 (__fastcall *getSize)(void *object);
	void (__fastcall *setSize)(void *object, uint32 size);
	uint32 (__fastcall *getSeek)(void *object);
	void (__fastcall *setSeek)(void *object, sint32 seek, bool relative);
	void (__fastcall *initStream)(void *object, stream_t *stream);
	void (__fastcall *destroyStream)(void *object, stream_t *stream);
#else 
//#define gcc_fastcall __attribute__((fastcall))
// wont be used on x64 linux, so using default calling convention for now
  uint32 *readData(void *object, void *buffer, uint32 len);
  uint32 *writeData(void *object, void *buffer, uint32 len);
  uint32 *getSize(void *object);
  void *setSize(void *object, uint32 size);
  uint32 *getSeek(void *object);
  void *setSeek(void *object, sint32 seek, bool relative);
  void *initStream(void *object, stream_t *stream);
  void *destroyStream(void *object, stream_t *stream);
#endif
	// general settings
	bool allowCaching;
}streamSettings_t;

typedef struct _stream_t
{
	void *object;
	//_stream_t *substream;
	streamSettings_t *settings;
	// bit access ( write )
	uint8 bitBuffer[8];
	uint8 bitIndex;
	// bit access ( read )
	uint8 bitReadBuffer[8];
	uint8 bitReadBufferState;
	uint8 bitReadIndex;
}stream_t;


stream_t*	stream_create	(streamSettings_t *settings, void *object);
void		stream_destroy	(stream_t *stream);

// stream reading

char stream_readS8(stream_t *stream);
short stream_readS16(stream_t *stream);
int stream_readS32(stream_t *stream);
uint8 stream_readU8(stream_t *stream);
uint16 stream_readU16(stream_t *stream);
uint32 stream_readU32(stream_t *stream);
unsigned long long stream_readU64(stream_t *stream);
float stream_readFloat(stream_t *stream);
uint32 stream_readData(stream_t *stream, void *data, int len);
// stream writing
void stream_writeS8(stream_t *stream, char value);
void stream_writeS16(stream_t *stream, short value);
void stream_writeS32(stream_t *stream, int value);
void stream_writeU8(stream_t *stream, uint8 value);
void stream_writeU16(stream_t *stream, uint16 value);
void stream_writeU32(stream_t *stream, uint32 value);
void stream_writeFloat(stream_t *stream, float value);
uint32 stream_writeData(stream_t *stream, void *data, int len);
// stream other
void stream_setSeek(stream_t *stream, uint32 seek);
uint32 stream_getSeek(stream_t *stream);
uint32 stream_getSize(stream_t *stream);
void stream_setSize(stream_t *stream, uint32 size);
void stream_skipData(stream_t *stream, int len);
uint32 stream_copy(stream_t* dest, stream_t* source, uint32 length);

// bit operations
void stream_writeBits(stream_t* stream, uint8* bitData, uint32 bitCount);
void stream_readBits(stream_t* stream, uint8* bitData, uint32 bitCount);



/* stream ex */

stream_t* streamEx_fromMemoryRange(void *mem, uint32 memoryLimit);
stream_t* streamEx_fromDynamicMemoryRange(uint32 memoryLimit);
stream_t* streamEx_createSubstream(stream_t* mainstream, sint32 startOffset, sint32 size);

// misc
void* streamEx_map(stream_t* stream, sint32* size);
sint32 streamEx_readStringNT(stream_t* stream, char* str, uint32 strSize);