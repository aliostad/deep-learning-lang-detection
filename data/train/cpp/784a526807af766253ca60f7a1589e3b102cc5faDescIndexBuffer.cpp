#include "DescIndexBuffer.h"

//Serialization
void DescIndexBuffer::Serialize(Stream & stream) const
{
	stream.Save(Usage);
	stream.Save(ByteCount);
	stream.Save(PrimitiveType);
	unsigned int init = 0;
	stream.Save(init);
}
void DescIndexBuffer::Unserialize(Stream & stream)
{
	stream.Load(Usage);
	stream.Load(ByteCount);
	stream.Load(PrimitiveType);
	unsigned int init = 0;
	stream.Load(init);
	InitialData = (void *) init;
}
void DescIndexBuffer::SerializeTypeId(Stream & stream) const
{
	stream.Save("DescIndexBuffer");
}