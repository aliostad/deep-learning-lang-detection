using System;
using System.Collections.Generic;
using System.IO;
using System.Threading;

namespace DynaStudios.Blocks {
    class IntHolder
    {
        public int value = 0;
    }

    public class AsyncChunkLoader {
        public delegate void ChunkLoadedDelegate(Chunk chunk);
        public event ChunkLoadedDelegate ChunkLoaded;

        private LinkedList<Chunk> _queriedChunks = new LinkedList<Chunk>();
        private string _dataPath;
        private bool _keepAlive = true;
        private IntHolder _regions = new IntHolder();

        public AsyncChunkLoader(string dataPath) {
            _dataPath = dataPath;
            new Thread(loadChunks).Start();
        }

        public bool chunkIsQueried(int x, int y) {
            lock (_queriedChunks) {
                LinkedListNode<Chunk> chunk = _queriedChunks.First;
                while (chunk != null) {
                    if (chunk.Value.X == x && chunk.Value.Z == y) {
                        return true;
                    }
                    chunk = chunk.Next;
                }
            }
            return false;
        }

        public void request(int x, int y, bool urgent = false) {
            if (!chunkIsQueried(x, y)) {
                registerChunkForLoad(x, y, urgent);
            }
        }

        private void registerChunkForLoad(int x, int y, bool urgent) {
            Chunk chunk = new Chunk(x, y);
            lock (_queriedChunks) {
                if (urgent) {
                    _queriedChunks.AddFirst(chunk);
                } else {
                    _queriedChunks.AddLast(chunk);
                }
                Monitor.Pulse(_queriedChunks);
            }
        }

        private string getStringForFilesystem(int nummber) {
            if (nummber < 0) {
                return "m" + (-nummber).ToString();
            }
            return nummber.ToString();
        }

        private LinkedListNode<Chunk> getNextChunkNode() {
            LinkedListNode<Chunk> chunkNode;
            do {
                lock (_queriedChunks) {
                    chunkNode = _queriedChunks.First;
                    if (chunkNode != null) {
                        break;
                    }
                    Monitor.Wait(_queriedChunks);
                }
            } while (_keepAlive);
            return chunkNode;
        }

        private void loadChunks() {
            while (_keepAlive) {
                LinkedListNode<Chunk> chunkNode = getNextChunkNode();
                if (!_keepAlive) {
                    return;
                }
                Chunk chunk = chunkNode.Value;

                string chunkFileName = string.Format(
                    "{0}_{1}.dscf",
                    getStringForFilesystem(chunk.X),
                    getStringForFilesystem(chunk.Z));
                string chunkFullPath = Path.Combine(_dataPath, chunkFileName);

                chunk.load(chunkFullPath);
                lock (_queriedChunks) {
                    _queriedChunks.Remove(chunkNode);
                }
                ChunkLoaded(chunk);
            }
        }

        public void stop() {
            _keepAlive = false;
            lock (_queriedChunks) {
                Monitor.Pulse(_queriedChunks);
            }
        }

        public void addRegion()
        {
            lock (_regions)
            {
                ++_regions.value;
            }
        }

        public void removeRegion()
        {
            lock (_regions)
            {
                --_regions.value;
                if (_regions.value == 0)
                {
                    stop();
                }
            }
        }
    }
}
