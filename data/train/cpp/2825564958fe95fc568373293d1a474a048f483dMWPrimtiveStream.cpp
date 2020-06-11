#include "MWPrimtiveStream.h"

using namespace Myway;

VertexStream::VertexStream()
{
    Memzero(mInstances, sizeof(int) * MAX_VERTEX_STREAM);

	mStart = 0;
	mCount = 0;
}

VertexStream::~VertexStream()
{
}

void VertexStream::SetDeclaration(VertexDeclarationPtr decl)
{
    mDeclaration = decl;
}

VertexDeclarationPtr VertexStream::GetDeclaration() const
{
    return mDeclaration;
}

void VertexStream::Bind(int number, VertexBufferPtr stream, int unused, int instance)
{
    assert (number < MAX_VERTEX_STREAM);

    mStreams[number] = stream;
	mInstances[number] = instance;
}

VertexBufferPtr VertexStream::GetStream(int index) const
{
    return mStreams[index];
}

int VertexStream::GetStreamInstance(int index) const
{
	return mInstances[index];
}

void VertexStream::SetCount(int size)
{
    mCount = size;
}

int VertexStream::GetCount() const
{
    return mCount;
}

VertexStream::VertexStream(const VertexStream & r)
{
    *this = r;
}

VertexStream & VertexStream::operator =(const VertexStream & r)
{
	mStart = r.GetStart();
    mCount = r.GetCount();
    mDeclaration = r.GetDeclaration();

    for (int i = 0; i < MAX_VERTEX_STREAM; ++i)
    {
        mStreams[i] = r.GetStream(i);
    }

    return *this;
}









IndexStream::IndexStream()
: mCount(0)
, mStart(0)
{
}

IndexStream::~IndexStream()
{
}

void IndexStream::Bind(IndexBufferPtr stream, int start)
{
    mStream = stream;
	mStart = start;
}

IndexBufferPtr IndexStream::GetStream() const
{
    return mStream;
}

void IndexStream::SetCount(int size)
{
    mCount = size;
}

int IndexStream::GetCount() const
{
    return mCount;
}

IndexStream::IndexStream(const IndexStream & r)
{
    *this = r;
}

IndexStream & IndexStream::operator =(const IndexStream & r)
{
    assert (this != &r);

    mStream = r.GetStream();
	mCount = r.GetCount();
	mStart = r.GetStart();

    return *this;
}