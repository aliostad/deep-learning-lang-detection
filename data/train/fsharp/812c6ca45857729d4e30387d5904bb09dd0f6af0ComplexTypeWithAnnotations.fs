namespace ProtobufTest.WithAttributes
open System
open NUnit.Framework
open System.Collections
open ProtobufTest
open ProtoBuf

[<ProtoContract>]
[<CLIMutable>]
type MessageA = {
   [<ProtoMember(1)>] Subject     : string 
   [<ProtoMember(2)>] To          : string Generic.List
   [<ProtoMember(3)>] body        : string
}

[<ProtoContract>]
[<CLIMutable>]
type MessageB = {
    [<ProtoMember(1)>]Subject     : string option
    [<ProtoMember(2)>]body        : string
}

[<ProtoContract>]
[<CLIMutable>]
type MessageC = {
    [<ProtoMember(1)>]Subject : string
    [<ProtoMember(2)>]body    : string
    [<ProtoMember(3)>]message : MessageC option
}

[<ProtoContract(SkipConstructor = true)>]
type MessageDU = 
    | MessageA of MessageA
    | MessageB of MessageB




[<TestFixture>]
type ``Complex types serialization test with attributes``() = 

    [<Test>]
    member __.``Serializing and deserializing an empty list``() =
        let message = {
            Subject = "subject"
            To = new Generic.List<string>()
            body = "Body"
        }


        let messageCopy = message |> Serialization.serialize |> Serialization.deserialize<MessageA>

        Assert.AreEqual(message.Subject,messageCopy.Subject)
        Assert.AreEqual(message.body,messageCopy.body)
        Assert.AreEqual(message.To,messageCopy.To)
    [<Test>]
    member __.``Serializing and deserializing lists``() =
        let l = new Generic.List<string>()
        l.Add("a")
        l.Add("b")
        let message = {
            Subject = "subject"
            To = l
            body = "Body"
        }


        let messageCopy = message |> Serialization.serialize |> Serialization.deserialize<MessageA>

        Assert.AreEqual(message.Subject,messageCopy.Subject)
        Assert.AreEqual(message.body,messageCopy.body)
        Assert.AreEqual(message.To,messageCopy.To)

    [<Test>]
    member __.``Serializing and deserializing options``() =
        let message : MessageB = {
            Subject = Some "subject"
            body = "Body"
        }

        let message' : MessageB = {
            Subject = None
            body = "Body"
        }

        let messageCopy = message |> Serialization.serialize |> Serialization.deserialize<MessageB>
        let messageCopy' = message' |> Serialization.serialize |> Serialization.deserialize<MessageB>
        Assert.AreEqual(message,messageCopy)
        Assert.AreEqual(message',messageCopy')

    [<Test>]
    member __.``Serializing and deserializing nested types``() =
        let message : MessageC = {
            Subject     = "subject"
            body        = "Body"
            message     = Some {
                Subject     = "subject"
                body        = "Body"
                message     = None

            }
        }

        let messageCopy = message |> Serialization.serialize |> Serialization.deserialize<MessageC>
        Assert.AreEqual(message,messageCopy)

    [<Test>]
    member __.``Serializing and deserializing DU``() =
        let message = MessageB {
            Subject = None
            body = "Body"
        }
        Serialization.registerSerializableDu<MessageDU> ()
        printfn "%A" <| ProtoBuf.Serializer.GetProto<MessageDU>()
        let messageCopy = message |> Serialization.serialize |> Serialization.deserialize<MessageDU>
        printfn "%A" messageCopy
        Assert.AreEqual(message,messageCopy)

