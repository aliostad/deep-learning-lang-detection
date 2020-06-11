using System;
using System.Collections.Generic;

using Curan.Common.system.io;

namespace Curan.Common.FormalizedData.File.Form.Aiff
{
	public class FormChunkListAiff : FormChunkList
	{
		public const string TYPE = "AIFF";

		public static readonly Dictionary<string,Type> bodyTypeDictionary;
		public static readonly Dictionary<string,Type> chunkTypeDictionary;

		public FormChunkChan chunkChan;
		public FormChunkComm chunkComm;
		public FormChunkComt chunkComt;
		public FormChunkMark chunkMark;
		public FormChunkSsnd chunkSsnd;

		static FormChunkListAiff()
		{
			chunkTypeDictionary = new Dictionary<string, Type>();
			chunkTypeDictionary.Add( FormChunkChan.ID, typeof( FormChunkChan ) );
			chunkTypeDictionary.Add( FormChunkComm.ID, typeof( FormChunkComm ) );
			chunkTypeDictionary.Add( FormChunkComt.ID, typeof( FormChunkComt ) );
			chunkTypeDictionary.Add( FormChunkMark.ID, typeof( FormChunkMark ) );
			chunkTypeDictionary.Add( FormChunkSsnd.ID, typeof( FormChunkSsnd ) );

			bodyTypeDictionary = new Dictionary<string, Type>();
		}

		public FormChunkListAiff( string aId, UInt32 aSize, ByteArray aByteArray, FormChunkList aParent )
			: base( chunkTypeDictionary, bodyTypeDictionary, aId, aSize, aByteArray, aParent )
		{
			type = TYPE;

			chunkChan = ( FormChunkChan )GetChunk( FormChunkChan.ID );
			chunkComm = ( FormChunkComm )GetChunk( FormChunkComm.ID );
			chunkComt = ( FormChunkComt )GetChunk( FormChunkComt.ID );
			chunkMark = ( FormChunkMark )GetChunk( FormChunkMark.ID );
			chunkSsnd = ( FormChunkSsnd )GetChunk( FormChunkSsnd.ID );
		}
	}
}
