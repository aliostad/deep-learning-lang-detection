using System;
using System.IO;
using System.Runtime.InteropServices;

namespace SpeechOcean.WP
{
    public unsafe class MemoryMapAccessor : IDisposable
    {
        const long ChunkSize = 1 << 20; // 1MByte
        const long ChunkSizeModMask = ChunkSize - 1;   // mask for taking modulo

        private FileInfo fi;
        private long _size; // the file size in bytes
        private long _chunkCount; // number of anticipated chunks

        private bool[] _chunkLoaded = null;
        private GCHandle _chunkLoadedHandle;
        private bool* _chunkLoadedPtr;

        private byte[][] _chunks;
        private GCHandle[] _chunkHandles;
        private byte*[] _chunkPtrs;

        private bool _isDisposed;
        private object _chunkLock = new object();

        private readonly FileStream _stream;

        /// <summary>
        /// Ctor
        /// </summary>
        /// <param name="path"></param>
        public MemoryMapAccessor(string path)
        {
            if (string.IsNullOrWhiteSpace(path))
            {
                throw new ApplicationException("MemoryMapAccessor cannot be created: no file name specified.");
            }

            fi = new FileInfo(path);
            if (!fi.Exists)
            {
                throw new ApplicationException(string.Format("MemoryMapAccessor cannot be created: file {0} does not exist.", path));
            }

            _size = fi.Length;
            _chunkCount = _size / ChunkSize;
            var lastChunkSize = _size % ChunkSize;
            if (lastChunkSize > 0)
            {
                _chunkCount++;
            }

            Invalidate();
            _stream = new FileStream(path, FileMode.Open, FileAccess.Read, FileShare.Read);
        }

        ~MemoryMapAccessor()
        {
            if (!_isDisposed)
            {
                Dispose();
            }
        }

        public void Dispose()
        {
            if (!_isDisposed)
            {
                _isDisposed = true;
                if (_stream != null)
                {
                    _stream.Close();
                    _stream.Dispose();
                }
                Cleanup();
            }
        }

        private void Cleanup()
        {
            if (_chunkLoadedHandle != null && _chunkLoadedHandle.IsAllocated)
            {
                _chunkLoadedHandle.Free();
            }

            if (_chunkHandles != null)
            {
                foreach (var handle in _chunkHandles)
                {
                    if (handle.IsAllocated)
                    {
                        handle.Free();
                    }
                }
            }
            _chunkHandles = null;
            _chunkPtrs = null;
            _chunks = null;
        }

        /// <summary>
        /// Invalidate all previously read blocks and drop all memory
        /// </summary>
        public void Invalidate()
        {
            Cleanup();
            _chunkLoaded = new bool[_chunkCount];   // new virgin _chunkLoaded array invalidates all previously read blocks

            _chunkLoadedHandle = GCHandle.Alloc(_chunkLoaded, GCHandleType.Pinned);
            _chunkLoadedPtr = (bool*)_chunkLoadedHandle.AddrOfPinnedObject().ToPointer();

            _chunks = new byte[_chunkCount][];
            _chunkHandles = new GCHandle[_chunkCount];
            _chunkPtrs = new byte*[_chunkCount];
        }

        /// <summary>
        /// Load the specified chunk
        /// </summary>
        /// <param name="chunkNumber"></param>
        private void LoadChunk(long chunkNumber)
        {
            if (chunkNumber >= _chunkCount)
            {
                throw new ApplicationException("Attempt to load unanticipated chunk of data");
            }

            var chunk = new byte[ChunkSize];

            _stream.Seek((chunkNumber * ChunkSize), SeekOrigin.Begin);
            _stream.Read(chunk, 0, (int)ChunkSize);
            _chunks[chunkNumber] = chunk;

            var chunkHandle = GCHandle.Alloc(chunk, GCHandleType.Pinned);
            _chunkHandles[chunkNumber] = chunkHandle;
            var ptr = (byte*)chunkHandle.AddrOfPinnedObject().ToPointer();
            _chunkPtrs[chunkNumber] = ptr;
        }

        /// <summary>
        /// Get the size of the file
        /// </summary>
        public long Size { get { return _size; } }

        /// <summary>
        /// Read a byte value from the specified position in the Memory Map
        /// </summary>
        /// <param name="idx"></param>
        /// <returns></returns>
        public byte ReadByte(long idx)
        {
            long chunkNumber = idx >> 20;
            if (!*(_chunkLoadedPtr + chunkNumber))
            {
                lock (_chunkLock)
                {
                    if (!*(_chunkLoadedPtr + chunkNumber))
                    {
                        LoadChunk(chunkNumber);
                        *(_chunkLoadedPtr + chunkNumber) = true;
                    }
                }
            }
            return *(_chunkPtrs[chunkNumber] + (idx & ChunkSizeModMask));
        }

