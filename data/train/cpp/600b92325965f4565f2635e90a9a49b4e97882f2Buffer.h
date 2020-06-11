/*
 * Buffer.h
 *
 *  Created on: 03/10/2010
 *      Author: Nacho
 */

#ifndef BUFFER__H__
#define BUFFER__H__

class Buffer {
private:
	char* stream;
	int longitudStream;

public:
	Buffer();

	Buffer (char* stream, int longitudStream);

	virtual ~Buffer();

	char* getStream (int &longitudStream);

	void setStream (char* stream, int longitudStream);

/***********************************************************
 * Metodos privados de la clase
 **********************************************************/

private:
	char* clonarStream (char* stream, int longitudStream);
};

#endif /* BUFFER__H__ */
