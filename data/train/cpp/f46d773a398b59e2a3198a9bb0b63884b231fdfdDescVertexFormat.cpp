#include "DescVertexFormat.h"

//Serialization
void DescVertexFormatEntry::Serialize(Stream & stream) const
{
	STLSerializer<std::string> string_serializer(stream);
	string_serializer.Save(name);
	stream.Save(semantic_index);
	stream.Save(offset);
	stream.Save(byte_stride);
	stream.Save(stream_index);
	stream.Save(type);
	stream.Save(channels);
}
void DescVertexFormatEntry::Unserialize(Stream & stream)
{
	STLSerializer<std::string> string_serializer(stream);
	string_serializer.Load(name);
	stream.Load(semantic_index);
	stream.Load(offset);
	stream.Load(byte_stride);
	stream.Load(stream_index);
	stream.Load(type);
	stream.Load(channels);
}
void DescVertexFormatEntry::SerializeTypeId(Stream & stream) const
{
	stream.Save("DescVertexFormatEntry");
}

//Serialization
void DescVertexFormat::Serialize(Stream & stream) const
{
	STLSerializer<FixedArray<DescVertexFormatEntry> > entry_serializer(stream);
	entry_serializer.Save(format_entries);
}
void DescVertexFormat::Unserialize(Stream & stream)
{
	STLSerializer<FixedArray<DescVertexFormatEntry> > entry_serializer(stream);
	entry_serializer.Load(format_entries);
}
void DescVertexFormat::SerializeTypeId(Stream & stream) const
{
	stream.Save("DescVertexFormat");
}