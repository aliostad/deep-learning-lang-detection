using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.IO;

public struct ChunkLoader
{
	public Chunk chunk;
}

public struct ChunkUnloader
{
	public Chunk chunk;
}

public class LevelManager : MonoBehaviour
{
	private string[] OldChunkFilePrefix = { "null" };
	private string[] OldChunkFileSuffixes = { "_Data.chunk" };

	private const string ChunkNameFormat = "{0}_{1}"; //ChunkX, ChunkZ
	private const string ChunkFilePrefix = "Chunk_";
	private const string ChunkFileSuffix = "_Info.chunk";

	private const string ChunkFolder = "Level";

	public int ChunkSize = 16;

	public float GenerationRange = 10f;
	public float LoadingRange = 10f;

	public Dictionary<string, Chunk> LoadedChunks = new Dictionary<string, Chunk>();
	public Dictionary<string, ChunkLoader> LoadingChunks = new Dictionary<string, ChunkLoader>();
	public Dictionary<string, ChunkUnloader> UnloadingChunks = new Dictionary<string, ChunkUnloader>();


	public Dictionary<string, ChunkGenerator> GeneratingChunks = new Dictionary<string, ChunkGenerator>();
	public Dictionary<string, Chunk> GeneratedChunks = new Dictionary<string, Chunk>();

	void Awake()
	{
		ChunkFolderStructure();
		UpdateChunkFileNames();
	}

	private void ChunkFolderStructure()
	{
		if (!Directory.Exists(ChunkSavePath()))
		{
			Directory.CreateDirectory(ChunkSavePath());
		}
	}

	private void UpdateChunkFileNames()
	{
		DirectoryInfo chunkFolder = new DirectoryInfo(ChunkSavePath());
		string tmpFileName = "";
		foreach (var file in chunkFolder.GetFiles())
		{
			tmpFileName = file.Name;
			foreach (var oldChunkFilePrefix in OldChunkFilePrefix)
			{
				//update chunknames from old to new formats
				foreach (var oldChunkFileSuffix in OldChunkFileSuffixes)
				{
					tmpFileName = tmpFileName.Replace(oldChunkFilePrefix, ChunkFilePrefix);
					tmpFileName = tmpFileName.Replace(oldChunkFileSuffix, ChunkFileSuffix);
				}
			}

			if (!tmpFileName.Contains(ChunkFilePrefix))
			{
				tmpFileName = tmpFileName.Insert(0, ChunkFilePrefix);
			}
			if (!tmpFileName.Contains(ChunkFileSuffix))
			{
				tmpFileName = tmpFileName.Insert(tmpFileName.Length - 1, ChunkFileSuffix);
			}
			file.MoveTo(string.Format("{0}/{1}", file.DirectoryName, tmpFileName));
		}
	}

	void Start()
	{
		LoadChunk(0, 0);
	}


	private void LoadChunk(int x, int z)
	{
		//Already loaded or loading
		if (IsChunkLoaded(x, z) && IsChunkLoading(x, z))
			return;

		bool generateChunk = false;
		//Chunk is not loaded yet, check if its generated localy
		Debug.Log(string.Format("Checking chunk folder for {0},{1} : {2}", x, z, ChunkSavePath()));
		if (System.IO.Directory.Exists(ChunkSavePath()))
		{
			Debug.Log(string.Format("Checking chunk file for {0}", ChunkFileSavePath(x, z)));
			if (System.IO.File.Exists(ChunkFileSavePath(x, z)))
			{
				//Chunk was generated sometime before

			}
		}
		if (generateChunk && !IsChunkGenerating(x, z) && !IsChunkGenerating(x, z))
		{
			//Chunk is not generated yet
			StartGeneratingChunk(x, z);
		}
	}

	private void StartGeneratingChunk(int x, int z)
	{
		//Check if we are already generating this chunk
		if (IsChunkGenerated(x, z) || IsChunkGenerating(x, z))
			return;

		ChunkGenerator gen = new ChunkGenerator(x, z, ChunkSize);

		gen.StartGenerating();
		GeneratingChunks.Add(GetChunkKey(x, z), gen);
	}
	private void StartLoadingChunk(int x, int z)
	{
		if (!IsChunkLoading(x, z) && IsChunkGenerated(x, z))
			LoadingChunks.Add(GetChunkKey(x, z), new ChunkLoader() { chunk = GeneratedChunks[GetChunkKey(x, z)] });
	}


	private string GetChunkKey(int x, int z)
	{
		return string.Format(ChunkNameFormat, x, z);
	}

	public bool IsChunkLoaded(int x, int z)
	{
		return LoadedChunks.ContainsKey(GetChunkKey(x, z));
	}

	public bool IsChunkLoading(int x, int z)
	{
		return LoadingChunks.ContainsKey(GetChunkKey(x, z));
	}

	public bool IsChunkUnloading(int x, int z)
	{
		return UnloadingChunks.ContainsKey(GetChunkKey(x, z));
	}

	public bool IsChunkGenerating(int x, int z)
	{
		return GeneratingChunks.ContainsKey(GetChunkKey(x, z));
	}

	public bool IsChunkGenerated(int x, int z)
	{
		return GeneratedChunks.ContainsKey(GetChunkKey(x, z));
	}


	private string ChunkSavePath()
	{
		return string.Format("{0}/{1}", Application.streamingAssetsPath, ChunkFolder);
	}
	private string ChunkFileSavePath(int x, int z)
	{
		return string.Format("{0}/{1}", ChunkSavePath(), GetChunkFileName(x, z));
	}

	private string GetChunkFileName(int x, int z, string nameFormat = ChunkNameFormat, string fileSuffix = ChunkFileSuffix)
	{
		return string.Format("{0}{1}", string.Format(nameFormat, x, z), fileSuffix);
	}
}
