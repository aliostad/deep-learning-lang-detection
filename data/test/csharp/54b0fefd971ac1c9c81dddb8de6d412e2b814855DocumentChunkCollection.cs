using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;

namespace Spire
{
	class DocumentChunkCollection
	{
		private List<DocumentChunk> chunks; //list is never left empty
		private int updatedToChunkIndex;
		
		public DocumentChunkCollection()
		{
			Initialize();
		}
		
		public int Length
		{
			get 
			{
				UpdateAllChunks();
				return chunks.Last().End + 1;
			}
		}
		
		public char this[int cindex]
		{
			get
			{
				int chunkIndex = GetChunkIndexByCindex(cindex);
				DocumentChunk chunk = chunks[chunkIndex];
				return chunk[cindex];
			}
		}
		
		public void Initialize()
		{
			if(chunks == null)
			{
				chunks = new List<DocumentChunk>();
			}
			else
			{
				chunks.Clear();
			}
			chunks.Add(new DocumentChunk());
			updatedToChunkIndex = -1;
		}
		
		public void AddAt(string text, Cindex cindex)
		{
			int chunkIndex = GetChunkIndexByCindex(cindex);
			DocumentChunk chunk = chunks[chunkIndex];
			chunk.InsertText(text, cindex);
			updatedToChunkIndex = Math.Min(updatedToChunkIndex, chunkIndex);
			CheckChunkLength(chunkIndex, chunk);
		}
		
		public void RemoveAt(Cindex cindex, int length)
		{
			while(length > 0)
			{
				length = RemoveAtPartial(cindex, length);
				UpdateChunksToCindex(cindex + length);
			}
		}
		
		private int RemoveAtPartial(Cindex cindex, int length)
		{
			int chunkIndex = GetChunkIndexByCindex(cindex);
			DocumentChunk chunk = chunks[chunkIndex];
			int availableLength = Math.Min(length, chunk.End + 1 - cindex);
			if(availableLength == 0)
				return 0;
			chunk.RemoveText(cindex, availableLength);
			updatedToChunkIndex = chunkIndex;
			CheckChunkLength(chunkIndex, chunk);
			return length - availableLength;
		}
		
/*		private void Display()
		{
			Console.WriteLine("==========================");
			foreach(DocumentChunk chunk in chunks)
			{
				Console.WriteLine(chunk);
			}
		} */
		
		public string SubString(Cindex from, Cindex to)
		{
			if(to < from) throw new Exception(String.Format("Document 'to' ({0}) is less than 'from' ({1}).", to, from));
			int startChunkIndex = GetChunkIndexByCindex(from);
			int endChunkIndex = GetChunkIndexByCindex(to);
			if(startChunkIndex == endChunkIndex)
			{
				return chunks[startChunkIndex].SubStringByCharIndex(from, to);
			}			
			if(endChunkIndex - startChunkIndex < 3)
			{
				return SubStringWithConcat(startChunkIndex, endChunkIndex, from, to);
			}
			else
			{
				return SubStringWithStringBuilder(startChunkIndex, endChunkIndex, from, to);
			}
		}

		private string SubStringWithConcat(int startChunkIndex, int endChunkIndex, Cindex from, Cindex to)
		{
			string subString = chunks[startChunkIndex].SubStringFromCharIndex(from);
			for(int i=startChunkIndex+1; i<endChunkIndex; i++)
			{
				subString += chunks[i].Text;
			}
			subString += chunks[endChunkIndex].SubStringToCharIndex(to);
			return subString;
		}
		
		private string SubStringWithStringBuilder(int startChunkIndex, int endChunkIndex, Cindex from, Cindex to)
		{
			StringBuilder stringBuilder = new StringBuilder();
			stringBuilder.Append(chunks[startChunkIndex].SubStringFromCharIndex(from));
			for(int i=startChunkIndex+1; i<endChunkIndex; i++)
			{
				stringBuilder.Append(chunks[i].Text);
			}
			stringBuilder.Append(chunks[endChunkIndex].SubStringToCharIndex(to));
			return stringBuilder.ToString();
		}
		
