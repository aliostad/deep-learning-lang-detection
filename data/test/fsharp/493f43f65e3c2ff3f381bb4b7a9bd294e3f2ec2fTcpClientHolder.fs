namespace the_end

open System
open System.Net
open System.Net.Sockets


type TcpClientHolder (handleFunc, name : string) =
    class

        let rec mailboxRecvFunc (inbox : MailboxProcessor<TcpClient>) = async {
            while true do
                let! client = inbox.Receive ();
                printfn "%s: got client r: %O l: %O" name client.Client.RemoteEndPoint client.Client.LocalEndPoint;
                Async.Start(handleFunc client)
        }

        let handler = MailboxProcessor.Start mailboxRecvFunc

        member this.post = handler.Post

    end

    (*

type TcpClientHolder<'T> (handleFunc, name : string) =
    class

        let rec mailboxRecvFunc (inbox : MailboxProcessor<TcpClient * 'T>) = async {
            while true do
                let! (client : TcpClient, extra) = inbox.Receive ();
                printfn "%s: got client r: %O l: %O" name client.Client.RemoteEndPoint client.Client.LocalEndPoint;
                Async.Start(handleFunc client extra)
        }

        let handler = MailboxProcessor.Start mailboxRecvFunc

        member this.post client extra = handler.Post (client, extra)

    end *)