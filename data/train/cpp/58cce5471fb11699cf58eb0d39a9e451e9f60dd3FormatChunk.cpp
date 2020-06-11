/* 
 * File:   FormatChunk.cpp
 * Author: rd
 * 
 * Created on 3 Июнь 2010 г., 12:49
 */


#include "FormatChunk.h"
#include "WaveChunk.h"

FormatChunk::FormatChunk() {
}

FormatChunk::FormatChunk(const FormatChunk& orig) {
    throw "Не должен этот класс копироваться!";
}

FormatChunk::~FormatChunk() {
}

void FormatChunk::loadData(std::ifstream& in){
    if(getSize()!=sizeof(WaveFormat))
        throw "Поврежденный format-chunk";
    in.read((char*)(&format),sizeof(WaveFormat));
}

void FormatChunk::saveData(std::ofstream& out)const{
    out.write((const char*)&format,sizeof(WaveFormat));
}


unsigned short FormatChunk::getFormatTag() const{
    return format.formatTag;
    
}
unsigned short FormatChunk::getChannels()const{
    return format.channels;

}
unsigned int FormatChunk::getSamplesPerSec()const{
    return format.samplesPerSec;
}
unsigned int FormatChunk::getAvgBytesPerSec()const{
    return format.avgBytesPerSec;
}
unsigned short FormatChunk::getBlockAlign()const{
    return format.blockAlign;
}
unsigned short  FormatChunk::bitsPerSample()const{
    return format.bitsPerSample;
}