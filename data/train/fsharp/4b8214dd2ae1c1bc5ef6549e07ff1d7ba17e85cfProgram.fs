open System.Net
open System.Net.Sockets
open System.IO
open System.Text
open System.Threading
open System.Configuration
open System.Collections.ObjectModel

let address = ConfigurationManager.AppSettings.["server"]
let port = System.Convert.ToInt32 ConfigurationManager.AppSettings.["port"]
let nick = ConfigurationManager.AppSettings.["nick"]

type EventType = PING = 0 | PRIVMSG = 1 | UNKNOWN = 2
type EventHandler = delegate of EventType * string -> unit

type EventListener = {
    event : EventType
    handler : EventHandler
}

type User = {
    nick : string
    address : string
}

let GetEventType(command: string) =
    let cmdMap = [("PING", EventType.PING); ("PRIVMSG", EventType.PRIVMSG)] |> Map.ofList
    match cmdMap.TryFind(command) with
    | Some(cmd) -> cmd
    | None -> EventType.UNKNOWN

type Connection(address: string, port: int) =    
    let socket = new TcpClient()
    do socket.Connect(address, port)
    let input = new BinaryReader(socket.GetStream())
    let output = new BinaryWriter(socket.GetStream())
    member x.Send(data : byte[]) = output.Write(data)
    member x.Receive(buffer: byte[]) = input.Read(buffer, 0, buffer.Length)
    

type IrcNetwork(connection: Connection) =
    let eventListeners = new Collection<EventListener>()
    let users = new Collection<User>()
    member x.AddListener(listener: EventListener) = eventListeners.Add(listener)
    member x.RemoveListener(listener: EventListener) = eventListeners.Remove(listener)

    member x.Recv() = 
        let sb = new StringBuilder()
        let buffer: byte[] = Array.zeroCreate 512
        let bytesRead = connection.Receive(buffer)
        sb.Append(ASCIIEncoding.ASCII.GetString(buffer, 0, bytesRead)) |> ignore
        sb.ToString()
    
    member x.Send(input: string) =
        // Remove line feeds from messages
        let sanitized = input.Replace("\r", "").Replace("\n", "")
        let bytes = ASCIIEncoding.ASCII.GetBytes(sanitized + "\r\n")
        connection.Send(bytes)
        printf "S: %s" input

    member x.ListenerThread() =
        for incoming in Seq.initInfinite (fun _ -> x.Recv()) do
            printf "R (%d): %s" incoming.Length incoming
            let first = incoming.Split ' ' |> Seq.head
            let second = incoming.Split ' ' |> Seq.skip 1 |> Seq.head
            let command = if first.StartsWith(":") then second else first
            let myEvent = GetEventType(command)
            let myListeners = Seq.filter (fun i -> i.event = myEvent) eventListeners
            for l in myListeners do
                l.handler.Invoke(myEvent, incoming)

    member x.Join(channel: string) =
        x.Send(sprintf "JOIN %s" channel)

    member x.HandleUserInput() =
        for userinput in Seq.initInfinite(fun _ -> System.Console.ReadLine()) do
            x.Send(userinput)

    member x.Start() =
        
        let pingHandler = {
            event = EventType.PING
            handler = new EventHandler(fun _ data -> x.Send(System.String.Concat ["PONG "; (data.Split ' ' |> Seq.last)]))
        }

        let pingWaitHandle = new AutoResetEvent(false)

        let firstPingHandler = {
            event = EventType.PING
            handler = new EventHandler(fun _ data -> pingWaitHandle.Set() |> ignore)
        }

        let getText(data: string) =
            let words = data.Split(' ')
            let sentence = words |> Seq.skip 3 |> String.concat " "
            sentence.Substring 1

        let echoHandler = {
            event = EventType.PRIVMSG
            handler = new EventHandler(fun _ data -> x.Send(System.String.Format("PRIVMSG #test {0}", getText(data))))
        }
            

        let PrettyPrint (str: string) =
            let elements = str.Split(' ')
            let userAndAddress = elements |> Seq.head
            let nick = (userAndAddress.Split('!') |> Seq.head).Substring(1)

            // TODO: Make use of the rest of the data here.
            let firstSpace = str.IndexOf(' ')
            let secondSpace = str.IndexOf(' ', firstSpace + 1)
            let thirdSpace = str.IndexOf(' ', secondSpace + 1)
            let channel = str.Substring(secondSpace + 1, thirdSpace - secondSpace - 1)
            let msg = str.Substring(thirdSpace + 2)
            System.Console.Write(sprintf "[%s] %s: %s" channel nick msg)

        let chatHandler = {
            event = EventType.PRIVMSG
            handler = new EventHandler(fun _ data -> PrettyPrint(data))
        }

        x.AddListener(pingHandler)
        x.AddListener(firstPingHandler)
        x.AddListener(echoHandler)
        x.AddListener(chatHandler)

        let listener = new Thread(x.ListenerThread)
        listener.Start()

        x.Send("PASS secret")
        x.Send(sprintf "NICK %s" nick)

        printfn "Waiting for PING response..."
        pingWaitHandle.WaitOne() |> ignore
        printfn "Got PING response!"
        x.RemoveListener(firstPingHandler) |> ignore

        x.Send("USER FBot 0 * :Min Bot")
        x.Join("#test")

        x.HandleUserInput()
        listener.Abort()

let program() =
    let conn = new Connection(address, port)
    let ircnet = new IrcNetwork(conn)
    ircnet.Start()
    0

program() |> ignore
