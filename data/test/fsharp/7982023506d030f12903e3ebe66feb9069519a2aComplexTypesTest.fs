namespace ProtobufTest.ComplexTypes
open System
open NUnit.Framework
open ProtobufTest
open System.Collections
type MessageA = {
    Subject     : string 
    To          : string Generic.List
    body        : string
}
type MessageB = {
    Subject     : string option
    body        : string
}

type MessageC = {
    Subject : string
    body    : string
    message : MessageC option
}

type MessageDU = 
    | MessageA of MessageA
    | MessageB of MessageB




[<TestFixture>]
type ``Complex types serialization test``() = 

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
        let messageCopy = message |> Serialization.serialize |> Serialization.deserialize<MessageDU>
        printfn "%A" messageCopy
        Assert.AreEqual(message,messageCopy)

    [<Test>]
    member __.``Serializing and deserializing tuples``() =
        let message = (1,1)
        Serialization.registerSerializableDu<MessageDU> ()
        let messageCopy = message |> Serialization.serialize |> Serialization.deserialize<int*int>
        printfn "%A" messageCopy
        Assert.AreEqual(message,messageCopy)
