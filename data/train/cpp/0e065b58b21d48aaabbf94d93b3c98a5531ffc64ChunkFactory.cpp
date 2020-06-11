/* 
 * File:   ChunkFactory.cpp
 * Author: paul
 * 
 * Created on February 11, 2012, 6:43 PM
 */

#include "ChunkFactory.h"

namespace PrimeFinder
{

    ChunkFactory::ChunkFactory(): 
        chunks(std::list<Chunk *>()),
        nextOffset(START_CHUNK_OFFSET),
        currentChunk(chunks.begin()),
        maxPrimeNum(0)
    {
        
    }

    ChunkFactory::ChunkFactory(const ChunkFactory& orig) 
    {
        
    }

    ChunkFactory::~ChunkFactory() 
    {
        
    }
    
    void ChunkFactory::allocate()
    {
        this->chunks.push_back(new Chunk(this->nextOffset, this->maxPrimeNum));
        
        this->nextOffset += CHUNK_SIZE;
        
        this->currentChunk = chunks.begin();

        this->currentCheckChunk = chunks.begin();
                
    }
    
    long ChunkFactory::getMaxPrimeNum()
    {
        return maxPrimeNum;
    }
        
    long ChunkFactory::reset()
    {
        this->currentChunk = chunks.begin();
        
        for ( std::list<Chunk *>::iterator iter = chunks.begin(); iter != chunks.end(); ++iter )
        {
            (*iter)->reset();
        }
        
        return (*this->currentChunk)->reset();
        
    }
        
    long ChunkFactory::next()
    {
        std::list<Chunk *>::iterator chunk = this->currentChunk;
       
        if ( (*chunk)->hasNext() )
        {
            return (*chunk)->next();
        }
        else
        {
            return (*(++this->currentChunk))->reset();
        }
        
    }
        
    bool ChunkFactory::check(long i)
    {
    	if (   (*this->currentCheckChunk)->checkBound(i) )
    	{
    		return (*this->currentCheckChunk)->check(i);
    	}
    	else
    	{
    		for ( std::list<Chunk *>::iterator iter = chunks.begin(); iter != chunks.end(); ++iter )
    		{
    			if ( (*iter)->checkBound(i) )
    			{
    				this->currentCheckChunk = iter;

    				return (*iter)->check(i);
    			}
    		}
    	}

    }
        
    void ChunkFactory::setUnprime(long i)
    {
        (*this->currentCheckChunk)->setUnprime(i);
    }
    
    long ChunkFactory::allocatedMax()
    {
        return nextOffset;
    }
    
    void ChunkFactory::setMaxPrimeNum()
    {
    	std::list<Chunk *>::reverse_iterator chunk = chunks.rbegin();

        
        this->maxPrimeNum = (*chunk)->getMaxPrimeNum();
    }
    
    long ChunkFactory::find_cached(unsigned int num)
    {
        long pos = num - 2;
        
        long prime = this->reset();

        while ( pos != 0)
        {
            prime = this->next();
            
            --pos;
        }
        
        return prime;
    }
    
}