        /// <summary>
        /// Read an Int16 value from the specified position in the Memory Map
        /// </summary>
        /// <param name="idx"></param>
        /// <returns></returns>
        public short ReadInt16(long idx)
        {
            long chunkNumber = idx >> 20;
            if (!*(_chunkLoadedPtr + chunkNumber))
            {
                lock (_chunkLock)
                {
                    if (!*(_chunkLoadedPtr + chunkNumber))
                    {
                        LoadChunk(chunkNumber);
                        *(_chunkLoadedPtr + chunkNumber) = true;
                    }
                }
            }

            long modIdx = idx & ChunkSizeModMask;
            if (ChunkSize - modIdx >= sizeof(Int16))
            {
                return *((short*)(_chunkPtrs[chunkNumber] + modIdx));
            }
            else
            {
                int val = *(_chunkPtrs[chunkNumber] + modIdx);
                if (!*(_chunkLoadedPtr + (++chunkNumber)))
                {
                    lock (_chunkLock)
                    {
                        if (!*(_chunkLoadedPtr + chunkNumber))
                        {
                            LoadChunk(chunkNumber);
                            *(_chunkLoadedPtr + chunkNumber) = true;
                        }
                    }
                }
                val += (*_chunkPtrs[chunkNumber]) << 8;
                return (short)val;
            }
        }

        /// <summary>
        /// Read an integer value from the specified position in the Memory Map
        /// </summary>
        /// <param name="idx"></param>
        /// <returns></returns>
        public int ReadInt32(long idx)
        {
            long chunkNumber = idx >> 20;
            if (!*(_chunkLoadedPtr + chunkNumber))
            {
                lock (_chunkLock)
                {
                    if (!*(_chunkLoadedPtr + chunkNumber))
                    {
                        LoadChunk(chunkNumber);
                        *(_chunkLoadedPtr + chunkNumber) = true;
                    }
                }
            }

            long modIdx = idx & ChunkSizeModMask;
            long headroom = ChunkSize - modIdx;
            if (headroom >= sizeof(int))
            {
                return *((int*)(_chunkPtrs[chunkNumber] + modIdx));
            }
            else
            {
                int val = 0;
                switch (headroom)
                {
                    case 1:
                        val = *(_chunkPtrs[chunkNumber] + modIdx);
                        if (!*(_chunkLoadedPtr + (++chunkNumber)))
                        {
                            lock (_chunkLock)
                            {
                                if (!*(_chunkLoadedPtr + chunkNumber))
                                {
                                    LoadChunk(chunkNumber);
                                    *(_chunkLoadedPtr + chunkNumber) = true;
                                }
                            }
                        }
                        val += *(_chunkPtrs[chunkNumber]) << 8;
                        val += *((short*)(_chunkPtrs[chunkNumber] + 1)) << 16;
                        break;
                    case 2:
                        val = *((short*)(_chunkPtrs[chunkNumber] + modIdx));
                        if (!*(_chunkLoadedPtr + (++chunkNumber)))
                        {
                            lock (_chunkLock)
                            {
                                if (!*(_chunkLoadedPtr + chunkNumber))
                                {
                                    LoadChunk(chunkNumber);
                                    *(_chunkLoadedPtr + chunkNumber) = true;
                                }
                            }
                        }
                        val += *((short*)(_chunkPtrs[chunkNumber])) << 16;
                        break;
                    case 3:
                        val = *((short*)(_chunkPtrs[chunkNumber] + modIdx));
                        val += *(_chunkPtrs[chunkNumber] + modIdx + 2) << 16;
                        if (!*(_chunkLoadedPtr + (++chunkNumber)))
                        {
                            lock (_chunkLock)
                            {
                                if (!*(_chunkLoadedPtr + chunkNumber))
                                {
                                    LoadChunk(chunkNumber);
                                    *(_chunkLoadedPtr + chunkNumber) = true;
                                }
                            }
                        }
                        val += *(_chunkPtrs[chunkNumber]) << 24;
                        break;
                }
                return val;
            }
        }

        /// <summary>
        /// Write the specified value into the specified position in the MemoryMap
        /// </summary>
        /// <param name="idx"></param>
        /// <param name="value"></param>
        public void Write(long idx, byte value)
        {
            long chunkNumber = idx >> 20;
            if (!*(_chunkLoadedPtr + chunkNumber))
            {
                lock (_chunkLock)
                {
                    if (!*(_chunkLoadedPtr + chunkNumber))
                    {
                        LoadChunk(chunkNumber);
                        *(_chunkLoadedPtr + chunkNumber) = true;
                    }
                }
            }
            *(_chunkPtrs[chunkNumber] + (idx & ChunkSizeModMask)) = value;
        }
    }
}
