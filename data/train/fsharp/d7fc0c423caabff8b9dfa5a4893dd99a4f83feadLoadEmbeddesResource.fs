open System
open System.Reflection  // embedded resources.

// digg_tools.txt must be in project with build action set to Embeddded Resource. 
// ANd copy as "do not copy" to output folder.

/// Read text as strem (used for embedded source).
let readLinesFromStream (filePath:Stream) = seq {
    use sr = new StreamReader (filePath)
    while not sr.EndOfStream do
        yield sr.ReadLine ()
}

// https://support.microsoft.com/en-us/kb/319292#bookmark-4
// ok
let _assembly = Assembly.GetExecutingAssembly()
let str1 = _assembly.GetManifestResourceStream("digg_tools.txt") //may need assembly name in front.
let fl = readLinesFromStream str1 |> List.ofSeq