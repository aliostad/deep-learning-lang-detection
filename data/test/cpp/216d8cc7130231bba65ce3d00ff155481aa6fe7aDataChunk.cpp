
#include "DataChunk.h"
#include "DataManager.h"

namespace Data {

DataChunk::DataChunk(const I8u & _numBytes, DataChunk * const & _nextPtr)
	:numBytes(_numBytes)
	,nextPtr(_nextPtr)
	,locked(false)
{
	dataPtr = DataManager::getMemory(numBytes);
}
DataChunk::~DataChunk(){
}
void DataChunk::release(){
	if(dataPtr!=nullptr){
		DataManager::release(dataPtr);
		dataPtr=nullptr;
	}
}
DataChunk::DataChunk(DataChunk && _dataChunk)
	:dataPtr(_dataChunk.dataPtr)
	,numBytes(_dataChunk.numBytes)
	,nextPtr(_dataChunk.nextPtr)
	,locked(_dataChunk.locked)
{
	_dataChunk.dataPtr=nullptr;
}
DataChunk::DataChunk(const DataChunk & _dataChunk)
	:dataPtr(_dataChunk.dataPtr)
	,numBytes(_dataChunk.numBytes)
	,nextPtr(_dataChunk.nextPtr)
	,locked(_dataChunk.locked)
{
}

}