		private int GetChunkIndexByCindex(Cindex cindex)
		{
			UpdateChunksToCindex(cindex);
			for(int chunkIndex = 0; chunkIndex < chunks.Count; chunkIndex++)
			{
				if(chunks[chunkIndex].Contains(cindex))
					return chunkIndex;
			}
			if(cindex == Length)
				return chunks.Count - 1;
			throw new Exception(String.Format("Cindex {0} not found in DocumentChunkCollection of length {1}.", cindex, Length));
		}
		
/*		private DocumentChunk GetChunkByCindex(Cindex cindex)
		{
			UpdateChunksToCindex(cindex);
			foreach(DocumentChunk chunk in chunks)
			{
				if(chunk.Start >= cindex && chunk.End <= cindex)
					return chunk;
			}
			if(cindex == Length)
				return chunks.Last();
			throw new Exception(String.Format("Cindex {0} not found in DocumentChunkCollection of length {1}.", cindex, Length));
		}	*/

		private void CheckChunkLength(int chunkIndex, DocumentChunk chunk)
		{
			if(chunk.IsEmpty)
			{
				if(chunks.Count > 1)
				{
					chunks.RemoveAt(chunkIndex);
					updatedToChunkIndex--;
				}
			}
			else if(chunk.IsTooLong)
			{
				SplitChunk(chunkIndex, chunk);
			}
			else if(chunk.IsTooShort)
			{
				CombineChunks(chunkIndex, chunk);
			}
		}
		
		private void SplitChunk(int chunkIndex, DocumentChunk chunk)
		{
			List<DocumentChunk> chunksToCheck = new List<DocumentChunk>();
			while(chunk.IsTooLong)
			{
				DocumentChunk secondChunk = chunk.Halve();
				chunks.Insert(chunkIndex+1, secondChunk);
				chunksToCheck.Add(secondChunk);
			}
			foreach(DocumentChunk chunkToCheck in chunksToCheck)
			{
				SplitChunk(chunks.IndexOf(chunkToCheck), chunkToCheck);
			}
		}
		
		private void CombineChunks(int chunkIndex, DocumentChunk chunk)
		{
			if(chunkIndex > 0)
			{
				if(chunks[chunkIndex-1].IsTooShort)
				{
					chunks[chunkIndex-1].Append(chunk);
					chunks.RemoveAt(chunkIndex);
					chunkIndex--;
					chunk = chunks[chunkIndex];
					updatedToChunkIndex = Math.Min(updatedToChunkIndex, chunkIndex);
				}
			}
			if(!chunk.IsTooShort)
				return;
			if(chunkIndex < chunks.Count-1)
			{
				if(chunks[chunkIndex+1].IsTooShort)
				{
					chunk.Append(chunks[chunkIndex+1]);
					chunks.RemoveAt(chunkIndex+1);
				}
			}
		}
		
		private void UpdateAllChunks()
		{
			UpdateChunksToCindex(null);
		}
		
		private void UpdateChunksToCindex(Cindex? cindex)
		{
			for(int chunkIndex = Math.Max(0, updatedToChunkIndex + 1); chunkIndex < chunks.Count; chunkIndex++)
			{
				if(chunkIndex == 0)
					chunks[chunkIndex].Start = 0;
				else
					chunks[chunkIndex].Start = chunks[chunkIndex-1].End + 1;
				updatedToChunkIndex = chunkIndex;
				if(cindex.HasValue && chunks[chunkIndex].End >= cindex)
					return;
			}
		}
		
		public void SaveTXT(StreamWriter stream)
		{
			foreach(DocumentChunk chunk in chunks)
			{
				stream.Write(chunk.Text);
			}
		}
		
		public void LoadTXT(StreamReader stream)
		{
			Initialize();
			char[] buffer = new char[DocumentChunk.UpperChunkLength];
			int readCount = 0;
			while((readCount = stream.Read(buffer, 0, buffer.Length)) > 0)
			{
				if(readCount < buffer.Length)
				{
					chunks.Add(new DocumentChunk((new String(buffer)).Substring(0, readCount)));
				}
				else
				{
					chunks.Add(new DocumentChunk(buffer));
				}
			}
			UpdateAllChunks();
		}
	}
}
