#pragma once

#include "types.h"
#include "FileStream.h"

namespace FileSystem
{
	class StreamReader
	{
	public:

		StreamReader(String fileName);

		StreamReader(FileStream *stream);

		virtual ~StreamReader() { }

		void Close();

		String ReadLine();

		u8 ReadChar();

		List<String> ReadToEnd();

	private:

		FileStream *fileStream;
	};

	//-------------------------------------------------------------------------------------------------
	inline StreamReader::StreamReader(String fileName)
	{
		fileStream = new FileStream();
		fileStream->Open(fileName);
	}

	//-------------------------------------------------------------------------------------------------
	inline StreamReader::StreamReader(FileStream *stream)
	{
		fileStream = stream;
	}

	//-------------------------------------------------------------------------------------------------
	inline void StreamReader::StreamReader::Close()
	{
		fileStream->Close();
	}

	//-------------------------------------------------------------------------------------------------
	inline String StreamReader::ReadLine()
	{
		String line;

		while(!fileStream->EndOfFile)
		{
			char c = ReadChar();

			if (c == '\r')
				continue;
			if (c == '\n')
				break;

			line += c;
		}
		
		return line;
	}

	//-------------------------------------------------------------------------------------------------
	u8 StreamReader::ReadChar()
	{
		if (!fileStream->EndOfFile)
		{
			List<u8> chars = *(fileStream->Read<u8>(1));
			if (chars.empty())
				return 0;
			return chars[0];
		}
		return 0;
	}

	//-------------------------------------------------------------------------------------------------
	List<String> StreamReader::ReadToEnd()
	{
		List<String> lines;

		while(!fileStream->EndOfFile)
		{
			lines.push_back( ReadLine() );
		}

		return lines;
	}

}