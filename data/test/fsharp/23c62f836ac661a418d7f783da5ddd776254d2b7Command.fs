// Learn more about F# at http://fsharp.net

module Amanatsu.Command
  
        

let rootDirectory = "c:\\audio"

let mutable currentDirectory = rootDirectory
(*
let processSetCurrentWorkingDirectory( data : seq<byte> )
    let response = {ListenAddress = ""; ListenPort = "1400"; Version = "XBMSP-1.0 1.0 Amanatsu Server 0.1\n"; 
                    Comment = Dns.GetHostName()}
    
    let serializer = new ValueSerializer()
    serializer.append MessageType.DiscoveryReply
    serializer.append messageId
    serializer.append response.ListenAddress
    serializer.append response.ListenPort
//    serializer.append response.Version
//    serializer.append response.Comment
    
*)
let processCommand (data : list<byte>) = 
    let command = List.head data
    match Seq.head data with
    | 11uy -> printfn "Got a setcwd command"
    | cmd -> printfn "Got a command %A" cmd