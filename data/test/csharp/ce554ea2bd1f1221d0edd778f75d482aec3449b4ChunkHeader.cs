﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DalvikUWPCSharp.Disassembly.APKParser.struct_
{
    public class ChunkHeader
    {
        // Type identifier for this chunk.  The meaning of this value depends
        // on the containing chunk.
        private int chunkType;

        // Size of the chunk header (in bytes).  Adding this value to
        // the address of the chunk allows you to find its associated data
        // (if any).
        private int headerSize;

        // Total size of this chunk (in bytes).  This is the chunkSize plus
        // the size of any data associated with the chunk.  Adding this value
        // to the chunk allows you to completely skip its contents (including
        // any child chunks).  If this value is the same as chunkSize, there is
        // no data associated with the chunk.
        private long chunkSize;

        public ChunkHeader(int chunkType, int headerSize, long chunkSize)
        {
            this.chunkType = chunkType;
            this.headerSize = headerSize;
            this.chunkSize = chunkSize;
        }

        public int getBodySize()
        {
            return (int)(this.chunkSize - this.headerSize);
        }

        public int getChunkType()
        {
            return chunkType;
        }

        public void setChunkType(int chunkType)
        {
            this.chunkType = chunkType;
        }

        public int getHeaderSize()
        {
            return headerSize;
        }

        public void setHeaderSize(int headerSize)
        {
            this.headerSize = headerSize;
        }

        public long getChunkSize()
        {
            return chunkSize;
        }

        public void setChunkSize(long chunkSize)
        {
            this.chunkSize = chunkSize;
        }
    }
}
