// error:	OK
// langId:	27
// langName:	C#
// langVersion:	mono-2.8
// time:	0.05
// date:	2012-11-21 00:29:13
// status:	0
// result:	15
// memory:	37312
// signal:	0
// public:	false
// ------------------------------------------------
using System;
using System.Collections.Generic;
using System.Linq;

public class Program
{
    private readonly static Random r = new Random();

    public static void Main(string[] args)
    {
        int N = 250;
        var work = Enumerable.Range(1,N).Select(x => r.Next(0, 6)).ToList();

        var chunks = work.Select((o,i) => new { Index=i, Obj=o })
            .GroupBy(e => e.Index / 10)
            .Select(group => group.Select(e => e.Obj).ToList())
            .ToList();

        foreach(var chunk in chunks)
            Console.WriteLine("Chunk: {0}", string.Join(", ", chunk.Select(i => i.ToString()).ToArray()));
    }
}

// ------------------------------------------------
#if 0 // stdin

#endif
#if 0 // stdout
Chunk: 3, 0, 2, 0, 4, 2, 3, 3, 5, 0
Chunk: 2, 3, 4, 4, 0, 5, 4, 1, 3, 5
Chunk: 5, 0, 5, 2, 1, 4, 5, 1, 2, 4
Chunk: 2, 4, 1, 4, 5, 0, 5, 2, 1, 4
Chunk: 3, 4, 0, 5, 1, 3, 1, 3, 5, 2
Chunk: 2, 3, 2, 1, 3, 4, 5, 4, 1, 3
Chunk: 2, 0, 1, 1, 2, 4, 3, 5, 2, 2
Chunk: 4, 1, 2, 1, 3, 1, 4, 4, 4, 3
Chunk: 5, 0, 0, 5, 1, 2, 3, 0, 1, 0
Chunk: 3, 5, 5, 4, 5, 2, 2, 5, 1, 0
Chunk: 5, 2, 5, 2, 2, 1, 3, 3, 5, 1
Chunk: 1, 4, 2, 0, 5, 2, 0, 3, 1, 5
Chunk: 2, 3, 3, 2, 2, 1, 1, 0, 4, 1
Chunk: 4, 1, 4, 2, 1, 1, 4, 0, 5, 4
Chunk: 1, 5, 5, 2, 4, 5, 1, 3, 1, 4
Chunk: 0, 1, 0, 0, 2, 4, 4, 2, 0, 1
Chunk: 3, 3, 3, 1, 0, 1, 4, 0, 1, 5
Chunk: 0, 3, 1, 2, 4, 0, 3, 3, 5, 4
Chunk: 2, 4, 5, 2, 3, 0, 4, 3, 1, 0
Chunk: 2, 3, 4, 5, 3, 4, 4, 2, 3, 4
Chunk: 2, 4, 4, 3, 1, 2, 2, 4, 2, 1
Chunk: 5, 1, 0, 0, 5, 0, 4, 3, 3, 2
Chunk: 2, 2, 2, 2, 3, 2, 4, 3, 1, 2
Chunk: 3, 4, 0, 4, 4, 1, 3, 4, 3, 3
Chunk: 2, 0, 0, 5, 3, 0, 0, 1, 2, 1

#endif
#if 0 // stderr

#endif
#if 0 // cmpinfo

#endif
