using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Threading;

public class ChunksMeshGenerator {
  static object chunksQueueLock = new object();

  class ChunkDone {
    public Chunk chunk;
    public List<Vector3> vertices;
    public List<Vector2> uvs;
    public List<Vector3> normals;
    public List<int> indicies;
  }
  static Stack<ChunkDone> chunksQueue = new Stack<ChunkDone>();

  public static void Update() {
    lock (chunksQueueLock) {
      if (chunksQueue.Count > 0) {
        ChunkDone chunkDone = chunksQueue.Pop();

        Mesh mesh = new Mesh();
        mesh.vertices = chunkDone.vertices.ToArray();
        mesh.uv = chunkDone.uvs.ToArray();
        mesh.normals = chunkDone.normals.ToArray();
        mesh.triangles = chunkDone.indicies.ToArray();
    
        chunkDone.chunk.meshFilter.mesh = mesh;
        chunkDone.chunk.meshCollider.sharedMesh = mesh;
        chunkDone.chunk.meshRenderer.sharedMaterial = chunkDone.chunk.world.material;

        chunkDone.chunk.status = Chunk.Status.Done;
      }
    }
  }

  public static void PushChunk(Chunk chunk) {
    chunk.status = Chunk.Status.Creating;

    ThreadPool.QueueUserWorkItem(ChunkWorkerCallback, chunk);
  }

