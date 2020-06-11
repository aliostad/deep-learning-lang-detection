using UnityEngine;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using Random = UnityEngine.Random;

public class TileLayer : PoolBehaviour {
    public int centerTileX;
    public int centerTileY;
    public int centerChunkX;
    public int centerChunkY;
    
    public int chunkWidth;
    public int chunkHeight;
    public int widthInChunks;
    public int heightInChunks;
    public TileChunk[,] chunks;

    public delegate void ChunkCreatedHandler(TileChunk newChunk);
    public event ChunkCreatedHandler OnChunkCreated;
    
    public override void OnCreate() {
        chunkWidth = TileChunk.width;
        chunkHeight = TileChunk.height;
        widthInChunks = 16;
        heightInChunks = 16;
        chunks = new TileChunk[widthInChunks, heightInChunks];
        
        centerChunkX = widthInChunks/2;
        centerChunkY = heightInChunks/2;
        centerTileX = centerChunkX * chunkWidth;
        centerTileY = centerChunkY * chunkHeight;
    } 

    public IEnumerable<TileChunk> AllChunks {
        get {
            for (var i = 0; i < widthInChunks; i++) {
                for (var j = 0; j < heightInChunks; j++) {
                    var chunk = chunks[i, j];
                    if (chunk != null) yield return chunk;
                }
            }
        }
    }

    public void EnableRendering() {
        foreach (var chunk in AllChunks) {
            chunk.renderer.enabled = true;
        }
    }
    
    public void DisableRendering() {
        foreach (var chunk in AllChunks) {
            chunk.renderer.enabled = false;
        }
    }
    
    public Tile this[IntVector2 bp] {
        get {
            var trueX = centerTileX + bp.x;
            var trueY = centerTileY + bp.y;
            var chunkX = trueX/chunkWidth;
            var chunkY = trueY/chunkHeight;
            var localX = trueX%chunkWidth;
            var localY = trueY%chunkHeight;
            
            if (chunkX < 0 || chunkX >= chunkWidth || chunkY < 0 || chunkY >= chunkHeight)
                return null;
            
            var chunk = chunks[chunkX, chunkY];
            if (chunk == null) return null;
            
            return chunk[localX, localY];
        }
        set {
            var trueX = centerTileX + bp.x;
            var trueY = centerTileY + bp.y;
            var trueChunkX = trueX/chunkWidth;
            var trueChunkY = trueY/chunkHeight;
            var localX = trueX%chunkWidth;
            var localY = trueY%chunkHeight;
            
            var chunk = chunks[trueChunkX, trueChunkY];
            if (chunk == null && value != null) {
                //Debug.LogFormat("{0} {1}", trueChunkX - centerChunkX, trueChunkY - centerChunkY);                
                chunk = Pool.For("TileChunk").Attach<TileChunk>(transform);
                chunk.transform.localPosition = new Vector2(
                    (trueChunkX - centerChunkX) * chunkWidth * Tile.worldSize, 
                    (trueChunkY - centerChunkY) * chunkHeight * Tile.worldSize
                 );    
                //Debug.Log(chunk.transform.localPosition);
                chunk.gameObject.SetActive(true);
                chunks[trueChunkX, trueChunkY] = chunk;

                if (OnChunkCreated != null)
                    OnChunkCreated(chunk);
            }

            if (chunk != null)
                chunk[localX, localY] = value;
        }
    }
    
    public Tile this[int x, int y] {
        get { return this[new IntVector2(x, y)]; }
        set { this[new IntVector2(x, y)] = value; }
    }
}
