using System;
using System.Collections.Generic;

using Curan.Common.system.io;

namespace Curan.Common.FormalizedData.File.Riff.Dls
{
	public class RiffChunkListWave : RiffChunkList
	{
		public const string TYPE = "wave";

		public static readonly Dictionary<string,Type> chunkTypeDictionary;
		public static readonly Dictionary<string,Type> bodyTypeDictionary;

		public readonly RiffChunkDlid dlidChunk;
		public readonly RiffChunkFmt_ fmt_Chunk;
		public readonly RiffChunkData dataChunk;
		public readonly RiffChunkWsmp wsmpChunk;

		static RiffChunkListWave()
		{
			chunkTypeDictionary = new Dictionary<string, Type>();
			chunkTypeDictionary.Add( RiffChunkDlid.ID, typeof( RiffChunkDlid ) );
			chunkTypeDictionary.Add( RiffChunkFmt_.ID, typeof( RiffChunkFmt_ ) );
			chunkTypeDictionary.Add( RiffChunkData.ID, typeof( RiffChunkData ) );
			chunkTypeDictionary.Add( RiffChunkWsmp.ID, typeof( RiffChunkWsmp ) );

			bodyTypeDictionary = new Dictionary<string, Type>();
			//			chunkTypeDictionary.Add( RiffChunkList.ID, typeof( RiffChunkList ) );
			bodyTypeDictionary.Add( RiffChunkListLrgn.TYPE, typeof( RiffChunkListLrgn ) );
			bodyTypeDictionary.Add( RiffChunkListInfo.TYPE, typeof( RiffChunkListInfo ) );
		}

		public RiffChunkListWave( string aId, UInt32 aSize, ByteArray aByteArray, RiffChunkList aParent )
			: base( chunkTypeDictionary, bodyTypeDictionary, aId, aSize, aByteArray, aParent )
		{
			type = TYPE;

			dlidChunk = ( RiffChunkDlid )GetChunk( RiffChunkDlid.ID );
			fmt_Chunk = ( RiffChunkFmt_ )GetChunk( RiffChunkFmt_.ID );
			dataChunk = ( RiffChunkData )GetChunk( RiffChunkData.ID );
			wsmpChunk = ( RiffChunkWsmp )GetChunk( RiffChunkWsmp.ID );
		}
	}
}
