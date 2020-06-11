namespace LaTeXTemplate
{
    using System.Collections.Generic;
    using System.IO;

    public class TemplateReader
    {
        public string TemplateText { get; set; }

        public TemplateReader() { }
        public TemplateReader(string filePath)
        {
            TemplateText = File.ReadAllText(filePath);
        }

        public IEnumerable<string> GetTemplateChunks()
        {
            int chunkStart = 0;
            int chunkEnd = 0;
            bool nextChunkIsText;
            while (chunkStart < TemplateText.Length)
            {
                nextChunkIsText = !TemplateText.Substring(chunkStart, TemplateConsts.TMPL_LEN).Equals(TemplateConsts.TMPL_START);
                chunkEnd = TemplateText.IndexOf(nextChunkIsText ? TemplateConsts.TMPL_START : TemplateConsts.TMPL_END, chunkStart);

                if (!nextChunkIsText)
                    chunkEnd += TemplateConsts.TMPL_LEN;   // Grab the ending tag as well.

                if (chunkEnd <= TemplateConsts.TMPL_LEN)
                    chunkEnd = TemplateText.Length;    // It's the last chunk.  Grab everything left.

                var chunk = TemplateText.Substring(chunkStart, chunkEnd - chunkStart);
                yield return chunk;

                chunkStart = chunkEnd;
            }
        }
    }
}