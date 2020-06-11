namespace RNInjector.Model

open Process
open Win32API

open RNInvoke

open System

module Hack = 
    let Inject() =

        // old code 
        (*let wc3 = getProcess("War3")

        if (snd wc3) then
            let handler = (fst wc3).Handle
            let baseAdress = getModule("game.dll" , wc3)

            let size = 6

            let testoffset = new IntPtr(baseAdress + 0x74d1ab)
            let buffer = [| byte size |]

            buffer.[0] <- Convert.ToByte(0x83)

            let mutable bytes_read = 0
            let mutable old_permissions = new uint32()

            HackAPI.VirtualProtectEx(handler, testoffset, (uint32)size, (uint32)0x40, old_permissions)
            |> ignore

            HackAPI.WriteProcessMemory(handler, testoffset, buffer, size, bytes_read)
            |> ignore

            HackAPI.VirtualProtectEx(handler, testoffset, (uint32)size, old_permissions, old_permissions)
            |> ignore
        else 
            ()  *)

        ()