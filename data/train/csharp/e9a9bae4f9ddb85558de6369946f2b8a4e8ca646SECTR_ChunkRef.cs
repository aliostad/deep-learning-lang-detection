// Copyright (c) 2014 Make Code Now! LLC

using UnityEngine;
using System.Collections.Generic;

/// \ingroup Stream
/// Allows for faster finding of loaded chunks.
[AddComponentMenu("")]
public class SECTR_ChunkRef : MonoBehaviour 
{
	#region private details
	static List<SECTR_ChunkRef> allChunkRefs = new List<SECTR_ChunkRef>();
	#endregion

	#region Public Interface
	public static SECTR_ChunkRef FindChunkRef(string chunkName)
	{
		int numChunkRefs = allChunkRefs.Count;
		for(int chunkIndex = 0; chunkIndex < numChunkRefs; ++chunkIndex)
		{
			SECTR_ChunkRef chunkRef = allChunkRefs[chunkIndex];
			if(chunkRef.name == chunkName)
			{
				return chunkRef;
			}
		}
		return null;
	}

	public Transform RealSector = null;

	public bool Recentered = false;
	#endregion

	#region Unity Interface
	void OnEnable()
	{
		allChunkRefs.Add(this);
	}

	void OnDisable()
	{
		allChunkRefs.Remove(this);
	}
	#endregion
}
