#include "stdafx.h"
#include "Player.h"

Uint8* CPlayer::m_Stream = NULL;
unsigned long CPlayer::m_StreamLen = 0;


CPlayer::CPlayer()
{
	m_Stream = NULL;
}


CPlayer::CPlayer(const CPlayer& obj)
{
	*this = obj;
}


CPlayer::~CPlayer()
{
	cleanStream();
}

CPlayer& CPlayer::operator=(const CPlayer& obj)
{
	if (this == &obj)
		return *this;

	cleanStream();
	m_StreamLen = obj.m_StreamLen;

	m_Stream = new Uint8[m_StreamLen];
	if (memcpy_s(m_Stream, m_StreamLen, obj.m_Stream, m_StreamLen)) {
		cleanStream();
	}

	return *this;
}

// Set stream which should be played
void CPlayer::setStream(const Uint8 *stream, const unsigned streamLen)
{
	cleanStream();

	m_StreamLen = streamLen;
	m_Stream = new Uint8 [m_StreamLen];

	if (memcpy_s(m_Stream, m_StreamLen, stream, m_StreamLen)) {
		cleanStream();
	}
}

// additional method cleans audio stream data and set length 0
void CPlayer::cleanStream()
{
	if (m_Stream != NULL) {
		delete [] m_Stream;
		m_Stream = NULL;
		m_StreamLen = 0;
	}
}