using System;
using System.Collections.Generic;

using Curan.Common.system.io;

namespace Curan.Common.FormalizedData.File.Riff.Sfbk
{
	public class RiffChunkListPdta : RiffChunkList
	{
		public const string TYPE = "pdta";

		public static readonly Dictionary<string,Type> chunkTypeDictionary;
		public static readonly Dictionary<string,Type> bodyTypeDictionary;

		public RiffChunkPhdr phdrBody;
		public RiffChunkPbag pbagBody;
		public RiffChunkPmod pmodBody;
		public RiffChunkPgen pgenBody;
		public RiffChunkInst instBody;
		public RiffChunkIbag ibagBody;
		public RiffChunkImod imodBody;
		public RiffChunkIgen igenBody;
		public RiffChunkShdr shdrBody;

		static RiffChunkListPdta()
		{
			chunkTypeDictionary = new Dictionary<string, Type>();
			chunkTypeDictionary.Add( RiffChunkPhdr.ID, typeof( RiffChunkPhdr ) );
			chunkTypeDictionary.Add( RiffChunkPbag.ID, typeof( RiffChunkPbag ) );
			chunkTypeDictionary.Add( RiffChunkPmod.ID, typeof( RiffChunkPmod ) );
			chunkTypeDictionary.Add( RiffChunkPgen.ID, typeof( RiffChunkPgen ) );
			chunkTypeDictionary.Add( RiffChunkInst.ID, typeof( RiffChunkInst ) );
			chunkTypeDictionary.Add( RiffChunkIbag.ID, typeof( RiffChunkIbag ) );
			chunkTypeDictionary.Add( RiffChunkImod.ID, typeof( RiffChunkImod ) );
			chunkTypeDictionary.Add( RiffChunkIgen.ID, typeof( RiffChunkIgen ) );
			chunkTypeDictionary.Add( RiffChunkShdr.ID, typeof( RiffChunkShdr ) );

			bodyTypeDictionary = new Dictionary<string, Type>();
		}

		public RiffChunkListPdta( string aId, UInt32 aSize, ByteArray aByteArray, RiffChunkList aParent )
			: base( chunkTypeDictionary, bodyTypeDictionary, aId, aSize, aByteArray, aParent )
		{
			type = TYPE;

			phdrBody = ( RiffChunkPhdr )GetChunk( RiffChunkPhdr.ID );
			pbagBody = ( RiffChunkPbag )GetChunk( RiffChunkPbag.ID );
			pmodBody = ( RiffChunkPmod )GetChunk( RiffChunkPmod.ID );
			pgenBody = ( RiffChunkPgen )GetChunk( RiffChunkPgen.ID );
			instBody = ( RiffChunkInst )GetChunk( RiffChunkInst.ID );
			ibagBody = ( RiffChunkIbag )GetChunk( RiffChunkIbag.ID );
			imodBody = ( RiffChunkImod )GetChunk( RiffChunkImod.ID );
			igenBody = ( RiffChunkIgen )GetChunk( RiffChunkIgen.ID );
			shdrBody = ( RiffChunkShdr )GetChunk( RiffChunkShdr.ID );
		}
	}
}
