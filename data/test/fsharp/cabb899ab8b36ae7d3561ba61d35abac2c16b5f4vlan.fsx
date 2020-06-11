#!/usr/bin/env fsharpi
#I "../bin/Debug"
#r "FsCPS.dll"

open System
open System.Text
open FsCPS
open FsCPS.TypeProviders

// Loads the YANG model
let [<Literal>] yangFileName = __SOURCE_DIRECTORY__ + "/dell-base-vlan.yang"
type VLANEntry = YANGProvider<fileName = yangFileName>

// An helper to manage option types
let (|?) opt v = match opt with | Some x -> x | None -> v

// Usage
let printUsage () =
    let text = [|
        "Usage: " + fsi.CommandLineArgs.[0] + " [command] vlan_id [interface_name]"
        ""
        "Available commands: "
        "- create       Creates a new VLAN with the given ID."
        "- delete       Deletes the existing VLAN with the given ID."
        "- addport      Adds a port to the given VLAN."
        "- removeport   Removes the port from the given VLAN."
        "- show         Shows details about the VLAN."
        ""
        "All the commands are followed by the ID of the VLAN they refer to."
        ""
        "By default, ports are added untagged. Use:"
        fsi.CommandLineArgs.[0] + " addport vlan_id interface_name --tagged"
        "To add the interface as a tagged port."
    |]
    printf "%s\n" (String.Join("\n", text))

// Parses a VLAN ID or exits
let parseVlanId str =
    match UInt32.TryParse(str) with
    | (true, id) when id >= 1u && id <= 4094u ->
        id
    | _ ->
        printf "Invalid VLAN ID: %s.\n" str
        exit 1

// Extracts the interface index from the name or exits
let parseInterfaceName (iface: string) =
    let req = CPSObject(CPSPath "base-ip/ipv4")
    req.SetAttribute("name", Encoding.ASCII.GetBytes(iface))
    match CPSTransaction.Get([ req ]) with
    | Error e ->
        printf "Cannot get interface index from name: %s\n" e
        exit 1
    | Ok [] ->
        printf "Cannot get interface index from name: Interface not found.\n"
        exit 1
    | Ok (o :: _) ->
        BitConverter.ToUInt32(o.GetAttribute(CPSPath "base-ip/ipv4/ifindex").Value, 0)

// Fills the given object with the current status of the vlan or exits
let fillObjectWithCurrentVlanStatus (obj: VLANEntry) =
    let req = VLANEntry(CPSPath "base-vlan/entry")
    req.Entry.Ifindex <- obj.Entry.Ifindex
    match CPSTransaction.Get([ req ]) with
    | Error e ->
        printf "Error: %s.\n" e
        exit 1
    | Ok [] ->
        printf "Cannot find VLAN with interface index %d\n" obj.Entry.Ifindex.Value
        exit 1
    | Ok (o :: _) ->
        let result = VLANEntry(o)
        obj.Entry.TaggedPorts <- result.Entry.TaggedPorts
        obj.Entry.UntaggedPorts <- result.Entry.UntaggedPorts

// Parse the args
type Commands =
| Create of uint32
| Delete of uint32
| AddPort of uint32 * uint32 * bool
| RemovePort of uint32 * uint32
| Show of uint32
| Usage
let command =
    match fsi.CommandLineArgs with
    | [| _; "create"; vlanId |] ->
        Create(parseVlanId vlanId)
    | [| _; "delete"; vlanId |] ->
        Delete(parseVlanId vlanId)
    | [| _; "addport"; vlanId; iface |] ->
        AddPort(parseVlanId vlanId, parseInterfaceName iface, false)
    | [| _; "addport"; vlanId; iface; "--tagged" |] ->
        AddPort(parseVlanId vlanId, parseInterfaceName iface, true)
    | [| _; "removeport"; vlanId; iface |] ->
        RemovePort(parseVlanId vlanId, parseInterfaceName iface)
    | [| _; "show"; vlanId |] ->
        Show(parseVlanId vlanId)
    | _ ->
        Usage

// Prepares the object that will be used to send the request
let obj = VLANEntry(CPSPath "base-vlan/entry")
let trans = CPSTransaction()

match command with

| Create(vlanId) ->
    obj.Entry.Id <- Some vlanId
    trans.Create(obj)

| Delete(vlanId) ->
    obj.Entry.Ifindex <- Some (parseInterfaceName (sprintf "br%d" vlanId))
    trans.Delete(obj)

| AddPort(vlanId, ifindex, tagged) ->
    obj.Entry.Ifindex <- Some (parseInterfaceName (sprintf "br%d" vlanId))
    fillObjectWithCurrentVlanStatus obj
    if tagged then
        obj.Entry.TaggedPorts <- obj.Entry.TaggedPorts
                                 |? []
                                 |> (fun l -> ifindex :: l)
                                 |> Some
    else
        obj.Entry.UntaggedPorts <- obj.Entry.UntaggedPorts
                                   |? []
                                   |> (fun l -> ifindex :: l)
                                   |> Some
    trans.Set(obj)

| RemovePort(vlanId, ifindex) ->
    obj.Entry.Ifindex <- Some (parseInterfaceName (sprintf "br%d" vlanId))
    fillObjectWithCurrentVlanStatus obj
    obj.Entry.TaggedPorts <- obj.Entry.TaggedPorts
                             |? []
                             |> List.filter ((<>) ifindex)
                             |> Some
    obj.Entry.UntaggedPorts <- obj.Entry.UntaggedPorts
                               |? []
                               |> List.filter ((<>) ifindex)
                               |> Some
    trans.Set(obj)

| Show(vlanId) ->
    obj.Entry.Id <- Some vlanId
    match CPSTransaction.Get([ obj ]) with
    | Error e ->
        printf "Error: %s.\n" e
        exit 1
    | Ok objs ->
        objs |> List.iter (fun o -> printf "%s\n" (o.ToString(true)))
        exit 0

| Usage ->
    printUsage()
    exit 0

// Commit the transaction
match trans.Commit() with
| Error e ->
    printf "Error: %s.\n" e
    exit 1
| Ok () ->
    printf "Done.\n"
    exit 0