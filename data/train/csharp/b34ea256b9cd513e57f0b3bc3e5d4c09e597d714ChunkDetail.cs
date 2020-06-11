using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace HCS_Encoder {

	public class ChunkDetail : IComparable<ChunkDetail> {
		public int StreamIndex { get; set; }
		public int ChunkIndex { get; set; }
		public double ChunkDuration { get; set; }
		public string SourceFilePath { get; set; }
		public ChunkDetail (int chunkIndex, int streamIndex, double duration) {
			this.ChunkIndex = chunkIndex;
			this.StreamIndex = streamIndex;
			this.ChunkDuration = duration;
		}
		public ChunkDetail (string path, int chunkIndex, int streamIndex, double duration) {
			this.ChunkIndex = chunkIndex;
			this.StreamIndex = streamIndex;
			this.ChunkDuration = duration;
			this.SourceFilePath = path;
		}

		#region IComparable<ChunkDetail> Members

		public int CompareTo (ChunkDetail other) {
			return this.ChunkIndex.CompareTo(other.ChunkIndex);
		}

		#endregion
	}

	public class ChunkUploadedEventArgs : EventArgs {
		public int ChunkIndex { get; set; }
		public int StreamIndex { get; set; }
		public double ChunkDuration { get; set; }
		public string SourceFilePath { get; set; }
	}
}
