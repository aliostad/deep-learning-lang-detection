using System;
using System.Collections.Generic;

using Curan.Common.system.io;

namespace Curan.Common.FormalizedData.File.Riff.Dls
{
	public class RiffChunkListRgn2 : RiffChunkList
	{
		public const string TYPE = "rgn2";

		public static readonly Dictionary<string,Type> chunkTypeDictionary;
		public static readonly Dictionary<string,Type> bodyTypeDictionary;

		public readonly RiffChunkRgnh rgnhBody;
		public readonly RiffChunkWsmp wsmpBody;
		public readonly RiffChunkWlnk wlnkBody;
		public readonly List<RiffChunkList> rgn_ListList;

		static RiffChunkListRgn2()
		{
			chunkTypeDictionary = new Dictionary<string, Type>();
			chunkTypeDictionary.Add( RiffChunkRgnh.ID, typeof( RiffChunkRgnh ) );
			chunkTypeDictionary.Add( RiffChunkWsmp.ID, typeof( RiffChunkWsmp ) );
			chunkTypeDictionary.Add( RiffChunkWlnk.ID, typeof( RiffChunkWlnk ) );

			bodyTypeDictionary = new Dictionary<string, Type>();
			//			chunkTypeDictionary.Add( RiffChunkList.ID, typeof( RiffChunkList ) );
			bodyTypeDictionary.Add( RiffChunkListRgn_.TYPE, typeof( RiffChunkListRgn_ ) );
		}

		public RiffChunkListRgn2( string aId, UInt32 aSize, ByteArray aByteArray, RiffChunkList aParent )
			: base( chunkTypeDictionary, bodyTypeDictionary, aId, aSize, aByteArray, aParent )
		{
			type = TYPE;

			rgnhBody = ( RiffChunkRgnh )GetChunk( RiffChunkRgnh.ID );
			wsmpBody = ( RiffChunkWsmp )GetChunk( RiffChunkWsmp.ID );
			wlnkBody = ( RiffChunkWlnk )GetChunk( RiffChunkWlnk.ID );
			rgn_ListList = GetChunkListList( "LIST", RiffChunkListRgn_.TYPE );
		}
	}
}
