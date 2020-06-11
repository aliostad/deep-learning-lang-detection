using UnityEngine;
using System.Collections.Generic;

public class WorldManager : MonoBehaviour {

    public List<WorldChunk> m_allChunks;

    public CurrentViewMgr m_currentViewInstance;

	// Use this for initialization
	void Start () {
        
	}
	
	// Update is called once per frame
	void Update () 
    {
        
	}

    public void TickWorlds(float deltaTime)
    {
        foreach (WorldChunk chunk in m_allChunks)
        {
            if (chunk == m_currentViewInstance.m_currentChunk)
            {
                chunk.UpdateChunk(deltaTime, AI_LOD.HIGH);
            }
            else
            {
                chunk.UpdateChunk(deltaTime, AI_LOD.MEDIUM);
            }
        }
    }

    public bool AddChunk(WorldChunk newChunk)
    {
        if (m_allChunks.Contains(newChunk))
        {
            return false;
        }

        m_allChunks.Add(newChunk);
        return true;
    }

    void Awake()
    {
        m_allChunks = new List<WorldChunk>(9);

        WorldChunk newChunk = new WorldChunk();
        AddChunk(newChunk);

        m_currentViewInstance.m_currentChunk = newChunk;
    }
}
