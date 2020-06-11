/*
 * Buffer.cpp
 *
 *  Created on: 03/10/2010
 *      Author: Nacho
 */

#include "Buffer.h"
#include <cstring>

	Buffer::Buffer(){
		this->stream = NULL;
		this->longitudStream = 0;
	}

	Buffer::Buffer (char* stream, int longitudStream)
	{
		this->stream = NULL;
		this->longitudStream = 0;
		this->setStream(stream, longitudStream);
	}

	Buffer::~Buffer(){
		if (this->stream != NULL) delete []this->stream;
		this->stream = NULL;
		this->longitudStream = 0;
	}

	char* Buffer::getStream (int &longitudStream){
		longitudStream = this->longitudStream;
		return (this->clonarStream(this->stream, this->longitudStream));
	}

	void Buffer::setStream (char* stream, int longitudStream)
	{
		if ((stream != NULL) && (longitudStream > 0))
		{
			if (this->stream != NULL)
				delete[](this->stream);
			this->stream = this->clonarStream(stream, longitudStream);
			this->longitudStream = longitudStream;
		}
	}

/***********************************************************
 * Metodos privados de la clase
 **********************************************************/

	char* Buffer::clonarStream (char* stream, int longitudStream){
		char* streamClonado = new char[longitudStream];
		memcpy (streamClonado, stream, longitudStream);
		return streamClonado;
	}
