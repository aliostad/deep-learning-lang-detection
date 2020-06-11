using UnityEngine;

public class MapTester : MonoBehaviour
{
	// Use this for initialization
	void Start ()
    {
        Tile[][][] map = new Tile[32][][];
        for(int i = 0; i < 32; i++)
        {
            map[i] = new Tile[16][];
            for(int j = 0; j < 16; j++)
            {
                map[i][j] = new Tile[16];
                for(int k = 0; k < 16; k++ )
                {
                    map[i][j][k] = new Tile();
                    if((j+k)%2 == 0 )
                    {
                        map[i][j][k].ID = 1;
                    }
                    else
                    {
                        map[i][j][k].ID = 2;
                    }
                }
            }
        }
        Chunk chunk = new Chunk(map);
        ChunkSet c = ChunkSet.NewBuilder()
                             .Add(chunk)
                             .Add(chunk)
                             .Add(chunk)
                             .Add(chunk)
                             .Add(chunk)
                             .Add(chunk)
                             .Add(chunk)
                             .Add(chunk)
                             .Add(chunk)
                             .Build();
        MapManager.instance.Reload(c);
	}
}
