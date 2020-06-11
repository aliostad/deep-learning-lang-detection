#ifndef SAMPLE_TABLE_BOX_H
#define SAMPLE_TABLE_BOX_H

#include "BaseBox.h"
#include "SampleDescriptionBox.h"
#include "TimeToSampleBox.h"
#include "SampleToChunkBox.h"
#include "SampleSizeBox.h"
#include "ChunkOffsetBox.h"

namespace Boxes {
	class SampleTableBox : public BaseBox {
	public:
		SampleTableBox (uint32_t size, uint64_t type);
		~SampleTableBox ();

		void SetSampleDescriptionBox (SampleDescriptionBox *stsdBox);
		void SetTimeToSampleBox (TimeToSampleBox *sttsBox);
		void SetSampleToChunkBox (SampleToChunkBox *stscBox);
		void SetSampleSizeBoc (SampleSizeBox *stszBox);
		void SetChunkOffsetBox (ChunkOffsetBox *stcoBox);

		SampleDescriptionBox* GetSampleDescriptionBox ();
		TimeToSampleBox* GetTimeToSampleBox ();
		SampleToChunkBox* GetSampleToChunkBox ();
		SampleSizeBox* GetSampleSizeBoc ();
		ChunkOffsetBox* GetChunkOffsetBox ();

		void Print (uint32_t level);

	private:
		SampleDescriptionBox *SampleDescription;
		TimeToSampleBox *TimeToSample;
		SampleToChunkBox *SampleToChunk;
		SampleSizeBox *SampleSize;
		ChunkOffsetBox *ChunkOffset;
	};
}

#endif /* SAMPLE_TABLE_BOX_H */