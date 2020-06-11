using System;
using System.Collections.Generic;

using Curan.Common.system.io;

namespace Curan.Common.FormalizedData.File.Riff.Sfbk
{
	public class RiffChunkListInfo : RiffChunkList
	{
		public const string TYPE = "INFO";

		public static readonly Dictionary<string,Type> chunkTypeDictionary;
		public static readonly Dictionary<string,Type> bodyTypeDictionary;

		public RiffChunkIart iartBody;
		public RiffChunkIcms icmsBody;
		public RiffChunkIcmt icmtBody;
		public RiffChunkIcop icopBody;
		public RiffChunkIcrd icrdBody;
		public RiffChunkIeng iengBody;
		public RiffChunkIfil ifilBody;
		public RiffChunkIgnr ignrBody;
		public RiffChunkIkey ikeyBody;
		public RiffChunkInam inamBody;
		public RiffChunkIprd iprdBody;
		public RiffChunkIsbj isbjBody;
		public RiffChunkIsft isftBody;
		public RiffChunkIsng isngBody;
		public RiffChunkIsrc isrcBody;
		public RiffChunkItch itchBody;

		static RiffChunkListInfo()
		{
			chunkTypeDictionary = new Dictionary<string, Type>();
			chunkTypeDictionary.Add( RiffChunkIart.ID, typeof( RiffChunkIart ) );
			chunkTypeDictionary.Add( RiffChunkIcms.ID, typeof( RiffChunkIcms ) );
			chunkTypeDictionary.Add( RiffChunkIcmt.ID, typeof( RiffChunkIcmt ) );
			chunkTypeDictionary.Add( RiffChunkIcop.ID, typeof( RiffChunkIcop ) );
			chunkTypeDictionary.Add( RiffChunkIcrd.ID, typeof( RiffChunkIcrd ) );
			chunkTypeDictionary.Add( RiffChunkIeng.ID, typeof( RiffChunkIeng ) );
			chunkTypeDictionary.Add( RiffChunkIfil.ID, typeof( RiffChunkIfil ) );
			chunkTypeDictionary.Add( RiffChunkIgnr.ID, typeof( RiffChunkIgnr ) );
			chunkTypeDictionary.Add( RiffChunkIkey.ID, typeof( RiffChunkIkey ) );
			chunkTypeDictionary.Add( RiffChunkInam.ID, typeof( RiffChunkInam ) );
			chunkTypeDictionary.Add( RiffChunkIprd.ID, typeof( RiffChunkIprd ) );
			chunkTypeDictionary.Add( RiffChunkIsbj.ID, typeof( RiffChunkIsbj ) );
			chunkTypeDictionary.Add( RiffChunkIsft.ID, typeof( RiffChunkIsft ) );
			chunkTypeDictionary.Add( RiffChunkIsng.ID, typeof( RiffChunkIsng ) );
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
			ifilBody = ( RiffChunkIfil )GetChunk( RiffChunkIfil.ID );
			ignrBody = ( RiffChunkIgnr )GetChunk( RiffChunkIgnr.ID );
			ikeyBody = ( RiffChunkIkey )GetChunk( RiffChunkIkey.ID );
			inamBody = ( RiffChunkInam )GetChunk( RiffChunkInam.ID );
			iprdBody = ( RiffChunkIprd )GetChunk( RiffChunkIprd.ID );
			isbjBody = ( RiffChunkIsbj )GetChunk( RiffChunkIsbj.ID );
			isftBody = ( RiffChunkIsft )GetChunk( RiffChunkIsft.ID );
			isngBody = ( RiffChunkIsng )GetChunk( RiffChunkIsng.ID );
			isrcBody = ( RiffChunkIsrc )GetChunk( RiffChunkIsrc.ID );
			itchBody = ( RiffChunkItch )GetChunk( RiffChunkItch.ID );
		}
	}
}
