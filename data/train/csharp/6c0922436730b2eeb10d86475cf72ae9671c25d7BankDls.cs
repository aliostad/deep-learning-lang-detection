using System;
using System.Collections.Generic;

using Curan.Common.FormalizedData.File.Riff.Dls;

namespace Curan.Common.AdaptedData
{
	public class BankDls : BankBase
	{
		public BankDls()
			: base()
		{

		}

		public void AddInstrument( RiffChunkListIns_ ins_List, List<WaveformBase> aWaveformList )
		{
			int tuning = 0;

			for( int i = 0; i < ins_List.lartListList.Count; i++ ) {
				RiffChunkListLart lartList = ( RiffChunkListLart )ins_List.lartListList[i];

				RiffChunkArt1 art1Chunk = lartList.art1Body;

				tuning = art1Chunk.tuning;
			}

			int instrument = ( int )ins_List.inshChunk.midiLocal.instrument;

			for( int i = 0; i < ins_List.lrgnListList.Count; i++ ) {
				RiffChunkListLrgn lrgnList = ( RiffChunkListLrgn )ins_List.lrgnListList[i];

				if( instrumentArray[instrument] == null ) {
					instrumentArray[instrument] = new InstrumentDls( lrgnList, aWaveformList, tuning );
				}
				else {
					InstrumentDls lInstrumentDls = ( InstrumentDls )instrumentArray[instrument];
					lInstrumentDls.AddSoundfont( lrgnList, aWaveformList, tuning );
				}
			}
		}
	}
}
