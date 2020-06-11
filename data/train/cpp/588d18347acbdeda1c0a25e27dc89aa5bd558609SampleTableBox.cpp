#include "SampleTableBox.h"

using namespace Boxes;
using namespace std;

SampleTableBox::SampleTableBox (uint32_t size, uint64_t type) :
		BaseBox (size, type),
		SampleDescription (NULL),
		TimeToSample (NULL),
		SampleToChunk (NULL),
		SampleSize (NULL),
		ChunkOffset (NULL)
		{}
SampleTableBox::~SampleTableBox () {
	if (this->SampleDescription) 	delete this->SampleDescription;
	if (this->TimeToSample) 		delete this->TimeToSample;
	if (this->SampleToChunk) 		delete this->SampleToChunk;
	if (this->SampleSize) 			delete this->SampleSize;
	if (this->ChunkOffset) 			delete this->ChunkOffset;
}

void SampleTableBox::SetSampleDescriptionBox (SampleDescriptionBox *stsdBox) {
	if (!this->SampleDescription) this->SampleDescription = stsdBox;
}
void SampleTableBox::SetTimeToSampleBox (TimeToSampleBox *sttsBox) {
	if (!this->TimeToSample) this->TimeToSample = sttsBox;
}
void SampleTableBox::SetSampleToChunkBox (SampleToChunkBox *stscBox) {
	if (!this->SampleToChunk) this->SampleToChunk = stscBox;
}
void SampleTableBox::SetSampleSizeBoc (SampleSizeBox *stszBox) {
	if (!this->SampleSize) this->SampleSize = stszBox;
}
void SampleTableBox::SetChunkOffsetBox (ChunkOffsetBox *stcoBox) {
	if (!this->ChunkOffset) this->ChunkOffset = stcoBox;
}

SampleDescriptionBox* SampleTableBox::GetSampleDescriptionBox () {
	return this->SampleDescription;
}
TimeToSampleBox* SampleTableBox::GetTimeToSampleBox () {
	return this->TimeToSample;
}
SampleToChunkBox* SampleTableBox::GetSampleToChunkBox () {
	return this->SampleToChunk;
}
SampleSizeBox* SampleTableBox::GetSampleSizeBoc () {
	return this->SampleSize;
}
ChunkOffsetBox* SampleTableBox::GetChunkOffsetBox () {
	return this->ChunkOffset;
}

void SampleTableBox::Print (uint32_t level) {
	stringstream ss;
	for (uint32_t i = 0; i < level; i++)
		ss << "  ";

	cout << endl;
	cout << ss.str() << "Sample Table Box :" << endl;
	cout << ss.str() << "  Size = " << this->GetSize() << endl;
	cout << ss.str() << "  Type = " << this->GetType() << " (";
	for (int i = 3; i >= 0; i--) cout << (uint8_t)(this->GetType() >> i*8);
	cout << ")" << endl;

	if (this->SampleDescription) 	this->SampleDescription->Print(level+1);
	if (this->TimeToSample) 		this->TimeToSample->Print(level+1);
	if (this->SampleToChunk) 		this->SampleToChunk->Print(level+1);
	if (this->SampleSize) 			this->SampleSize->Print(level+1);
	if (this->ChunkOffset) 			this->ChunkOffset->Print(level+1);
}