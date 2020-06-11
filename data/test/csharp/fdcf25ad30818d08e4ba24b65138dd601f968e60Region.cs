using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Text;

namespace mca2json
{
	[JsonObject(MemberSerialization.OptIn)]
	class Region
    {
		public Region()
		{
			chunkDatas = new List<Chunk>();
		}

		public void CleanUp()
		{
			datas = null;
			foreach(Chunk chunk in chunkDatas)
			{
				chunk.CleanUp();
			}
		}

		[JsonProperty]
		public int regionX;

		[JsonProperty]
		public int regionZ;

        public byte[] datas;

		[JsonProperty]
		public List<Chunk> chunkDatas;
    }
}
