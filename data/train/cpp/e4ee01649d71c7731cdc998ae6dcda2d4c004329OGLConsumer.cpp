/*
 * OGLConsumer.cpp
 *
 *  Created on: Feb 21, 2013
 *      Author: Andrew Zhabura
 */

#include <exception>

#include "OGLConsumer.h"

#include "Sample_01.h"
#include "Sample_02.h"
#include "Sample_03.h"
#include "Sample_04.h"
#include "Sample_05.h"
#include "Sample_06.h"
#include "Sample_07.h"
#include "Sample_08.h"
#include "Sample_09.h"
#include "Sample_10.h"
#include "Sample_11.h"
#include "Sample_12.h"
#include "Sample_13.h"
#include "Sample_14.h"

#include "Sample_16.h"
#include "Sample_17.h"
#include "Sample_18.h"
#include "Sample_19.h"
#include "Sample_20.h"
#include "Sample_21.h"
#include "Sample_22.h"
#include "Sample_23.h"
#include "Sample_24.h"
#include "Sample_25.h"

#define Sample_QTY 25

OGL_Consumer::OGL_Consumer()
:	m_Sample(new Sample * [Sample_QTY])
,	m_SampleNum(0)
,	m_init(true)
{
	int i = -1;

	m_Sample[++i] = new Sample_01;
	m_Sample[++i] = new Sample_02;
	m_Sample[++i] = new Sample_03;
	m_Sample[++i] = new Sample_04;
	m_Sample[++i] = new Sample_05;
	m_Sample[++i] = new Sample_06;
	m_Sample[++i] = new Sample_07;
	m_Sample[++i] = new Sample_08;
	m_Sample[++i] = new Sample_09;
	m_Sample[++i] = new Sample_10;
	m_Sample[++i] = new Sample_11;
	m_Sample[++i] = new Sample_12;
	m_Sample[++i] = new Sample_13;
	m_Sample[++i] = new Sample_14;

	m_Sample[++i] = new Sample_14;

	m_Sample[++i] = new Sample_16;
	m_Sample[++i] = new Sample_17;
	m_Sample[++i] = new Sample_18;
	m_Sample[++i] = new Sample_19;
	m_Sample[++i] = new Sample_20;
	m_Sample[++i] = new Sample_21;
	m_Sample[++i] = new Sample_22;
	m_Sample[++i] = new Sample_23;
	m_Sample[++i] = new Sample_24;
	m_Sample[++i] = new Sample_25;

	if ( ++i != Sample_QTY )
		throw this;
}

OGL_Consumer::~OGL_Consumer()
{
	for (int i = 0; i < Sample_QTY; ++i)
	{
		if (m_Sample[i])
			delete m_Sample[i];
	}
}

bool OGL_Consumer::setSample(unsigned int SampleNum)
{
	if (SampleNum >= Sample_QTY)
		return false;

	if (m_SampleNum == SampleNum)
		return true;

	if (!m_init)
	{
		m_Sample[m_SampleNum]->restoreGL();
		m_init = true;
	}
	m_SampleNum = SampleNum;

	return true;
}

bool OGL_Consumer::sendMessage(unsigned int SampleNum, int message, int mode, int x, int y)
{
	return m_Sample[m_SampleNum]->sendMessage(message, mode, x, y);
}

void OGL_Consumer::sendIdleMessage()
{
	m_Sample[m_SampleNum]->sendIdleMessage();
}

void OGL_Consumer::reshape(unsigned int width, unsigned int height)
{
	m_Sample[m_SampleNum]->reshape(width, height);
}

// Here goes our drawing code
void OGL_Consumer::drawGLScene()
{
	if (m_init)
	{
		m_Sample[m_SampleNum]->initGL();
		m_init = false;
	}
	m_Sample[m_SampleNum]->draw();
}

const char* OGL_Consumer::sampleName() const
{
	return m_Sample[m_SampleNum]->name();
}

int OGL_Consumer::width() const
{
	return m_Sample[m_SampleNum]->width();
}

int OGL_Consumer::height() const
{
	return m_Sample[m_SampleNum]->height();
}
