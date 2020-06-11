using System;
using System.Collections.Generic;

using Curan.Common.system.io;

namespace Curan.Common.FormalizedData.File.Riff.Avi
{
	public class RiffChunkListInfo : RiffChunkList
	{
		public const string TYPE = "INFO";

		public static readonly Dictionary<string,Type> chunkTypeDictionary;
		public static readonly Dictionary<string,Type> bodyTypeDictionary;

		public readonly RiffChunkIart chunkIart;
		public readonly RiffChunkIcms chunkIcms;
		public readonly RiffChunkIcmt chunkIcmt;
		public readonly RiffChunkIcop chunkIcop;
		public readonly RiffChunkIcrd chunkIcrd;
		public readonly RiffChunkIeng chunkIeng;
		public readonly RiffChunkIgnr chunkIgnr;
		public readonly RiffChunkIkey chunkIkey;
		public readonly RiffChunkInam chunkInam;
		public readonly RiffChunkIprd chunkIprd;
		public readonly RiffChunkIsbj chunkIsbj;
		public readonly RiffChunkIsft chunkIsft;
		public readonly RiffChunkIsrc chunkIsrc;
		public readonly RiffChunkItch chunkItch;

		static RiffChunkListInfo()
		{
			chunkTypeDictionary = new Dictionary<string, Type>();
			chunkTypeDictionary.Add( RiffChunkIart.ID, typeof( RiffChunkIart ) );
			chunkTypeDictionary.Add( RiffChunkIcms.ID, typeof( RiffChunkIcms ) );
			chunkTypeDictionary.Add( RiffChunkIcmt.ID, typeof( RiffChunkIcmt ) );
			chunkTypeDictionary.Add( RiffChunkIcop.ID, typeof( RiffChunkIcop ) );
			chunkTypeDictionary.Add( RiffChunkIcrd.ID, typeof( RiffChunkIcrd ) );
			chunkTypeDictionary.Add( RiffChunkIeng.ID, typeof( RiffChunkIeng ) );
			chunkTypeDictionary.Add( RiffChunkIgnr.ID, typeof( RiffChunkIgnr ) );
			chunkTypeDictionary.Add( RiffChunkIkey.ID, typeof( RiffChunkIkey ) );
			chunkTypeDictionary.Add( RiffChunkInam.ID, typeof( RiffChunkInam ) );
			chunkTypeDictionary.Add( RiffChunkIprd.ID, typeof( RiffChunkIprd ) );
			chunkTypeDictionary.Add( RiffChunkIsbj.ID, typeof( RiffChunkIsbj ) );
			chunkTypeDictionary.Add( RiffChunkIsft.ID, typeof( RiffChunkIsft ) );
			chunkTypeDictionary.Add( RiffChunkIsrc.ID, typeof( RiffChunkIsrc ) );
			chunkTypeDictionary.Add( RiffChunkItch.ID, typeof( RiffChunkItch ) );

			bodyTypeDictionary = new Dictionary<string, Type>();
		}

		public RiffChunkListInfo( string aId, UInt32 aSize, ByteArray aByteArray, RiffChunkList aParent )
			: base( chunkTypeDictionary, bodyTypeDictionary, aId, aSize, aByteArray, aParent )
		{
			type = TYPE;

			chunkIart = ( RiffChunkIart )GetChunk( RiffChunkIart.ID );
			chunkIcms = ( RiffChunkIcms )GetChunk( RiffChunkIcms.ID );
			chunkIcmt = ( RiffChunkIcmt )GetChunk( RiffChunkIcmt.ID );
			chunkIcop = ( RiffChunkIcop )GetChunk( RiffChunkIcop.ID );
			chunkIcrd = ( RiffChunkIcrd )GetChunk( RiffChunkIcrd.ID );
			chunkIeng = ( RiffChunkIeng )GetChunk( RiffChunkIeng.ID );
			chunkIgnr = ( RiffChunkIgnr )GetChunk( RiffChunkIgnr.ID );
			chunkIkey = ( RiffChunkIkey )GetChunk( RiffChunkIkey.ID );
			chunkInam = ( RiffChunkInam )GetChunk( RiffChunkInam.ID );
			chunkIprd = ( RiffChunkIprd )GetChunk( RiffChunkIprd.ID );
			chunkIsbj = ( RiffChunkIsbj )GetChunk( RiffChunkIsbj.ID );
			chunkIsft = ( RiffChunkIsft )GetChunk( RiffChunkIsft.ID );
			chunkIsrc = ( RiffChunkIsrc )GetChunk( RiffChunkIsrc.ID );
			chunkItch = ( RiffChunkItch )GetChunk( RiffChunkItch.ID );
		}
	}
}
