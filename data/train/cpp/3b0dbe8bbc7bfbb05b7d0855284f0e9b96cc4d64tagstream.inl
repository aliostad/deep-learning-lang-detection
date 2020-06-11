/*---------------------------------------------------------------------------------------------*//*

	Binary Kinematics 3 - C++ Game Programming Library
	Copyright (C) 2008 Viktor Reutzky
	reutzky@bitchingames.com

*//*---------------------------------------------------------------------------------------------*/

#pragma once

//	
template<typename _Stream> struct _stream_proxy_ : stream {
	inline _stream_proxy_(_Stream &_stream) : m_stream(_stream) {}
	u8 get() { return m_stream.get(); }
private:
	_Stream &m_stream;
};

template<typename _S>
inline tagstream::tagstream(_S &_stream) :
	m_stream(* new _stream_proxy_<_S>(_stream)), m_bit(u8(-1))
{
	m_read_header();
}
