/*
 *	FILE:		EngineMath.h
 *	CREATOR:	Craig Jong
 *	PURPOSE:	Includes d3dx9 and stuff.
 */


#pragma once

#include <d3dx9.h>
#include <cmath>
#include "Serialization.h"

typedef D3DXVECTOR2 Vec2D;
typedef D3DXVECTOR3 Vec3D;
typedef D3DXVECTOR4 Vec4D;
typedef D3DXMATRIXA16 Mat2D;

namespace Engine
{
	inline void StreamRead(Serializer& stream, Vec2D& v)
	{
		StreamRead(stream,v.x);
		StreamRead(stream,v.y);
	}

	inline void StreamRead(Serializer& stream, Vec3D& v)
	{
		StreamRead(stream,v.x);
		StreamRead(stream,v.y);
		StreamRead(stream,v.z);
	}

	inline void StreamRead(Serializer& stream, Vec4D& v)
	{
		StreamRead(stream,v.x);
		StreamRead(stream,v.y);
		StreamRead(stream,v.z);
		StreamRead(stream,v.w);
	}

	inline float Dot(const Vec2D& a, const Vec2D& b)
	{
		return a.x * b.x + a.y * b.y;
	}
}