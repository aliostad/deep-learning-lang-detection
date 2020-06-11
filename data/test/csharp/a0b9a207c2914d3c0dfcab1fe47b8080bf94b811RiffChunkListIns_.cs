using System;
using System.Collections.Generic;

using Curan.Common.system.io;

namespace Curan.Common.FormalizedData.File.Riff.Dls
{
	public class RiffChunkListIns_ : RiffChunkList
	{
		public const string TYPE = "ins ";

		public static readonly Dictionary<string,Type> chunkTypeDictionary;
		public static readonly Dictionary<string,Type> bodyTypeDictionary;

		public readonly RiffChunkDlid dlidChunk;
		public readonly RiffChunkInsh inshChunk;
		public readonly List<RiffChunkList> lrgnListList;
		public readonly List<RiffChunkList> lartListList;
		public readonly List<RiffChunkList> infoListList;

		static RiffChunkListIns_()
		{
			chunkTypeDictionary = new Dictionary<string, Type>();
			chunkTypeDictionary.Add( RiffChunkDlid.ID, typeof( RiffChunkDlid ) );
			chunkTypeDictionary.Add( RiffChunkInsh.ID, typeof( RiffChunkInsh ) );

			bodyTypeDictionary = new Dictionary<string, Type>();
			//			chunkTypeDictionary.Add( RiffChunkList.ID, typeof( RiffChunkList ) );
			bodyTypeDictionary.Add( RiffChunkListLrgn.TYPE, typeof( RiffChunkListLrgn ) );
			bodyTypeDictionary.Add( RiffChunkListLart.TYPE, typeof( RiffChunkListLart ) );
			bodyTypeDictionary.Add( RiffChunkListInfo.TYPE, typeof( RiffChunkListInfo ) );
		}

		public RiffChunkListIns_( string aId, UInt32 aSize, ByteArray aByteArray, RiffChunkList aParent )
			: base( chunkTypeDictionary, bodyTypeDictionary, aId, aSize, aByteArray, aParent )
		{
			type = TYPE;

			dlidChunk = ( RiffChunkDlid )GetChunk( RiffChunkDlid.ID );
			inshChunk = ( RiffChunkInsh )GetChunk( RiffChunkInsh.ID );
			lrgnListList = GetChunkListList( "LIST", RiffChunkListLrgn.TYPE );
			lartListList = GetChunkListList( "LIST", RiffChunkListLart.TYPE );
			infoListList = GetChunkListList( "LIST", RiffChunkListInfo.TYPE );
		}
	}
}
