#r "../Fazuki.Server/bin/Debug/Fazuki.Common.dll"
#r "../Fazuki.Server/bin/Debug/Fazuki.Server.dll"
#r "../Fazuki.Jil/bin/Debug/Fazuki.Jil.dll"
#r "../Fazuki.Server/bin/Debug/fszmq.dll"


open Fazuki.Server
open Fazuki.Jil
open Fazuki.Server.Helpers
open Fazuki.Common

type GetCreatures = {
    CreatureType : string
}

type Creature = {
    Type : string;
    Name : string;
}

let CreatureHandler:Handler<GetCreatures, list<Creature>> =
    {Name="get_creatures"
     Consume= fun req -> 
                sprintf "requested creature %s" req.CreatureType |> ignore
                [{Type="Dog"; Name="Bobby"}]}

let handlers = AddHandler CreatureHandler []

let config = {
    Serializer= Serialization.JilSerializer
    Handlers= handlers
    Port=5555
    Filters=[]
}

Server.Start config
