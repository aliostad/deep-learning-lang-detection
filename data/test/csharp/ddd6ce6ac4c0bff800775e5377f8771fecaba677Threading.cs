using System;
using System.Linq;
using System.Text;
using System.Threading;
using System.Collections.Generic;
using OpenTK;
using OpenTK.Audio;
using OpenTK.Input;
using OpenTK.Graphics;
using OpenTK.Platform;
using OpenTK.Audio.OpenAL;
using OpenTK.Graphics.OpenGL;
using Umbra.Engines;
using Umbra.Utilities;
using Umbra.Structures;
using Umbra.Definitions;
using Umbra.Implementations;
using Umbra.Utilities.Landscape;
using Umbra.Structures.Geometry;
using Umbra.Definitions.Globals;
using Console = Umbra.Implementations.Graphics.Console;

namespace Umbra.Utilities.Threading
{
	public class SetupThread
	{
		ChunkQueue LoadQueue;
		ChunkQueue GenerationQueue;
		ChunkQueue VegetationQueue;
		ChunkQueue BuildQueue;
		ChunkQueue SetupQueue;
		ChunkQueue UnloadQueue;

		public SetupThread()
		{
			LoadQueue = new ChunkQueue();
			GenerationQueue = new ChunkQueue();
			VegetationQueue = new ChunkQueue();
			BuildQueue = new ChunkQueue();
			SetupQueue = new ChunkQueue();
			UnloadQueue = new ChunkQueue();
		}

		public void AddToLoad(Chunk chunk)
		{
			LoadQueue.Enqueue(chunk);
		}

		public void AddToGeneration(Chunk chunk)
		{
			GenerationQueue.Enqueue(chunk);
		}

		public void AddToVegetation(Chunk chunk)
		{
			VegetationQueue.Enqueue(chunk);
		}

		public void AddToBuild(Chunk chunk)
		{
			BuildQueue.Enqueue(chunk);
		}

		public void AddToSetup(Chunk chunk)
		{
			SetupQueue.AddSorted(chunk);
		}

		public void AddToUnload(Chunk chunk)
		{
			if (!LoadQueue.Contains(chunk))
			{
				UnloadQueue.Enqueue(chunk);
			}

			LoadQueue.Remove(chunk);
			GenerationQueue.Remove(chunk);
			VegetationQueue.Remove(chunk);
			BuildQueue.Remove(chunk);
			SetupQueue.Remove(chunk);

			chunk.WillBeUnloaded = true;
		}

		public void Run()
		{
			Chunk currentChunk;
			while (true)
			{
				if (!Variables.Game.IsInitialized)
				{
					continue;
				}

				if (UnloadQueue.Count > 0)
				{
					currentChunk = UnloadQueue.Dequeue();

					if (currentChunk == null)
					{
						continue;
					}

					// Unload Chunk
					if (Constants.World.SaveDynamicWorld)
					{
						ChunkManager.StoreChunkImmediate(currentChunk);
					}
					else
					{
						currentChunk = null;
					}
					Console.Write("UnloadQueue: " + UnloadQueue.Count);

					// End Unload Chunk

					LoadQueue.Remove(currentChunk);
					GenerationQueue.Remove(currentChunk);
					SetupQueue.Remove(currentChunk);
				}
				else if (LoadQueue.Count > 0)
				{
					currentChunk = LoadQueue.Dequeue();

					if (currentChunk == null)
					{
						continue;
					}

					// Load Chunk

					ChunkManager.LoadChunkImmediate(currentChunk);
					currentChunk.BuildOctree();
					currentChunk.HasData = true;

					Console.Write("LoadQueue: " + LoadQueue.Count);

					// End Load Chunk

					if (SetupQueue.Contains(currentChunk))
					{
						SetupQueue.Remove(currentChunk);
						SetupQueue.Enqueue(currentChunk);
					}
					else
					{
						SetupQueue.Enqueue(currentChunk);
					}
				}
				else if (GenerationQueue.Count > 0)
				{
					currentChunk = GenerationQueue.Dequeue();

					if (currentChunk == null)
					{
						continue;
					}

					// Generate Chunk

					TerrainGenerator.SetChunkTerrain(currentChunk);

					Console.Write("GenerationQueue: " + GenerationQueue.Count);

					// End Generate Chunk

					if (VegetationQueue.Contains(currentChunk))
					{
						VegetationQueue.Remove(currentChunk);
						VegetationQueue.Enqueue(currentChunk);
					}
					else
					{
						AddToVegetation(currentChunk);
					}
				}
				else if (VegetationQueue.Count > 0)
				{
					currentChunk = VegetationQueue.Dequeue();

					if (currentChunk == null)
					{
						continue;
					}

					// Vegetate Chunk

					Vegetation.Vegetate(currentChunk);

					Console.Write("VegetationQueue: " + VegetationQueue.Count);

					// End Vegetate Chunk

					if (BuildQueue.Contains(currentChunk))
					{
						BuildQueue.Remove(currentChunk);
						BuildQueue.Enqueue(currentChunk);
					}
					else
					{
						AddToBuild(currentChunk);
					}

					if (VegetationQueue.Count == 0 && !Constants.Engines.Physics.Player.IsReleased)
					{
						Constants.Engines.Physics.Player.Release();
					}
				}
				else if (BuildQueue.Count > 0)
				{
					currentChunk = BuildQueue.Dequeue();

					if (currentChunk == null)
					{
						continue;
					}

					// Build Chunk

					currentChunk.BuildOctree();
					currentChunk.HasData = true;

					Console.Write("BuildQueue: " + BuildQueue.Count);

					// End Build Chunk

					if (SetupQueue.Contains(currentChunk))
					{
						SetupQueue.Remove(currentChunk);
						SetupQueue.Enqueue(currentChunk);
					}
					else
					{
						AddToSetup(currentChunk);
					}
				}
				else if (SetupQueue.Count > 0)
				{
					currentChunk = SetupQueue.Dequeue();

					if (currentChunk == null)
					{
						continue;
					}
					currentChunk.SetupState = 4;

					// Setup Chunk

					currentChunk.BuildGeometry(false);
					currentChunk.SetupState = 1;

					Console.Write("SetupQueue: " + SetupQueue.Count);
					// End Setup Chunk
				}
			}
		}
	}
}
