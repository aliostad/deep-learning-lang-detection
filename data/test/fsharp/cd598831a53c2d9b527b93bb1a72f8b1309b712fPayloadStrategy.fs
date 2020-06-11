namespace FishSockets

open System
open TVA

type PayloadType =
    | Stream = 0
    | Boundary = 1

type IPayloadStrategy =
    interface
        inherit IDisposable

        abstract PayloadType : PayloadType
            with get

        abstract Id : Guid
            with get

        abstract PreSending : byte[]*int*int -> byte[]*int*int
        abstract ProcessReceived : byte[]*int*int->unit
    end

type StreamPayloadStrategy(m_id: Guid,m_evtRecvDataReady : Event<Guid*byte[]>) =

    interface IPayloadStrategy with
        member this.PayloadType 
            with get() = PayloadType.Stream

        member this.Id  
            with get() = m_id

        member this.PreSending(buffer,offset,size)= 
            buffer,offset,size

        member this.ProcessReceived(buffer,offset,size) =
            // strange: cannot use "extension method" syntax here
            let copied = BufferExtensions.BlockCopy(buffer,offset,size)
            m_evtRecvDataReady.Trigger(m_id,copied)

    interface IDisposable with
        member this.Dispose() = 
            ()

type BoundaryPayloadStrategy(m_id:Guid,m_evtRecvDataReady : Event<Guid*byte[]>) =

    let m_parser = new HeadBodyParser()

    let onBodyParsed(buffer,offset,size)=
        let copied = BufferExtensions.BlockCopy(buffer,offset,size)
        m_evtRecvDataReady.Trigger(m_id,copied)

    do
        m_parser.BodyParsedEvt.Add onBodyParsed
        m_parser.Start()

    interface IPayloadStrategy with
        member this.PayloadType 
            with get() = PayloadType.Boundary

        member this.Id 
            with get() = m_id

        member this.PreSending(buffer,offset,size )=
            let newbuffer = Array.zeroCreate<byte>(4+size)

            Buffer.BlockCopy((EndianOrder.LittleEndian.GetBytes size),0,newbuffer,0,4)
            Buffer.BlockCopy(buffer,offset,newbuffer,4,size)

            newbuffer,0,newbuffer.Length

        member this.ProcessReceived(buffer,offset,size) =
            m_parser.Write(buffer,offset,size)

    interface IDisposable with
        member this.Dispose() =
            m_parser.Dispose()

module PayloadStrategyFactory =

    let makeStrategy payloadType id (evtDataReady : Event<Guid*byte[]>)=
    
        match payloadType with
        | PayloadType.Stream ->
            new StreamPayloadStrategy(id,evtDataReady) :> IPayloadStrategy
        | PayloadType.Boundary ->
            new BoundaryPayloadStrategy(id,evtDataReady) :> IPayloadStrategy
        | _ ->
            failwith "unrecognized payload type"
            
           