  // NOT FUCKING THREAD SAFE
  public static void ChunkWorkerCallback(object threadContext) {
    int startTime = System.DateTime.Now.Millisecond;

    Chunk chunk = (Chunk)threadContext;
    List<Vector3> vertices = new List<Vector3>(Chunk.SIZE * Chunk.SIZE * Chunk.SIZE * 24);
    List<Vector2> uvs = new List<Vector2>(Chunk.SIZE * Chunk.SIZE * Chunk.SIZE * 24);
    List<Vector3> normals = new List<Vector3>(Chunk.SIZE * Chunk.SIZE * Chunk.SIZE * 24);
    List<int> indicies = new List<int>(Chunk.SIZE * Chunk.SIZE * Chunk.SIZE * 36);

    float tileSize = World.TextureTileSize;

    int currentIndex = 0;

    for (int x = 0; x < Chunk.SIZE; ++x) {
      for (int y = 0; y < Chunk.SIZE; ++y) {
        for (int z = 0; z < Chunk.SIZE; ++z) {
          if (chunk.blocks[x, y, z] == 0)
            continue;

          int worldBlockX = chunk.worldChunkPositionX * Chunk.SIZE + x;
          int worldBlockY = chunk.worldChunkPositionY * Chunk.SIZE + y;
          int worldBlockZ = chunk.worldChunkPositionZ * Chunk.SIZE + z;

          int blockID = chunk.blocks[x, y, z] - 1;

          float tilePosX = blockID;
          float tilePosY = 0;

          // front
          if (chunk.world.GetBlock(worldBlockX, worldBlockY, worldBlockZ - 1) == 0) {
            vertices.Add(new Vector3((x * Chunk.VOXEL_SIZE) - Chunk.VOXEL_SIZE_HALF, (y * Chunk.VOXEL_SIZE) - Chunk.VOXEL_SIZE_HALF, (z * Chunk.VOXEL_SIZE) - Chunk.VOXEL_SIZE_HALF));
            vertices.Add(new Vector3((x * Chunk.VOXEL_SIZE) - Chunk.VOXEL_SIZE_HALF, (y * Chunk.VOXEL_SIZE) + Chunk.VOXEL_SIZE_HALF, (z * Chunk.VOXEL_SIZE) - Chunk.VOXEL_SIZE_HALF));
            vertices.Add(new Vector3((x * Chunk.VOXEL_SIZE) + Chunk.VOXEL_SIZE_HALF, (y * Chunk.VOXEL_SIZE) + Chunk.VOXEL_SIZE_HALF, (z * Chunk.VOXEL_SIZE) - Chunk.VOXEL_SIZE_HALF));
            vertices.Add(new Vector3((x * Chunk.VOXEL_SIZE) + Chunk.VOXEL_SIZE_HALF, (y * Chunk.VOXEL_SIZE) - Chunk.VOXEL_SIZE_HALF, (z * Chunk.VOXEL_SIZE) - Chunk.VOXEL_SIZE_HALF));

            uvs.Add(new Vector2(tilePosX * tileSize, tilePosY * tileSize));
            uvs.Add(new Vector2(tilePosX * tileSize + tileSize, tilePosY * tileSize));
            uvs.Add(new Vector2(tilePosX * tileSize + tileSize, tilePosY * tileSize + tileSize));
            uvs.Add(new Vector2(tilePosX * tileSize, tilePosY * tileSize + tileSize));

            normals.Add(new Vector3(0, 0, -1));
            normals.Add(new Vector3(0, 0, -1));
            normals.Add(new Vector3(0, 0, -1));
            normals.Add(new Vector3(0, 0, -1));

            indicies.Add(currentIndex + 0);
            indicies.Add(currentIndex + 1);
            indicies.Add(currentIndex + 2);

            indicies.Add(currentIndex + 2);
            indicies.Add(currentIndex + 3);
            indicies.Add(currentIndex + 0);

            currentIndex += 4;
          }

          // back
          if (chunk.world.GetBlock(worldBlockX, worldBlockY, worldBlockZ + 1) == 0) {
            vertices.Add(new Vector3((x * Chunk.VOXEL_SIZE) - Chunk.VOXEL_SIZE_HALF, (y * Chunk.VOXEL_SIZE) - Chunk.VOXEL_SIZE_HALF, (z * Chunk.VOXEL_SIZE) + Chunk.VOXEL_SIZE_HALF));
            vertices.Add(new Vector3((x * Chunk.VOXEL_SIZE) - Chunk.VOXEL_SIZE_HALF, (y * Chunk.VOXEL_SIZE) + Chunk.VOXEL_SIZE_HALF, (z * Chunk.VOXEL_SIZE) + Chunk.VOXEL_SIZE_HALF));
            vertices.Add(new Vector3((x * Chunk.VOXEL_SIZE) + Chunk.VOXEL_SIZE_HALF, (y * Chunk.VOXEL_SIZE) + Chunk.VOXEL_SIZE_HALF, (z * Chunk.VOXEL_SIZE) + Chunk.VOXEL_SIZE_HALF));
            vertices.Add(new Vector3((x * Chunk.VOXEL_SIZE) + Chunk.VOXEL_SIZE_HALF, (y * Chunk.VOXEL_SIZE) - Chunk.VOXEL_SIZE_HALF, (z * Chunk.VOXEL_SIZE) + Chunk.VOXEL_SIZE_HALF));

            uvs.Add(new Vector2(tilePosX * tileSize, tilePosY * tileSize));
            uvs.Add(new Vector2(tilePosX * tileSize + tileSize, tilePosY * tileSize));
            uvs.Add(new Vector2(tilePosX * tileSize + tileSize, tilePosY * tileSize + tileSize));
            uvs.Add(new Vector2(tilePosX * tileSize, tilePosY * tileSize + tileSize));

            normals.Add(new Vector3(0, 0, 1));
            normals.Add(new Vector3(0, 0, 1));
            normals.Add(new Vector3(0, 0, 1));
            normals.Add(new Vector3(0, 0, 1));

            indicies.Add(currentIndex + 0);
            indicies.Add(currentIndex + 2);
            indicies.Add(currentIndex + 1);

            indicies.Add(currentIndex + 3);
            indicies.Add(currentIndex + 2);
            indicies.Add(currentIndex + 0);

            currentIndex += 4;
          }

          // top
          if (chunk.world.GetBlock(worldBlockX, worldBlockY + 1, worldBlockZ) == 0) {
            vertices.Add(new Vector3((x * Chunk.VOXEL_SIZE) - Chunk.VOXEL_SIZE_HALF, (y * Chunk.VOXEL_SIZE) + Chunk.VOXEL_SIZE_HALF, (z * Chunk.VOXEL_SIZE) - Chunk.VOXEL_SIZE_HALF));
            vertices.Add(new Vector3((x * Chunk.VOXEL_SIZE) - Chunk.VOXEL_SIZE_HALF, (y * Chunk.VOXEL_SIZE) + Chunk.VOXEL_SIZE_HALF, (z * Chunk.VOXEL_SIZE) + Chunk.VOXEL_SIZE_HALF));
            vertices.Add(new Vector3((x * Chunk.VOXEL_SIZE) + Chunk.VOXEL_SIZE_HALF, (y * Chunk.VOXEL_SIZE) + Chunk.VOXEL_SIZE_HALF, (z * Chunk.VOXEL_SIZE) + Chunk.VOXEL_SIZE_HALF));
            vertices.Add(new Vector3((x * Chunk.VOXEL_SIZE) + Chunk.VOXEL_SIZE_HALF, (y * Chunk.VOXEL_SIZE) + Chunk.VOXEL_SIZE_HALF, (z * Chunk.VOXEL_SIZE) - Chunk.VOXEL_SIZE_HALF));

            uvs.Add(new Vector2(tilePosX * tileSize, tilePosY * tileSize));
            uvs.Add(new Vector2(tilePosX * tileSize + tileSize, tilePosY * tileSize));
            uvs.Add(new Vector2(tilePosX * tileSize + tileSize, tilePosY * tileSize + tileSize));
            uvs.Add(new Vector2(tilePosX * tileSize, tilePosY * tileSize + tileSize));

            normals.Add(new Vector3(0, 1, 0));
            normals.Add(new Vector3(0, 1, 0));
            normals.Add(new Vector3(0, 1, 0));
            normals.Add(new Vector3(0, 1, 0));

            indicies.Add(currentIndex + 0);
            indicies.Add(currentIndex + 1);
            indicies.Add(currentIndex + 2);

            indicies.Add(currentIndex + 2);
            indicies.Add(currentIndex + 3);
            indicies.Add(currentIndex + 0);

            currentIndex += 4;
          }

          // bottom
          if (chunk.world.GetBlock(worldBlockX, worldBlockY - 1, worldBlockZ) == 0) {
            vertices.Add(new Vector3((x * Chunk.VOXEL_SIZE) - Chunk.VOXEL_SIZE_HALF, (y * Chunk.VOXEL_SIZE) - Chunk.VOXEL_SIZE_HALF, (z * Chunk.VOXEL_SIZE) - Chunk.VOXEL_SIZE_HALF));
            vertices.Add(new Vector3((x * Chunk.VOXEL_SIZE) - Chunk.VOXEL_SIZE_HALF, (y * Chunk.VOXEL_SIZE) - Chunk.VOXEL_SIZE_HALF, (z * Chunk.VOXEL_SIZE) + Chunk.VOXEL_SIZE_HALF));
            vertices.Add(new Vector3((x * Chunk.VOXEL_SIZE) + Chunk.VOXEL_SIZE_HALF, (y * Chunk.VOXEL_SIZE) - Chunk.VOXEL_SIZE_HALF, (z * Chunk.VOXEL_SIZE) + Chunk.VOXEL_SIZE_HALF));
            vertices.Add(new Vector3((x * Chunk.VOXEL_SIZE) + Chunk.VOXEL_SIZE_HALF, (y * Chunk.VOXEL_SIZE) - Chunk.VOXEL_SIZE_HALF, (z * Chunk.VOXEL_SIZE) - Chunk.VOXEL_SIZE_HALF));

            uvs.Add(new Vector2(tilePosX * tileSize, tilePosY * tileSize));
            uvs.Add(new Vector2(tilePosX * tileSize + tileSize, tilePosY * tileSize));
            uvs.Add(new Vector2(tilePosX * tileSize + tileSize, tilePosY * tileSize + tileSize));
            uvs.Add(new Vector2(tilePosX * tileSize, tilePosY * tileSize + tileSize));

            normals.Add(new Vector3(0, -1, 0));
            normals.Add(new Vector3(0, -1, 0));
            normals.Add(new Vector3(0, -1, 0));
            normals.Add(new Vector3(0, -1, 0));

            indicies.Add(currentIndex + 0);
            indicies.Add(currentIndex + 2);
            indicies.Add(currentIndex + 1);

            indicies.Add(currentIndex + 3);
            indicies.Add(currentIndex + 2);
            indicies.Add(currentIndex + 0);

            currentIndex += 4;
          }

          // left
          if (chunk.world.GetBlock(worldBlockX - 1, worldBlockY, worldBlockZ) == 0) {
            vertices.Add(new Vector3((x * Chunk.VOXEL_SIZE) - Chunk.VOXEL_SIZE_HALF, (y * Chunk.VOXEL_SIZE) - Chunk.VOXEL_SIZE_HALF, (z * Chunk.VOXEL_SIZE) - Chunk.VOXEL_SIZE_HALF));
            vertices.Add(new Vector3((x * Chunk.VOXEL_SIZE) - Chunk.VOXEL_SIZE_HALF, (y * Chunk.VOXEL_SIZE) - Chunk.VOXEL_SIZE_HALF, (z * Chunk.VOXEL_SIZE) + Chunk.VOXEL_SIZE_HALF));
            vertices.Add(new Vector3((x * Chunk.VOXEL_SIZE) - Chunk.VOXEL_SIZE_HALF, (y * Chunk.VOXEL_SIZE) + Chunk.VOXEL_SIZE_HALF, (z * Chunk.VOXEL_SIZE) + Chunk.VOXEL_SIZE_HALF));
            vertices.Add(new Vector3((x * Chunk.VOXEL_SIZE) - Chunk.VOXEL_SIZE_HALF, (y * Chunk.VOXEL_SIZE) + Chunk.VOXEL_SIZE_HALF, (z * Chunk.VOXEL_SIZE) - Chunk.VOXEL_SIZE_HALF));

            uvs.Add(new Vector2(tilePosX * tileSize, tilePosY * tileSize));
            uvs.Add(new Vector2(tilePosX * tileSize + tileSize, tilePosY * tileSize));
            uvs.Add(new Vector2(tilePosX * tileSize + tileSize, tilePosY * tileSize + tileSize));
            uvs.Add(new Vector2(tilePosX * tileSize, tilePosY * tileSize + tileSize));

            normals.Add(new Vector3(-1, 0, 0));
            normals.Add(new Vector3(-1, 0, 0));
            normals.Add(new Vector3(-1, 0, 0));
            normals.Add(new Vector3(-1, 0, 0));

            indicies.Add(currentIndex + 0);
            indicies.Add(currentIndex + 1);
            indicies.Add(currentIndex + 2);

            indicies.Add(currentIndex + 2);
            indicies.Add(currentIndex + 3);
            indicies.Add(currentIndex + 0);

            currentIndex += 4;
          }

          // right
          if (chunk.world.GetBlock(worldBlockX + 1, worldBlockY, worldBlockZ) == 0) {
            vertices.Add(new Vector3((x * Chunk.VOXEL_SIZE) + Chunk.VOXEL_SIZE_HALF, (y * Chunk.VOXEL_SIZE) - Chunk.VOXEL_SIZE_HALF, (z * Chunk.VOXEL_SIZE) - Chunk.VOXEL_SIZE_HALF));
            vertices.Add(new Vector3((x * Chunk.VOXEL_SIZE) + Chunk.VOXEL_SIZE_HALF, (y * Chunk.VOXEL_SIZE) - Chunk.VOXEL_SIZE_HALF, (z * Chunk.VOXEL_SIZE) + Chunk.VOXEL_SIZE_HALF));
            vertices.Add(new Vector3((x * Chunk.VOXEL_SIZE) + Chunk.VOXEL_SIZE_HALF, (y * Chunk.VOXEL_SIZE) + Chunk.VOXEL_SIZE_HALF, (z * Chunk.VOXEL_SIZE) + Chunk.VOXEL_SIZE_HALF));
            vertices.Add(new Vector3((x * Chunk.VOXEL_SIZE) + Chunk.VOXEL_SIZE_HALF, (y * Chunk.VOXEL_SIZE) + Chunk.VOXEL_SIZE_HALF, (z * Chunk.VOXEL_SIZE) - Chunk.VOXEL_SIZE_HALF));

            uvs.Add(new Vector2(tilePosX * tileSize, tilePosY * tileSize));
            uvs.Add(new Vector2(tilePosX * tileSize + tileSize, tilePosY * tileSize));
            uvs.Add(new Vector2(tilePosX * tileSize + tileSize, tilePosY * tileSize + tileSize));
            uvs.Add(new Vector2(tilePosX * tileSize, tilePosY * tileSize + tileSize));

            normals.Add(new Vector3(1, 0, 0));
            normals.Add(new Vector3(1, 0, 0));
            normals.Add(new Vector3(1, 0, 0));
            normals.Add(new Vector3(1, 0, 0));

            indicies.Add(currentIndex + 0);
            indicies.Add(currentIndex + 2);
            indicies.Add(currentIndex + 1);

            indicies.Add(currentIndex + 3);
            indicies.Add(currentIndex + 2);
            indicies.Add(currentIndex + 0);

            currentIndex += 4;
          }
        }
      }
    }

    string chunkName = string.Format("Chunk {0}, {1}, {2}", chunk.worldChunkPositionX, chunk.worldChunkPositionY, chunk.worldChunkPositionZ);
    Debug.Log("[" + chunkName + "] gen time: " + (System.DateTime.Now.Millisecond - startTime) + "ms");

    lock (chunksQueueLock) {
      ChunkDone chunkDone = new ChunkDone();
      chunkDone.chunk = chunk;
      chunkDone.vertices = vertices;
      chunkDone.uvs = uvs;
      chunkDone.normals = normals;
      chunkDone.indicies = indicies;

      chunksQueue.Push(chunkDone);
    }
  }
}
