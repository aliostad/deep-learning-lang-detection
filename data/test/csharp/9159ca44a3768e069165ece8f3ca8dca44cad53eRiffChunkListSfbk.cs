using System;
using System.Collections.Generic;

using Curan.Common.system.io;

namespace Curan.Common.FormalizedData.File.Riff.Sfbk
{
	public class RiffChunkListSfbk : RiffChunkList
	{
		public const string TYPE = "sfbk";

		public static readonly Dictionary<string,Type> chunkTypeDictionary;
		public static readonly Dictionary<string,Type> bodyTypeDictionary;

		public readonly List<RiffChunkList> sdtaListList;
		public readonly List<RiffChunkList> pdtaListList;
		public readonly RiffChunkListSdta sdtaBodyList;

		static RiffChunkListSfbk()
		{
			chunkTypeDictionary = new Dictionary<string, Type>();
			chunkTypeDictionary.Add( RiffChunkIbag.ID, typeof( RiffChunkIbag ) );
			chunkTypeDictionary.Add( RiffChunkIgen.ID, typeof( RiffChunkIgen ) );
			chunkTypeDictionary.Add( RiffChunkImod.ID, typeof( RiffChunkImod ) );
			chunkTypeDictionary.Add( RiffChunkInst.ID, typeof( RiffChunkInst ) );
			chunkTypeDictionary.Add( RiffChunkPbag.ID, typeof( RiffChunkPbag ) );
			chunkTypeDictionary.Add( RiffChunkPgen.ID, typeof( RiffChunkPgen ) );
			chunkTypeDictionary.Add( RiffChunkPhdr.ID, typeof( RiffChunkPhdr ) );
			chunkTypeDictionary.Add( RiffChunkPmod.ID, typeof( RiffChunkPmod ) );
			chunkTypeDictionary.Add( RiffChunkShdr.ID, typeof( RiffChunkShdr ) );
			chunkTypeDictionary.Add( RiffChunkSmpl.ID, typeof( RiffChunkSmpl ) );

			bodyTypeDictionary = new Dictionary<string, Type>();
			//chunkTypeDictionary.Add( RiffChunkList.ID, typeof( RiffChunkList ) );
			bodyTypeDictionary.Add( RiffChunkListInfo.TYPE, typeof( RiffChunkListInfo ) );
			bodyTypeDictionary.Add( RiffChunkListSdta.TYPE, typeof( RiffChunkListSdta ) );
			bodyTypeDictionary.Add( RiffChunkListPdta.TYPE, typeof( RiffChunkListPdta ) );
		}

		public RiffChunkListSfbk( string aId, UInt32 aSize, ByteArray aByteArray, RiffChunkList aParent )
			: base( chunkTypeDictionary, bodyTypeDictionary, aId, aSize, aByteArray, aParent )
		{
			type = TYPE;

			sdtaListList = GetChunkListList( "LIST", RiffChunkListSdta.TYPE );
			pdtaListList = GetChunkListList( "LIST", RiffChunkListPdta.TYPE );
			sdtaBodyList = ( RiffChunkListSdta )GetChunkList( "LIST", RiffChunkListSdta.TYPE );
		}
	}
}
