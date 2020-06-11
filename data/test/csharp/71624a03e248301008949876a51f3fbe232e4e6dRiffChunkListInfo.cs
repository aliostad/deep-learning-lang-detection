using System;
using System.Collections.Generic;

using Curan.Common.system.io;

namespace Curan.Common.FormalizedData.File.Riff.Dls
{
	public class RiffChunkListInfo : RiffChunkList
	{
		public const string TYPE = "INFO";

		public static readonly Dictionary<string,Type> chunkTypeDictionary;
		public static readonly Dictionary<string,Type> bodyTypeDictionary;

		public readonly RiffChunkIfil ifilBody;
		public readonly RiffChunkInam inamBody;
		public readonly RiffChunkIsng isngBody;
		public readonly RiffChunkIprd iprdBody;
		public readonly RiffChunkIeng iengBody;
		public readonly RiffChunkIsbj isbjBody;
		public readonly RiffChunkIsft isftBody;
		public readonly RiffChunkIcrd icrdBody;
		public readonly RiffChunkIcmt icmtBody;
		public readonly RiffChunkIcop icopBody;

		static RiffChunkListInfo()
		{
			chunkTypeDictionary = new Dictionary<string, Type>();
			chunkTypeDictionary.Add( RiffChunkIfil.ID, typeof( RiffChunkIfil ) );
			chunkTypeDictionary.Add( RiffChunkInam.ID, typeof( RiffChunkInam ) );
			chunkTypeDictionary.Add( RiffChunkIsng.ID, typeof( RiffChunkIsng ) );
			chunkTypeDictionary.Add( RiffChunkIprd.ID, typeof( RiffChunkIprd ) );
			chunkTypeDictionary.Add( RiffChunkIeng.ID, typeof( RiffChunkIeng ) );
			chunkTypeDictionary.Add( RiffChunkIsbj.ID, typeof( RiffChunkIsbj ) );
			chunkTypeDictionary.Add( RiffChunkIsft.ID, typeof( RiffChunkIsft ) );
			chunkTypeDictionary.Add( RiffChunkIcrd.ID, typeof( RiffChunkIcrd ) );
			chunkTypeDictionary.Add( RiffChunkIcmt.ID, typeof( RiffChunkIcmt ) );
			chunkTypeDictionary.Add( RiffChunkIcop.ID, typeof( RiffChunkIcop ) );

			bodyTypeDictionary = new Dictionary<string, Type>();
		}

		public RiffChunkListInfo( string aId, UInt32 aSize, ByteArray aByteArray, RiffChunkList aParent )
			: base( chunkTypeDictionary, bodyTypeDictionary, aId, aSize, aByteArray, aParent )
		{
			type = TYPE;

			ifilBody = ( RiffChunkIfil )GetChunk( RiffChunkIfil.ID );
			inamBody = ( RiffChunkInam )GetChunk( RiffChunkInam.ID );
			isngBody = ( RiffChunkIsng )GetChunk( RiffChunkIsng.ID );
			iprdBody = ( RiffChunkIprd )GetChunk( RiffChunkIprd.ID );
			iengBody = ( RiffChunkIeng )GetChunk( RiffChunkIeng.ID );
			isbjBody = ( RiffChunkIsbj )GetChunk( RiffChunkIsbj.ID );
			isftBody = ( RiffChunkIsft )GetChunk( RiffChunkIsft.ID );
			icrdBody = ( RiffChunkIcrd )GetChunk( RiffChunkIcrd.ID );
			icmtBody = ( RiffChunkIcmt )GetChunk( RiffChunkIcmt.ID );
			icopBody = ( RiffChunkIcop )GetChunk( RiffChunkIcop.ID );
		}
	}
}
