module internal CASO.DB.Titan.RexPro.BufferPoolStream

open System
open System.IO
open System.Collections.Generic

open CASO.DB.Titan.RexPro.ObjectPool

/// A pool of byte buffers
type BufferPool(bufferSize, initialPoolCount, maxPoolCount) =
    inherit ObjectPool<byte[]>((fun () -> (Array.create bufferSize 0uy)), initialPoolCount, maxPoolCount)
    member val BufferSize = bufferSize with get
    member val Capacity = bufferSize * maxPoolCount

/// MemoryStream using a ObjectPool with backing buffers. 
type BufferPoolStream(pool:BufferPool) =
    inherit Stream()

    let isDisposed = ref false
    let length = ref 0
    let position = ref 0
    let buffers = new List<byte[]>()

    /// Clear the buffer and push it back to the pool
    let clearAndPushBack buffer =
        Array.fill buffer 0 buffer.Length 0uy
        pool.Push(buffer)
    
    /// Set the capacity (buffers.Count * buffer size)
    let setCapacity value =
        if !isDisposed then raise (exn "Cannot write to stream") 
        if value > pool.Capacity then invalidArg "value" "Cannot be greater than BufferPool.Capacity"
        if value < 0 || value > Int32.MaxValue then invalidArg "value" "Must be between 0 and Int32.MaxValue"

        if value = 0 then
            for buf in buffers do
                clearAndPushBack buf
            buffers.Clear()

        if value <> (buffers.Count * pool.BufferSize) then
            // Calculate how many buffers we need to hold the new capacity
            let neededBufferCount =
                (value / pool.BufferSize)
                // Check if we have room for the value, if not add 1 buffer
                |> fun bc -> if (value - bc * pool.BufferSize) > 0 then bc + 1 else bc
            
            if neededBufferCount < buffers.Count then
                // The new needed buffer size is less than we already use, push back the buffers we don't need
                for i = (neededBufferCount + 1) to (buffers.Count - 1) do
                    clearAndPushBack buffers.[i]
                buffers.RemoveRange(neededBufferCount + 1, buffers.Count - neededBufferCount)
            else

                // We need more buffers to hold this new capacity, pop some buffers from the pool
                for i = buffers.Count to (neededBufferCount - 1) do
                    buffers.Add (pool.Pop() |> Async.RunSynchronously)
    
    /// Set the new length
    let setLength value =
        if !isDisposed then raise (exn "Cannot write to stream") 

        setCapacity value

        length := value
        
        if !position > !length then
            position := !length
    
    do // Start of with capacity of 1 buffer size
        setCapacity pool.BufferSize
        
    member val BufferSize = pool.BufferSize with get

    member x.GetBufferAt position = buffers.[position]

    override x.CanRead with get() = (!isDisposed = false)
    override x.CanSeek with get() = (!isDisposed = false)
    override x.CanWrite with get() = (!isDisposed = false)
    override x.Length with get() = (int64)!length
    override x.Position with get() = (int64)!position and set (value:int64) = position := (int)value

    override x.Flush() = ()

    override x.Seek(offset:int64, origin:SeekOrigin) =
        if !isDisposed then raise (exn "PoolMemoryStream is disposed!")
        if (int)offset > Int32.MaxValue then invalidArg "offset" "Out of range"

        match origin with
        | SeekOrigin.Current -> position := !position + (int)offset
        | SeekOrigin.End -> position := !length + (int)offset
        | _ -> position := (int)offset

        if !position < 0 then raise (exn "Attempted to seek before start of PoolMemoryStream")

        (int64)!position

    override x.SetLength(value) = setLength ((int)value)

    override x.Read(buffer:byte[], offset:int, count:int) =
        if !isDisposed then raise (exn "PoolMemoryStream is disposed!")
        if buffer = null then invalidArg "buffer" "Cannot be null"
        if offset + count > buffer.Length then invalidArg "buffer" "Too small"
        if offset < 0 then invalidArg "offset" "Must be >= 0"
        if count < 0 then invalidArg "count" "Must be >= 0"

        if !position >= !length || count = 0 
            then 0
        else
            let bufNum = ref (!position / pool.BufferSize)
            let posInBuf = ref (!position - !bufNum * pool.BufferSize)
            let bytesToRead = Math.Min(count, (int)!length - (int)!position)
            let bytesRead = ref 0
            let bytesLeft = ref (bytesToRead - !bytesRead)
            let currentOffset = ref offset

            while !bytesLeft > 0 do
                if (!posInBuf + !bytesLeft) < pool.BufferSize 
                then !bytesLeft 
                else pool.BufferSize - !posInBuf
                |> fun bytesToCopy ->
                    Buffer.BlockCopy(buffers.[!bufNum], !posInBuf, buffer, !currentOffset, bytesToCopy)

                    position        := !position + bytesToCopy
                    currentOffset   := !currentOffset + bytesToCopy
                    bytesLeft       := !bytesLeft - bytesToCopy
                    bytesRead       := !bytesRead + bytesToCopy

                incr bufNum
                posInBuf := 0

            bytesToRead

    override x.Write(buffer:byte[], offset:int, count:int) =
        if !isDisposed then raise (exn "PoolMemoryStream is disposed!")
        if buffer = null then invalidArg "buffer" "Cannot be null"
        if offset + count > buffer.Length then invalidArg "buffer" "Too small"
        if offset < 0 then invalidArg "offset" "Must be >= 0"
        if count < 0 then invalidArg "count" "Must be >= 0"
        
        if !position > !length - count then
            setLength (!position + count)

        let bufNum = ref (!position / pool.BufferSize)
        let posInBuf = ref (!position - !bufNum * pool.BufferSize)
        let bytesWritten = ref 0
        let bytesLeft = ref (count - !bytesWritten)
        let currentOffset = ref offset

        while !bytesLeft > 0 do
            if (!posInBuf + !bytesLeft) < pool.BufferSize 
            then !bytesLeft 
            else pool.BufferSize - !posInBuf
            |> fun bytesToCopy ->
                Buffer.BlockCopy(buffer, !currentOffset, buffers.[!bufNum], !posInBuf, bytesToCopy)

                position        := !position + bytesToCopy
                currentOffset   := !currentOffset + bytesToCopy
                bytesLeft       := !bytesLeft - bytesToCopy
                bytesWritten    := !bytesWritten + bytesToCopy

            incr bufNum
            posInBuf := 0

    override x.Dispose(isDisposing) =
        if !isDisposed = false then
            for buf in buffers do
                clearAndPushBack buf
            buffers.Clear()
        isDisposed := true
    