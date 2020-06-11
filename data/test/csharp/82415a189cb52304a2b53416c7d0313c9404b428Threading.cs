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
		ChunkQueue UnloadQueue;

		public SetupThread()
		{
			LoadQueue = new ChunkQueue();
			GenerationQueue = new ChunkQueue();
			VegetationQueue = new ChunkQueue();
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

		public void AddToUnload(Chunk chunk)
		{
			if (!LoadQueue.Contains(chunk))
			{
				UnloadQueue.Enqueue(chunk);
			}

			LoadQueue.Remove(chunk);
			GenerationQueue.Remove(chunk);
			VegetationQueue.Remove(chunk);
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
						ChunkManager.SaveChunk(currentChunk);
					}
					else
					{
						currentChunk = null;
					}
					Console.Write("UnloadQueue: " + UnloadQueue.Count);

					// End Unload Chunk

					LoadQueue.Remove(currentChunk);
					GenerationQueue.Remove(currentChunk);
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

					Console.Write("LoadQueue: " + LoadQueue.Count);

					// End Load Chunk
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
				}
			}
		}
	}
}
