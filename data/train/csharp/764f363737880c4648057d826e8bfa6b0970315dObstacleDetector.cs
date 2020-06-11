using UnityEngine;
using System.Collections.Generic;
using System.Collections;
namespace MTB
{
	public class ObstacleDetector : MonoBehaviour {
		public bool inCollision;
		private List<Chunk> chunkList;

		void Start()
		{
			chunkList = new List<Chunk>();
			EventManager.RegisterEvent(EventMacro.CHUNK_RENDER_START,OnChunkRenderStart);
		}

		void OnDestroy()
		{
			EventManager.UnRegisterEvent(EventMacro.CHUNK_RENDER_START,OnChunkRenderStart);
		}

		private void OnChunkRenderStart(object[] param)
		{
			Chunk chunk = param[0] as Chunk;
			if(chunkList.Contains(chunk))
			{
				chunkList.Remove(chunk);
				UpdateIsCollision();
			}
		}

		private void UpdateIsCollision()
		{
			if(chunkList.Count > 0)
			{
				inCollision = true;
			}
			else
			{
				inCollision = false;
			}
		}

		void OnTriggerEnter(Collider col)
		{
	//		Debug.Log ("OnTrigerEnter~~~~~~~~:" + gameObject.name);
			//			inCollision = true;
			ChunkObj chunkObj = col.GetComponentInParent<ChunkObj>();
			if(chunkObj == null)return;
			if(!chunkList.Contains(chunkObj.chunk))
			{
				chunkList.Add(chunkObj.chunk);
				UpdateIsCollision();
			}
		}

		void OnTriggerExit (Collider col)
		{
	//		Debug.Log ("OnTrigerExit~~~~~~~~:" + gameObject.name);
//			inCollision = false;
			ChunkObj chunkObj = col.GetComponentInParent<ChunkObj>();
			if(chunkObj == null)return;
			if(chunkList.Contains(chunkObj.chunk))
			{
				chunkList.Remove(chunkObj.chunk);
				UpdateIsCollision();
			}
		}
	}
}
