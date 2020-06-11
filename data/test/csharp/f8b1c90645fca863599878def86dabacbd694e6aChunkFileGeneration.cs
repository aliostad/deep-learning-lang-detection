using UnityEngine;
using System.Collections;
using System.IO;

public class ChunkFileGeneration : MonoBehaviour 
{
	public ChunkLength m_chunkLength;
	public BlockIDGenerator m_blockIDGenerator;
	private int[] chunkLength = new int[3];
	
	public void generateChunkFile(Vector3 chunkVectorOriginal)
	{
		Vector3 chunkVectorCopy = chunkVectorOriginal;
		chunkLength[0] = m_chunkLength.GetChunkLength(0);
		chunkLength[1] = m_chunkLength.GetChunkLength(1);
		chunkLength[2] = m_chunkLength.GetChunkLength(2);		
		StreamWriter chunkWriter = File.CreateText(@"" + chunkVectorOriginal + ".txt");
		for(int i = 0; i < chunkLength[0]; i++)
		{			
			for(int j = 0; j < chunkLength[1]; j++)
			{				
				for(int k = 0; k < chunkLength[2]; k++)
				{					
					//Block in Liste Speichern.					
					chunkWriter.WriteLine(chunkVectorCopy + "," + m_blockIDGenerator.GetBlockID());					
					chunkVectorCopy.z ++;
				}
				chunkVectorCopy.z = chunkVectorOriginal.z;
				chunkVectorCopy.y ++;
			}
			chunkVectorCopy.y = chunkVectorOriginal.y;
			chunkVectorCopy.x ++;
		}
		chunkVectorCopy.x = chunkVectorOriginal.x;
		chunkWriter.Close();
	} 
}
