using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;

namespace Jacere.Data.PointCloud
{
	public interface IFinalizeProcess
	{
		void FinalizeProcess();
	}

	/// <summary>
	/// Processing stack.
	/// </summary>
	public class ChunkProcessSet// : IChunkProcess
	{
		private readonly List<IChunkProcess> m_chunkProcesses;

		public ChunkProcessSet(params IChunkProcess[] chunkProcesses)
		{
			m_chunkProcesses = new List<IChunkProcess>();
			foreach (var chunkProcess in chunkProcesses)
				if (chunkProcess != null)
					m_chunkProcesses.Add(chunkProcess);
		}

		public void Process(IPointCloudChunkEnumerator<IPointDataProgressChunk> enumerator)
		{
			foreach (var chunk in enumerator)
				ProcessChunk(chunk);

			foreach (var chunkProcess in m_chunkProcesses)
			{
				var finalizeProcess = chunkProcess as IFinalizeProcess;
				if (finalizeProcess != null)
					finalizeProcess.FinalizeProcess();
			}
		}

		private IPointDataChunk ProcessChunk(IPointDataChunk chunk)
		{
			// allow filters to replace the chunk definition
			var currentChunk = chunk;
			foreach (var chunkProcess in m_chunkProcesses)
				currentChunk = chunkProcess.Process(currentChunk);

			return currentChunk;
		}
	}
}
