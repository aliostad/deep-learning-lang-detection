public static class ListExtensions
    {
        public static IEnumerable<IEnumerable<T>> Chunk<T>(this IEnumerable<T> source, int chunkSize)
        {
            Argument.CheckIfNull(source, "source");
            Argument.CheckIfNull(chunkSize, "chunkSize");

            if (chunkSize <= 0)
            {
                throw new ArgumentException("chunkSize should be positive", "chunkSize");
            }

            return source
                .Select((x, i) => new { Index = i, Value = x })
                .GroupBy(x => x.Index / chunkSize)
                .Select(x => x.Select(y => y.Value).ToList())
                .ToList();
        }
    }