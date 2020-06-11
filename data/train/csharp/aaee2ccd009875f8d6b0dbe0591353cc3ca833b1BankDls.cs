using System;
using System.Collections.Generic;

using Monoamp.Common.Data.Standard.Riff.Dls;

namespace Monoamp.Common.Data.Application.Sound
{
	public class BankDls : ABank
	{
		public BankDls()
			: base()
		{

		}

		public void AddInstrument( RiffChunkListIns_ ins_List, List<WaveformReaderPcm> aWaveformList )
		{
			int tuning = 0;

			for( int i = 0; i < ins_List.lartListList.Count; i++ ) {
				RiffChunkListLart lartList = ( RiffChunkListLart )ins_List.lartListList[i];

				RiffDls_Art1 art1Chunk = lartList.art1Body;

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
