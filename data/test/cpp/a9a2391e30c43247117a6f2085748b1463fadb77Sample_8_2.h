/*
 * Sample_8_2.h
 *
 *  Created on: Dec 6, 2012
 *      Author: Andrew Zhabura
 */

#ifndef Sample_8_2_H_
#define Sample_8_2_H_

#include "Sample.h"

class Sample_8_2 : public Sample
{
public:
	Sample_8_2();
	virtual ~Sample_8_2();

	virtual void reshape(int width, int height);
	virtual char* getName()
	{
		return (char*)&"8-2. Font";
	}

protected:
	void draw();
	void initGL();
	void restoreGL();

private:
	GLuint m_fontOffset;

	void makeRasterFont();
	void printString(char *s);
};

#endif /* Sample_8_2_H_ */
