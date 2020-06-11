using UnityEngine;
using System.Collections;

public class ActualPlayerChunk : MonoBehaviour 
{
	public ChunkLength m_chunkLength;
	public GameObject m_player;
	private Vector3 m_playerPosition;	
	private int[] chunkLength = new int[3];
	private bool[] chunkFound = new bool[3];
	private int[] chunkAnzahl = new int[3];	
	private Vector3 actualChunk;	
	void Start () 
	{
		allValuesToStart();		
	}
	/*void Update()
	{
		calculateActualPlayerPosition();		
		calculateActualChunk();
		calculateChunkPosition();
		allValuesToStart();	
	}*/
	public Vector3 GetActualPlayerChunk()
	{
		calculateActualPlayerPosition();		
		calculateActualChunk();
		calculateChunkPosition();
		allValuesToStart();	
		return actualChunk;
	}
	void allValuesToStart()
	{
		chunkLength[0] = m_chunkLength.GetChunkLength(0);
		chunkLength[1] = m_chunkLength.GetChunkLength(1);
		chunkLength[2] = m_chunkLength.GetChunkLength(2);
		for(int i = 0; i < 3; i++)
		{
			chunkFound[i] = false;
			chunkAnzahl[i] = 0;
		}
	}	
	void calculateActualPlayerPosition()
	{		
		m_playerPosition = m_player.transform.position;
	}	
	void calculateActualChunk()
	{		
		while( chunkFound[0] == false || chunkFound[1] == false || chunkFound[2] == false )
		{	
			calculateActualChunkAxis(0, m_playerPosition.x);
			calculateActualChunkAxis(1, m_playerPosition.y);
			calculateActualChunkAxis(2, m_playerPosition.z);
		}		
	}
	void calculateActualChunkAxis(int axis, float playerPositionAxis)
	{		
		if(chunkFound[axis] == false)
		{				
			if((playerPositionAxis < (chunkLength[axis] * chunkAnzahl[axis]) + chunkLength[axis]) && playerPositionAxis > 0)
			{
				chunkFound[axis] = true;					
			}
			if((playerPositionAxis > (-chunkLength[axis] * chunkAnzahl[axis]) - chunkLength[axis]) && playerPositionAxis < 0)
			{						
				chunkFound[axis] = true;
				chunkAnzahl[axis]++;
				chunkLength[axis] = -chunkLength[axis];
			}
			if(chunkFound[axis] == false)
			{
				chunkAnzahl[axis]++;					
			}
		}
		
	}
	void calculateChunkPosition()
	{
		actualChunk = new Vector3(chunkAnzahl[0] * chunkLength[0], chunkAnzahl[1] * chunkLength[1], chunkAnzahl[2] * chunkLength[2]);
		print("actualChunk = " + actualChunk + " m_playerPosition = " + m_playerPosition);
	}
}
