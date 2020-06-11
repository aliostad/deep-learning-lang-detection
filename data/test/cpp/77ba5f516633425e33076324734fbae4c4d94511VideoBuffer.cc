//
// Copyright (C) 2010 DenaCast All Rights Reserved.
// http://www.denacast.com
// The DenaCast was designed and developed at the DML(Digital Media Lab http://dml.ir/)
// under supervision of Dr. Behzad Akbari (http://www.modares.ac.ir/ece/b.akbari)
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Lesser General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Lesser General Public License for more details.
//
// You should have received a copy of the GNU Lesser General Public License
// along with this program.  If not, see http://www.gnu.org/licenses/.
//

/**
 * @file VideoBuffer.cc
 * @author Yasser Seyyedi, Behnam Ahmadifar
 */

#include "VideoBuffer.h"

VideoBuffer::VideoBuffer(int NumOfBFrame,int BufferSize, int ChunkSize, int GopSize)
{
	gopSize = GopSize;
	numOfBFrame = NumOfBFrame;
	bufferSize = BufferSize;
	chunkSize = ChunkSize;
	lastSetChunk = 0;
	lastSetFrame = 0;
	chunkBuffer = new Chunk[bufferSize];
	for(int i = 0 ; i < bufferSize ; i++)
	{
		chunkBuffer[i].setValues(chunkSize);
		chunkBuffer[i].setChunkNumber(i);
	}
}
VideoBuffer::~VideoBuffer()
{
	delete[] chunkBuffer;
}
void VideoBuffer::updateBufferMap(BufferMap* BMap)
{
	for(int i=0 ; i < bufferSize ; i++)
	{
		if(chunkBuffer[i].isComplete())
			BMap->buffermap[i] = true;
		else
			BMap->buffermap[i] = false;
		BMap->chunkNumbers[i] = chunkBuffer[i].getChunkNumber();
	}
	BMap->setLastSetChunk(lastSetChunk);
}
std::ostream& operator<<(std::ostream& os, const VideoBuffer& v)
{
	for (int i=0 ; i < v.bufferSize ; i++)
	{
		os << v.chunkBuffer[i];
		if((i+1)%v.gopSize == 0)
			os << std::endl;
	}
	return os;
}
void VideoBuffer::shiftChunkBuf()
{
	for(int j=0 ; j < 1 ; j++)
	{
		for(int i=0 ; i < bufferSize-1 ; i++)
		{
			chunkBuffer[i] = chunkBuffer[i+1];
		}
		Chunk ch;
		ch.setValues(chunkSize);
		ch.setChunkNumber(chunkBuffer[bufferSize-2].getChunkNumber()+1);
		chunkBuffer[bufferSize-1] = ch;
	}
}
void VideoBuffer::setFrame(VideoFrame vFrame)
{
	int ExtractedChunkNum = vFrame.getFrameNumber()/(chunkSize);
	while(ExtractedChunkNum > chunkBuffer[bufferSize-2].getChunkNumber())
			shiftChunkBuf();

	if(ExtractedChunkNum >=  chunkBuffer[0].getChunkNumber() &&
			ExtractedChunkNum <= chunkBuffer[bufferSize-1].getChunkNumber())
	{
		chunkBuffer[ExtractedChunkNum - chunkBuffer[0].getChunkNumber()].setFrame(vFrame);
		if(lastSetFrame < vFrame.getFrameNumber())
			lastSetFrame = vFrame.getFrameNumber();
		if(chunkBuffer[ExtractedChunkNum - chunkBuffer[0].getChunkNumber()].isComplete())
			lastSetChunk = ExtractedChunkNum;
	}
	/*else
		std::cout << "(ChunkBuffer::setFrame) ChunkBuffer Out of boundary!!!!!!!!" << std::endl;*/
}
VideoFrame VideoBuffer::getFrame(int FrameNumber)
{
	int ExtractedChunkNum = FrameNumber/(chunkSize);
	if(ExtractedChunkNum >=  chunkBuffer[0].getChunkNumber() &&
			ExtractedChunkNum <= chunkBuffer[bufferSize-1].getChunkNumber())
		return chunkBuffer[ExtractedChunkNum - chunkBuffer[0].getChunkNumber()]
		                   .chunk[FrameNumber%chunkSize].getVFrame();
	/*else
	{
		std::cout << chunkBuffer[0].getChunkNumber() << "  to  "<< chunkBuffer[bufferSize-1].getChunkNumber()<< std::endl;
		std::cout << "ExtractedChunkNum : "<<ExtractedChunkNum <<std::endl;
		std::cout << "(VideoBuffer::getFrame) ChunkBuffer Out of boundary!!!!!!!!" << std::endl;
	}*/
}
Chunk VideoBuffer::getChunk(int ChunkNumber)
{
	if(ChunkNumber >=  chunkBuffer[0].getChunkNumber() &&
			ChunkNumber <= chunkBuffer[bufferSize-1].getChunkNumber())
	{
		return chunkBuffer[ChunkNumber - chunkBuffer[0].getChunkNumber()];
	}
	/*else
	{
		std::cout << chunkBuffer[0].getChunkNumber() << "  to  "<< chunkBuffer[bufferSize-1].getChunkNumber()<< std::endl;
		std::cout << "ChunkNum : "<<ChunkNumber <<std::endl;
		std::cout << "(ChunkBuffer:getChunk) Chunk Not Found !!!!!"<< std::endl;
	}*/
}
void VideoBuffer::setChunk(Chunk InputChunk)
{
	int index = InputChunk.getChunkNumber() - chunkBuffer[0].getChunkNumber();
	if(InputChunk.getChunkNumber() >=  chunkBuffer[0].getChunkNumber() &&
				InputChunk.getChunkNumber() <= chunkBuffer[bufferSize-1].getChunkNumber())
	{
		chunkBuffer[index] = InputChunk;
		lastSetChunk = chunkBuffer[index].getChunkNumber();
	}
	/*else
	{
		std::cout << chunkBuffer[0].getChunkNumber() << "  to  "<< chunkBuffer[bufferSize-1].getChunkNumber()<< std::endl;
		std::cout << "ChunkNum : "<<InputChunk.getChunkNumber() <<std::endl;
		std::cout << "(ChunkBuffer:setChunk) Chunk Not Found !!!!!"<< std::endl;
	}*/
}

