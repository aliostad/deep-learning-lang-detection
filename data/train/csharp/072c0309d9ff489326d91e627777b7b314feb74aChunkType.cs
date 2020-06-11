using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Omega.Lib.APNG.Chunks
	{
	public class ChunkType
		{
		public static readonly ChunkType IHDR = new ChunkType("IHDR");
		public static readonly ChunkType PLTE = new ChunkType("PLTE");
		public static readonly ChunkType IDAT = new ChunkType("IDAT");
		public static readonly ChunkType IEND = new ChunkType("IEND");
		public static readonly ChunkType cHRM = new ChunkType("cHRM");
		public static readonly ChunkType gAMA = new ChunkType("gAMA");
		public static readonly ChunkType iCCP = new ChunkType("iCCP");
		public static readonly ChunkType sBIT = new ChunkType("sBIT");
		public static readonly ChunkType sRGB = new ChunkType("sRGB");
		public static readonly ChunkType bKGD = new ChunkType("bKGD");
		public static readonly ChunkType hIST = new ChunkType("hIST");
		public static readonly ChunkType tRNS = new ChunkType("tRNS");
		public static readonly ChunkType pHYs = new ChunkType("pHYs");
		public static readonly ChunkType sPLT = new ChunkType("sPLT");
		public static readonly ChunkType tIME = new ChunkType("tIME");
		public static readonly ChunkType iTXt = new ChunkType("iTXt");
		public static readonly ChunkType tEXt = new ChunkType("tEXt");
		public static readonly ChunkType zTXt = new ChunkType("zTXt");

		public static readonly ChunkType fdAT = new ChunkType("fdAT");
		public static readonly ChunkType acTL = new ChunkType("acTL");
		public static readonly ChunkType fcTL = new ChunkType("fcTL");

		public String Name { get; protected set; }
		public Byte[] Bytes { get { return Encoding.UTF7.GetBytes(Name); } }


		public ChunkType(String identifier)
			{
			Name = identifier;
			}

		public ChunkType(String name, Boolean ancillary, Boolean privat, Boolean reserved, Boolean safeToCopy)
			{
			throw new NotImplementedException();
			}
		}
	}
