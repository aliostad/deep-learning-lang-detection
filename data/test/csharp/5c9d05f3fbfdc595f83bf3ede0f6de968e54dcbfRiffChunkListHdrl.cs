using System;
using System.Collections.Generic;

using Curan.Common.system.io;

namespace Curan.Common.FormalizedData.File.Riff.Avi
{
	public class RiffChunkListHdrl : RiffChunkList
	{
		public const string TYPE = "hdrl";

		public static readonly Dictionary<string,Type> chunkTypeDictionary;
		public static readonly Dictionary<string,Type> bodyTypeDictionary;

		public RiffChunkAvih chunkAvih;
		public RiffChunkStrf chunkStrf;
		public RiffChunkStrh chunkStrh;

		static RiffChunkListHdrl()
		{
			chunkTypeDictionary = new Dictionary<string, Type>();
			chunkTypeDictionary.Add( RiffChunkAvih.ID, typeof( RiffChunkAvih ) );
			chunkTypeDictionary.Add( RiffChunkStrh.ID, typeof( RiffChunkStrh ) );
			chunkTypeDictionary.Add( RiffChunkStrf.ID, typeof( RiffChunkStrf ) );

			bodyTypeDictionary = new Dictionary<string, Type>();
			//chunkTypeDictionary.Add( RiffChunkList.ID, typeof( RiffChunkList ) );
			bodyTypeDictionary.Add( RiffChunkListStrl.TYPE, typeof( RiffChunkListStrl ) );
			bodyTypeDictionary.Add( RiffChunkListInfo.TYPE, typeof( RiffChunkListInfo ) );
		}

		public RiffChunkListHdrl( string aId, UInt32 aSize, ByteArray aByteArray, RiffChunkList aParent )
			: base( chunkTypeDictionary, bodyTypeDictionary, aId, aSize, aByteArray, aParent )
		{
			type = TYPE;

			chunkAvih = ( RiffChunkAvih )GetChunk( RiffChunkAvih.ID );
			chunkStrf = ( RiffChunkStrf )GetChunk( RiffChunkStrf.ID );
			chunkStrh = ( RiffChunkStrh )GetChunk( RiffChunkStrh.ID );
		}
	}
}
