using System;
using System.Collections.Generic;
using System.IO;

namespace ChunkingFile
{
    public struct Chunk
    {
        public readonly Int32 Size;
        public readonly Int32 Id;

        public Chunk(Int32 size, Int32 id)
        {
            Size = size;
            Id = id;
        }

        public Chunk Next()
        {
            return new Chunk(Size, Id + 1);
        }
    }

    public static class ChunkReader
    {
        public static IEnumerable<Result> FromTextReader(TextReader reader,
                                                         ILineActionBuilder builder,
                                                         Int32 chunkSize)
        {
            return Repeat<Result>.Sequence(_ =>
                                           {
                                               var chunk = _ == null
                                                               ? new Chunk(chunkSize, 1)
                                                               : _.Chunk.Next();
                                               var action = builder.Build(chunk.Id);

                                               return Process(reader, action, chunk);
                                           })
                                 .Until(_ => _ is End);
        }

        private static Result Process(TextReader reader,
                                      ILineAction action,
                                      Chunk chunk)
        {
            String line;
            var i = 0;

            while ((line = reader.ReadLine()) != null && ++i < chunk.Size)
                action.Execute(line);

            action.Dispose();

            return line == null || reader.Peek() == -1
                       ? new End(chunk, i)
                       : (Result)new Continue(chunk, i);
        }

        public abstract class Result
        {
            private readonly Int32 _count;
            private readonly Chunk _chunk;

            protected Result(Chunk chunk, Int32 count)
            {
                _count = count;
                _chunk = chunk;
            }

            public Int32 LineCount
            {
                get { return _count; }
            }

            public Chunk Chunk
            {
                get { return _chunk; }
            }
        }

        public class End : Result
        {
            public End(Chunk chunk, Int32 count)
                : base(chunk, count)
            {
            }
        }

        public class Continue : Result
        {
            public Continue(Chunk chunk, Int32 count)
                : base(chunk, count)
            {
            }
        }
    }
}