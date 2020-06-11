#ifndef FACTORY_H
#define FACTORY_H

#include <AbstractStream.h>
#include <CompressedStream.h>
#include <ASCII7Stream.h>

class DecoratorFactory
{
public:
	virtual	AbstractStream*	factoryMethod( AbstractStream& stream ) = 0;
};

class CompressedStreamFactory : public DecoratorFactory
{
public:
	virtual	AbstractStream*	factoryMethod( AbstractStream& stream )
	{
		return new CompressedStream( stream );
	}
};

class ASCII7StreamFactory : public DecoratorFactory
{
public:
	virtual	AbstractStream*	factoryMethod( AbstractStream& stream )
	{
		return new ASCII7Stream( stream );
	}
};

#endif FACTORY_H