using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Runtime.Serialization.Formatters.Binary;
using System.Text;
using UnityEngine;

class ChunkLoader {
    public static Chunk loadChunk(Vector vector) {
        string filePath = getChunkSaveFilePath(vector);
        if (File.Exists(filePath)) {
            Chunk chunk = Serializer.loadAndDeserialize<Chunk>(filePath);
            chunk.init(vector);
            return chunk;
        } else {
            Chunk chunk = new Chunk(vector);
            GameManager.currentTerrainGenerator.populateChunk(chunk);
            return chunk;
        }
    }
    public static string getChunkSaveFilePath(Vector vector) {
        string fileName = Chunk.getChunkName(vector);
        return GameManager.path + "/" + GameManager.saveFileName + "/Chunks/" + fileName + ".txt";
    }
}
