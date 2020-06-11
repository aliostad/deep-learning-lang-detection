using System;
using Http.chunk_data;
using Http.chunk_ext;
using Http.chunk_size;
using JetBrains.Annotations;
using Txt.ABNF;
using Txt.ABNF.Core.CRLF;
using Txt.Core;

namespace Http.chunk
{
    public class ChunkLexerFactory : RuleLexerFactory<Chunk>
    {
        static ChunkLexerFactory()
        {
            Default = new ChunkLexerFactory(
                ChunkSizeLexerFactory.Default.Singleton(),
                ChunkExtensionLexerFactory.Default.Singleton(),
                NewLineLexerFactory.Default.Singleton(),
                ChunkDataLexerFactory.Default.Singleton());
        }

        public ChunkLexerFactory(
            [NotNull] ILexerFactory<ChunkSize> chunkSize,
            [NotNull] ILexerFactory<ChunkExtension> chunkExtension,
            [NotNull] ILexerFactory<NewLine> newLine,
            [NotNull] ILexerFactory<ChunkData> chunkData)
        {
            if (chunkSize == null)
            {
                throw new ArgumentNullException(nameof(chunkSize));
            }
            if (chunkExtension == null)
            {
                throw new ArgumentNullException(nameof(chunkExtension));
            }
            if (newLine == null)
            {
                throw new ArgumentNullException(nameof(newLine));
            }
            if (chunkData == null)
            {
                throw new ArgumentNullException(nameof(chunkData));
            }
            ChunkSize = chunkSize;
            ChunkExtension = chunkExtension;
            NewLine = newLine;
            ChunkData = chunkData;
        }

        [NotNull]
        public static ChunkLexerFactory Default { get; }

        [NotNull]
        public ILexerFactory<ChunkData> ChunkData { get; set; }

        [NotNull]
        public ILexerFactory<ChunkExtension> ChunkExtension { get; set; }

        [NotNull]
        public ILexerFactory<ChunkSize> ChunkSize { get; set; }

        [NotNull]
        public ILexerFactory<NewLine> NewLine { get; set; }

        public override ILexer<Chunk> Create()
        {
            var chunkSize = ChunkSize.Create();
            var chunkExt = ChunkExtension.Create();
            var chunkData = ChunkData.Create();
            var crlf = NewLine.Create();
            var innerLexer = Concatenation.Create(
                chunkSize,
                Option.Create(chunkExt),
                crlf,
                chunkData,
                crlf);
            return new ChunkLexer(innerLexer);
        }
    }
}
