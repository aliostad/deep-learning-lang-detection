using UnityEngine;
using System.Collections.Generic; // for Dictionary<>
using System;

//------------------------------------------------------------------------------
public class WorldManager : MonoBehaviour {
	
	//**************************************************************************
	// Public Inspector Variables
	//**************************************************************************
	
	public Vector2 worldChunkSize = new Vector2(15.0f, 10.0f);
	public uint    chunkBlockSize = 3u;
	
	//**************************************************************************
	// Private Variables
	//**************************************************************************

	private WorldChunkTable _chunkCache  = null;
	private Vector2 		_spawnPoint  = Vector2.zero;
	private WorldChunkIndex _currentIndx = WorldChunkIndex.Origin;
	
	//**************************************************************************
	// Public Getter/Setters
	//**************************************************************************
	
	//--------------------------------------------------------------------------
	public Vector2 SpawnPoint
	{
		get { return _spawnPoint; }
	}
	
	//--------------------------------------------------------------------------
	public string RootChunk
	{
		set
		{
			 DebugUtils.Assert(_chunkCache != null);
			_chunkCache.LoadWorldChunk(value, WorldChunkIndex.Origin);
		}
	}
	
	//**************************************************************************
	// Inherited (Unity) Methods
	//**************************************************************************
	
	//--------------------------------------------------------------------------
	// Use this for initialization
	void Start () {
		
		 DebugUtils.Assert(_chunkCache == null);
		_chunkCache = new WorldChunkTable(worldChunkSize);

        // load area, and maybe index?
        SetFocusedChunk("area_01-01", _currentIndx);
	}

    //--------------------------------------------------------------------------
    public void TransitionToChunk(WorldDirection chunkDir, string sceneName)
    {
        WorldChunkIndex newChunkIndex = _currentIndx + WorldDirectionUtils.GetWorldChunkOffset(chunkDir);

        // make sure we have the chunk cached (else, we should be warping)
        WorldChunk newChunk = _chunkCache[newChunkIndex];
        DebugUtils.Assert(newChunk != null, "WorldManager::Transition() - '{0}' was not cached at ({1},{2}), try calling WarpToChunk() instead.",
            sceneName, newChunkIndex.x, newChunkIndex.y);

        // switch focus to the new chunk
        newChunk.AddLoadCompleteDelegate(delegate(string loadedSceneName) {
            DebugUtils.Assert(loadedSceneName == sceneName, "WorldManager::Transition() - '{0}' was not the chunk we found at ({1},{2}), '{3}' was",
                sceneName, newChunkIndex.x, newChunkIndex.y, loadedSceneName);

            SetFocusedChunk(sceneName, newChunkIndex);
        });
    }
	
	//**************************************************************************
	// Private Methods
	//**************************************************************************
	
	//--------------------------------------------------------------------------
	private WorldChunk LoadChunkBlock(int    chunkX,
								      int    chunkY,
							          string chunkName,
								      int    leftPadding,
		 						      int    rightPadding,
                                      int    upperPadding,
                                      int    lowerPadding)
	{
		if (chunkName == null)
			return null;

		WorldChunk chunk = _chunkCache.LoadWorldChunk(chunkName, new WorldChunkIndex(chunkX, chunkY));

        Action<string> loadDelegate = delegate(string sceneName) {
            DebugUtils.Assert(chunk.isValid);

            if (leftPadding > 0)
                LoadChunkBlock(chunkX - 1, chunkY, chunk[WorldDirection.Left], leftPadding - 1, 0, upperPadding, lowerPadding);
            if (rightPadding > 0)
                LoadChunkBlock(chunkX + 1, chunkY, chunk[WorldDirection.Right], 0, rightPadding - 1, upperPadding, lowerPadding);
            if (upperPadding > 0)
                LoadChunkBlock(chunkX, chunkY - 1, chunk[WorldDirection.Up], leftPadding, rightPadding, upperPadding - 1, 0);
            if (lowerPadding > 0)
                LoadChunkBlock(chunkX, chunkY + 1, chunk[WorldDirection.Down], leftPadding, rightPadding, 0, lowerPadding - 1);
        };
        chunk.AddLoadCompleteDelegate(loadDelegate);

        return chunk;
	}

    //--------------------------------------------------------------------------
    private void SetFocusedChunk(string chunkName, WorldChunkIndex atIndex)
    {
        //--------------------------------------
        // deactivate old chunk block
        //--------------------------------------

        WorldChunk oldChunk = _chunkCache[_currentIndx];
        if (oldChunk != null)
        {
            oldChunk.AddLoadCompleteDelegate(delegate(string sceneName) {
                oldChunk.focused = false;
            });
        }
        _chunkCache.SetChunkBlockActive(_currentIndx, false, chunkBlockSize, chunkBlockSize);

        //--------------------------------------
        // load new chunk block
        //--------------------------------------

        int leftOffset   = ((int)chunkBlockSize - 1) / 2;
        int rightOffset  = (int)Math.Ceiling((chunkBlockSize - 1) / 2.0f);
        int topOffset    = leftOffset;
        int bottomOffset = rightOffset;

        WorldChunk focusedChunk = LoadChunkBlock(atIndex.x, atIndex.y, chunkName, leftOffset, rightOffset, topOffset, bottomOffset);

        //--------------------------------------
        // shift camera & chunk index
        //--------------------------------------

        focusedChunk.AddLoadCompleteDelegate(delegate(string sceneName) {

            focusedChunk.focused = true;

            Vector3 newCamPos = focusedChunk.root.transform.position;
            newCamPos.z = WorldZLayers.kCameraZLayer;
            Camera.mainCamera.transform.position = newCamPos;

            _currentIndx = atIndex;
        });
        _chunkCache.SetChunkBlockActive(atIndex, true, chunkBlockSize, chunkBlockSize);

    }
}
