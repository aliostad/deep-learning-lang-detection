using System;
using System.IO;
using System.Linq;
using System.Text;
using System.Collections.Generic;
using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Input;
using Microsoft.Xna.Framework.Media;
using Microsoft.Xna.Framework.Audio;
using Microsoft.Xna.Framework.Content;
using Microsoft.Xna.Framework.Graphics;
using Microsoft.Xna.Framework.GamerServices;
using Umbra.Engines;
using Umbra.Utilities;
using Umbra.Structures;
using Umbra.Definitions;
using Umbra.Implementations;
using Umbra.Definitions.Globals;
using Console = Umbra.Implementations.Console;


namespace Umbra.Implementations
{
    public class SetupThread
    {
        ChunkQueue LoadQueue;
        ChunkQueue GenerationQueue;
        ChunkQueue VegetationQueue;
        ChunkQueue BuildQueue;
        ChunkQueue SetupQueue;
        ChunkQueue UnloadQueue;

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
            LoadQueue = new ChunkQueue();
            GenerationQueue = new ChunkQueue();
            VegetationQueue = new ChunkQueue();
            BuildQueue = new ChunkQueue();
            SetupQueue = new ChunkQueue();
            UnloadQueue = new ChunkQueue();

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
                    Console.Write("UnloadQueue: " + GenerationQueue.Count);

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

                    Console.Write("LoadQueue: " + GenerationQueue.Count);

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

                    LandscapeGenerator.SetChunkTerrain(currentChunk);

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

                    if (VegetationQueue.Count == 0 && !Constants.Engine_Physics.Player.IsReleased)
                    {
                        Constants.Engine_Physics.Player.Release();
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
