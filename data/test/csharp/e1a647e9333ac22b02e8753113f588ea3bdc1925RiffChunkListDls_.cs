using System;
using System.Collections.Generic;

using Curan.Common.system.io;

namespace Curan.Common.FormalizedData.File.Riff.Dls
{
	public class RiffChunkListDls_ : RiffChunkList
	{
		public const string TYPE = "DLS ";

		public static readonly Dictionary<string,Type> chunkTypeDictionary;
		public static readonly Dictionary<string,Type> bodyTypeDictionary;

		public readonly RiffChunkColh colhChunkList;
		public readonly RiffChunkMsyn msynChunkList;
		public readonly RiffChunkPtbl ptblChunkList;
		public readonly RiffChunkVers versChunkList;
		public readonly RiffChunkListLins linsListList;
		public readonly RiffChunkListWvpl wvplListList;
		public readonly RiffChunkListInfo infoListList;

		static RiffChunkListDls_()
		{
			chunkTypeDictionary = new Dictionary<string, Type>();
			chunkTypeDictionary.Add( RiffChunkColh.ID, typeof( RiffChunkColh ) );
			chunkTypeDictionary.Add( RiffChunkMsyn.ID, typeof( RiffChunkMsyn ) );
			chunkTypeDictionary.Add( RiffChunkPtbl.ID, typeof( RiffChunkPtbl ) );
			chunkTypeDictionary.Add( RiffChunkVers.ID, typeof( RiffChunkVers ) );

			bodyTypeDictionary = new Dictionary<string, Type>();
			//			chunkTypeDictionary.Add( RiffChunkList.ID, typeof( RiffChunkList ) );
			bodyTypeDictionary.Add( RiffChunkListLins.TYPE, typeof( RiffChunkListLins ) );
			bodyTypeDictionary.Add( RiffChunkListWvpl.TYPE, typeof( RiffChunkListWvpl ) );
			bodyTypeDictionary.Add( RiffChunkListInfo.TYPE, typeof( RiffChunkListInfo ) );
		}

		public RiffChunkListDls_( string aId, UInt32 aSize, ByteArray aByteArray, RiffChunkList aParent )
			: base( chunkTypeDictionary, bodyTypeDictionary, aId, aSize, aByteArray, aParent )
		{
			type = TYPE;

			colhChunkList = ( RiffChunkColh )GetChunk( RiffChunkColh.ID );
			msynChunkList = ( RiffChunkMsyn )GetChunk( RiffChunkMsyn.ID );
			ptblChunkList = ( RiffChunkPtbl )GetChunk( RiffChunkPtbl.ID );
			versChunkList = ( RiffChunkVers )GetChunk( RiffChunkVers.ID );
			linsListList = ( RiffChunkListLins )GetChunkList( "LIST", RiffChunkListLins.TYPE );
			wvplListList = ( RiffChunkListWvpl )GetChunkList( "LIST", RiffChunkListWvpl.TYPE );
			infoListList = ( RiffChunkListInfo )GetChunkList( "LIST", RiffChunkListInfo.TYPE );
		}
	}
}
