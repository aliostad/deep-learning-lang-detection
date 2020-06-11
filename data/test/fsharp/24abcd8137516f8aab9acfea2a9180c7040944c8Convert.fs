module Convert


let toBytesUtf8(str: string) : byte[] =
    let buffersize = 8192
    use reader = new System.IO.StringReader(str)
    use result = new System.IO.MemoryStream()
    use writer = new System.IO.StreamWriter(result, System.Text.Encoding.UTF8)
    let buffer : char[] = Array.zeroCreate buffersize
    let rec copy() = 
        match reader.Read(buffer, 0, buffersize) with 
        | 0 -> ()
        | read -> 
            result.SetLength(result.Length + System.Convert.ToInt64(read))
            writer.Write(buffer, 0, read)
            copy()
    copy()
    writer.Flush()
    result.ToArray()


let toString(bytes: byte[]) : string =
    let numChars = (bytes.Length / sizeof<char>) + (bytes.Length % sizeof<char>)
    let chars: char[] = Array.create numChars System.Char.MinValue
    System.Buffer.BlockCopy(bytes, 0, chars, 0, bytes.Length)
    System.String(chars)