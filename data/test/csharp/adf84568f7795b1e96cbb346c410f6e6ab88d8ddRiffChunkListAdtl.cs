using System;
using System.Collections.Generic;

using Curan.Common.system.io;

namespace Curan.Common.FormalizedData.File.Riff.Wave
{
	public class RiffChunkListAdtl : RiffChunkList
	{
		public const string TYPE = "adtl";

		public static readonly Dictionary<string,Type> bodyTypeDictionary;
		public static readonly Dictionary<string,Type> chunkTypeDictionary;

		public RiffChunkLabl lablBody;
		public RiffChunkNote noteBody;
		public RiffChunkLtxt ltxtBody;
		public RiffChunkFile fileBody;

		static RiffChunkListAdtl()
		{
			chunkTypeDictionary = new Dictionary<string, Type>();
			chunkTypeDictionary.Add( RiffChunkLabl.ID, typeof( RiffChunkLabl ) );
			chunkTypeDictionary.Add( RiffChunkNote.ID, typeof( RiffChunkNote ) );
			chunkTypeDictionary.Add( RiffChunkLtxt.ID, typeof( RiffChunkLtxt ) );
			chunkTypeDictionary.Add( RiffChunkFile.ID, typeof( RiffChunkFile ) );

			bodyTypeDictionary = new Dictionary<string, Type>();
		}

		public RiffChunkListAdtl( string aId, UInt32 aSize, ByteArray aByteArray, RiffChunkList aParent )
			: base( chunkTypeDictionary, bodyTypeDictionary, aId, aSize, aByteArray, aParent )
		{
			type = TYPE;

			lablBody = ( RiffChunkLabl )GetChunk( RiffChunkLabl.ID );
			noteBody = ( RiffChunkNote )GetChunk( RiffChunkNote.ID );
			ltxtBody = ( RiffChunkLtxt )GetChunk( RiffChunkLtxt.ID );
			fileBody = ( RiffChunkFile )GetChunk( RiffChunkFile.ID );
		}
	}
}
