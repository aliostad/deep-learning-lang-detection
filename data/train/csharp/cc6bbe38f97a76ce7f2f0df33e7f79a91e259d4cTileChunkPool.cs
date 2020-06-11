using UnityEngine;
using System.Collections;
using System.Collections.Generic;

namespace CreativeSpore.RpgMapEditor
{

    /// <summary>
    /// Manages the creation of all map tile chunks
    /// </summary>
	public class TileChunkPool : MonoBehaviour 
	{
        /// <summary>
        /// The witdth size of the generated tilechunks in tiles ( due max vertex limitation, this should be less than 62 )
        /// </summary>
		public const int k_TileChunkWidth = 62;

        /// <summary>
        /// The height size of the generated tilechunks in tiles ( due max vertex limitation, this should be less than 62 )
        /// </summary>
		public const int k_TileChunkHeight = 62;

		[System.Serializable]
		public class TileChunkLayer
		{
			public GameObject ObjNode;
			public TileChunk[] TileChunks;
		}

		public List<TileChunkLayer> TileChunkLayers = new List<TileChunkLayer>();

		private List<TileChunk> m_tileChunkToBeUpdated = new List<TileChunk>();
		[SerializeField]
		private AutoTileMap m_autoTileMap;

		public void Initialize (AutoTileMap autoTileMap)
		{
			hideFlags = HideFlags.NotEditable;
			m_autoTileMap = autoTileMap;
			foreach( TileChunkLayer tileChunkLayer in TileChunkLayers )
			{
				if( tileChunkLayer.ObjNode != null )
				{
				#if UNITY_EDITOR
					DestroyImmediate(tileChunkLayer.ObjNode);
				#else
					Destroy(tileChunkLayer.ObjNode);
				#endif
				}
			}
			TileChunkLayers.Clear();
			m_tileChunkToBeUpdated.Clear();
		}

        /// <summary>
        /// Mark a tile to be updated during update
        /// </summary>
        /// <param name="tileX"></param>
        /// <param name="tileY"></param>
        /// <param name="layer"></param>
		public void MarkUpdatedTile( int tileX, int tileY, int layer )
		{
			TileChunk tileChunk = _GetTileChunk( tileX, tileY, layer );
			if( !m_tileChunkToBeUpdated.Contains(tileChunk) )
			{
				m_tileChunkToBeUpdated.Add( tileChunk );
			}
		}

        /// <summary>
        /// Update marked chunks
        /// </summary>
		public void UpdateChunks()
		{
			while( m_tileChunkToBeUpdated.Count > 0 )
			{
				m_tileChunkToBeUpdated[0].RefreshTileData();
				m_tileChunkToBeUpdated.RemoveAt(0);
			}
		}

		public void UpdateLayerPositions ()
		{
			for( int i = 0; i < TileChunkLayers.Count; ++i )
			{
				TileChunkLayers[i].ObjNode.transform.position = m_autoTileMap.TileLayerPosition[i];
			}
		}

		private TileChunk _GetTileChunk( int tileX, int tileY, int layer )
		{
			TileChunkLayer chunkLayer = _GetTileChunkLayer( layer );

			int rowTotalChunks = 1 + ((m_autoTileMap.MapTileWidth - 1) / k_TileChunkWidth);
			int chunkIdx = (tileY / k_TileChunkHeight) * rowTotalChunks + (tileX / k_TileChunkWidth);
			TileChunk tileChunk = chunkLayer.TileChunks[chunkIdx];
			if( tileChunk == null )
			{
				int startTileX = tileX - tileX % k_TileChunkWidth;
				int startTileY = tileY - tileY % k_TileChunkHeight;
				GameObject chunkObj = new GameObject();
				chunkObj.name = "TileChunk"+startTileX+"_"+startTileY;
				chunkObj.transform.parent = chunkLayer.ObjNode.transform;
				chunkObj.hideFlags = HideFlags.NotEditable;
				tileChunk = chunkObj.AddComponent<TileChunk>();
				chunkLayer.TileChunks[chunkIdx] = tileChunk;
				tileChunk.Configure( m_autoTileMap, layer, startTileX, startTileY, k_TileChunkWidth, k_TileChunkHeight );
			}
			return tileChunk;
		}

		private TileChunkLayer _GetTileChunkLayer( int layer )
		{
			return TileChunkLayers.Count > layer? TileChunkLayers[layer] : _CreateTileChunkLayer( layer );
		}

		private TileChunkLayer _CreateTileChunkLayer( int layer )
		{
			int rowTotalChunks = 1 + ((m_autoTileMap.MapTileWidth - 1) / k_TileChunkWidth);
			int colTotalChunks = 1 + ((m_autoTileMap.MapTileHeight - 1) / k_TileChunkHeight);
			int totalChunks = rowTotalChunks * colTotalChunks;
			TileChunkLayer chunkLayer = null;
			while( TileChunkLayers.Count <= layer )
			{
				chunkLayer = new TileChunkLayer();
				chunkLayer.TileChunks = new TileChunk[ totalChunks ];
				chunkLayer.ObjNode = new GameObject();
				chunkLayer.ObjNode.transform.parent = transform;
				chunkLayer.ObjNode.transform.position = m_autoTileMap.TileLayerPosition[layer];
				chunkLayer.ObjNode.name = ""+TileChunkLayers.Count;
				TileChunkLayers.Add( chunkLayer );
			}
			return chunkLayer;
		}
	}
}