using System;
using System.Collections.Generic;

using Curan.Common.system.io;

namespace Curan.Common.FormalizedData.File.Riff.Wave
{
	public class RiffChunkListInfo : RiffChunkList
	{
		public const string TYPE = "INFO";

		public static readonly Dictionary<string,Type> bodyTypeDictionary;
		public static readonly Dictionary<string,Type> chunkTypeDictionary;

		public readonly RiffChunkIart iartBody;
		public readonly RiffChunkIcms icmsBody;
		public readonly RiffChunkIcmt icmtBody;
		public readonly RiffChunkIcop icopBody;
		public readonly RiffChunkIcrd icrdBody;
		public readonly RiffChunkIeng iengBody;
		public readonly RiffChunkIgnr ignrBody;
		public readonly RiffChunkIkey ikeyBody;
		public readonly RiffChunkInam inamBody;
		public readonly RiffChunkIprd iprdBody;
		public readonly RiffChunkIsbj isbjBody;
		public readonly RiffChunkIsft isftBody;
		public readonly RiffChunkIsrc isrcBody;
		public readonly RiffChunkItch itchBody;

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

			iartBody = ( RiffChunkIart )GetChunk( RiffChunkIart.ID );
			icmsBody = ( RiffChunkIcms )GetChunk( RiffChunkIcms.ID );
			icmtBody = ( RiffChunkIcmt )GetChunk( RiffChunkIcmt.ID );
			icopBody = ( RiffChunkIcop )GetChunk( RiffChunkIcop.ID );
			icrdBody = ( RiffChunkIcrd )GetChunk( RiffChunkIcrd.ID );
			iengBody = ( RiffChunkIeng )GetChunk( RiffChunkIeng.ID );
			ignrBody = ( RiffChunkIgnr )GetChunk( RiffChunkIgnr.ID );
			ikeyBody = ( RiffChunkIkey )GetChunk( RiffChunkIkey.ID );
			inamBody = ( RiffChunkInam )GetChunk( RiffChunkInam.ID );
			iprdBody = ( RiffChunkIprd )GetChunk( RiffChunkIprd.ID );
			isbjBody = ( RiffChunkIsbj )GetChunk( RiffChunkIsbj.ID );
			isftBody = ( RiffChunkIsft )GetChunk( RiffChunkIsft.ID );
			isrcBody = ( RiffChunkIsrc )GetChunk( RiffChunkIsrc.ID );
			itchBody = ( RiffChunkItch )GetChunk( RiffChunkItch.ID );
		}
	}
}
