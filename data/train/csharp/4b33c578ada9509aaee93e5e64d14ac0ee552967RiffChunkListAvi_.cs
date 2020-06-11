using System;
using System.Collections.Generic;

using Curan.Common.system.io;

namespace Curan.Common.FormalizedData.File.Riff.Avi
{
	public class RiffChunkListAvi_ : RiffChunkList
	{
		public const string TYPE = "AVI ";

		public static readonly Dictionary<string,Type> chunkTypeDictionary;
		public static readonly Dictionary<string,Type> bodyTypeDictionary;

		public readonly RiffChunkListMovi moviBodyList;
		public readonly RiffChunkListHdrl hdrlBodyList;

		static RiffChunkListAvi_()
		{
			chunkTypeDictionary = new Dictionary<string, Type>();
			chunkTypeDictionary.Add( RiffChunkListHdrl.TYPE, typeof( RiffChunkListHdrl ) );
			chunkTypeDictionary.Add( RiffChunkListStrl.TYPE, typeof( RiffChunkListStrl ) );
			chunkTypeDictionary.Add( RiffChunkListMovi.TYPE, typeof( RiffChunkListMovi ) );
			chunkTypeDictionary.Add( RiffChunkListInfo.TYPE, typeof( RiffChunkListInfo ) );

			bodyTypeDictionary = new Dictionary<string, Type>();
			//chunkTypeDictionary.Add( RiffChunkList.ID, typeof( RiffChunkList ) );
		}

		public RiffChunkListAvi_( string aId, UInt32 aSize, ByteArray aByteArray, RiffChunkList aParent )
			: base( chunkTypeDictionary, bodyTypeDictionary, aId, aSize, aByteArray, aParent )
		{
			type = TYPE;

			moviBodyList = ( RiffChunkListMovi )GetChunkList( "LIST", RiffChunkListMovi.TYPE );
			hdrlBodyList = ( RiffChunkListHdrl )GetChunkList( "LIST", RiffChunkListHdrl.TYPE );
		}

		public RiffChunkXxdb Get00db( int aIndex )
		{
			return moviBodyList.chunkXxdb;
		}
		
		public RiffChunkAvih GetAvihChunk()
		{
			return hdrlBodyList.chunkAvih;
		}
	}
}
