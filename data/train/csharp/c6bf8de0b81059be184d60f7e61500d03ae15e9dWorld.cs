using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class World : MonoBehaviour
{
	public const int size = 4;

	GameObject worldGO;
	public Chunk[] Chunks;

	void Start()
	{
		Chunks = new Chunk[ size * size * size ];

		worldGO = new GameObject( "World" );

		GenerateWorld();
		FullWorldAOBake();
	}

	void GenerateWorld()
	{
		for( int x = 0; x < size; x++ )
		{
			for( int y = 0; y < size; y++ )
			{
				for( int z = 0; z < size; z++ )
				{
					var chunk = CreateChunk( x, y, z );

					chunk.transform.parent = worldGO.transform;
					
					Chunks[ GetChunkIndex( x, y, z ) ] = chunk;
				}
			}
		}
	}

	Chunk CreateChunk( int x, int y, int z )
	{
		var chunkGO = new GameObject( string.Format( "Chunk-{0},{1},{2}", x, y, z ) );
		var chunkMB = chunkGO.AddComponent< Chunk >();

		chunkMB.ConstructDummyChunk();

		chunkMB.WorldPosition = new WorldPosition( x * Chunk.size, y * Chunk.size, z * Chunk.size );
		
		chunkGO.transform.localPosition = new Vector3( x * Chunk.size, y * Chunk.size, z * Chunk.size );
		
		return chunkMB;
	}

	void FullWorldAOBake()
	{
		AOCalculation.Initialise( this );

		foreach( var chunk in Chunks )
		{
			AOCalculation.ExecuteOnChunk( chunk );
		}
	}

	int GetChunkIndex( int x, int y, int z )
	{
		return x + ( y * size ) + ( z * size * size );
	}

	public Chunk WorldCoordinatesToChunk( WorldPosition worldPosition )
	{
		if( worldPosition.WorldX < 0 || worldPosition.WorldY < 0 || worldPosition.WorldZ < 0 )
			return null;

		int chunkX = worldPosition.WorldX / Chunk.size;
		int chunkY = worldPosition.WorldY / Chunk.size;
		int chunkZ = worldPosition.WorldZ / Chunk.size;

		if( chunkX >= size || chunkY >= size || chunkZ >= size )
			return null;

		return Chunks[ GetChunkIndex( chunkX, chunkY, chunkZ ) ];
	}

	public Cube WorldCoordinatesToCube( WorldPosition worldPosition )
	{
		var chunk = WorldCoordinatesToChunk( worldPosition );

		if( chunk == null )
			return null;

		int chunkX = worldPosition.WorldX % Chunk.size;
		int chunkY = worldPosition.WorldY % Chunk.size;
		int chunkZ = worldPosition.WorldZ % Chunk.size;

		return chunk.GetCubeAtChunkPosition( chunkX, chunkY, chunkZ );
	}
}
