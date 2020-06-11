#include "includes/JsonStreamWriter.h"

namespace alib
{
	/* Private Functions */
	void JsonStreamWriter::writeObjectHeader(const char* name)
	{
		if (_itemWritten)
			writeSeperator();
		_stream.write("\""); _stream.write(name); _stream.write("\"");
		_stream.write(":");
	}
	void JsonStreamWriter::writeSeperator() { _stream.write(','); }
	/*********************/

	/* Public Functions */
		/* Constructors */
	JsonStreamWriter::JsonStreamWriter(Stream& stream) :_stream(stream) {}
		/****************/

		/* Functions */
	void JsonStreamWriter::begin()
	{
		_stream.write("{");
		_itemWritten = false;
	}
	void JsonStreamWriter::end() { _stream.write("}"); }

	void JsonStreamWriter::writeObject(const char* name, const char* value)
	{
		if (!name)return;
		writeObjectHeader(name);

		_stream.write("\"");
		if (value)
			_stream.write(value);
		_stream.write("\"");

		_itemWritten = true;
	}
	void JsonStreamWriter::writeObject(const char* name, int value)
	{
		if (!name)return;
		writeObjectHeader(name);

		_stream.write("\"");
		_stream.write(value);
		_stream.write("\"");

		_itemWritten = true;
	}
	void JsonStreamWriter::writeObject(const char* name, bool value)
	{
		if (!name)return;
		writeObjectHeader(name);

		_stream.write("\"");
		_stream.write(value);
		_stream.write("\"");

		_itemWritten = true;
	}
		/*************/
	/********************/
}
