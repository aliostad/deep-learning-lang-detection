using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GraphicsLibrary.Voxel
{
	public static class ChunkLoader
	{
		static ChunkLoader()
		{
			if(!Directory.Exists("world"))
			{
				Directory.CreateDirectory("world");
			}
		}
		public static Chunk LoadChunk(IntVector d)
		{
			Chunk output = new Chunk(d.x, d.y);
			output.cdata = File.ReadAllBytes("world/c" + d.x + "c" + d.y + ".dat");
			return output;
		}

		public static bool ChunkIsSaved(IntVector d)
		{
            //return false;
			return File.Exists("world/c" + d.x + "c" + d.y + ".dat");
		}

		public static void SaveChunk(Chunk chunk)
		{
			File.WriteAllBytes("world/c" + chunk.xx + "c" + chunk.yy + ".dat", chunk.cdata);
		}

		public static async Task SaveChunkASync(Chunk chunk)
		{
			using (FileStream fs = new FileStream("world/c" + chunk.xx + "c" + chunk.yy + ".dat", FileMode.Create))
			{
				fs.Seek(0, SeekOrigin.End);
				await fs.WriteAsync(chunk.cdata, 0, chunk.cdata.Length);
			}
			Console.WriteLine("Chunk save completed " + new IntVector(chunk.xx,chunk.yy));
		}
	}
}
