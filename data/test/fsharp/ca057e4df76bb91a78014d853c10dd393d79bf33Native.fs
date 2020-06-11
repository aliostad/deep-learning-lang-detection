module Pather.Native

open System
open System.Text
open System.Runtime.InteropServices
open Microsoft.FSharp.NativeInterop
open System.IO
open PeNet

[<Flags>]
type AllocationType = 
     | Commit = 0x1000
     | Reserve = 0x2000
     | Decommit = 0x4000
     | Release = 0x8000
     | Reset = 0x80000
     | Physical = 0x400000
     | TopDown = 0x100000
     | WriteWatch = 0x200000
     | LargePages = 0x20000000

type MemoryProtection =
     | Execute = 0x10
     | ExecuteRead = 0x20
     | ExecuteReadWrite = 0x40
     | ExecuteWriteCopy = 0x80
     | NoAccess = 0x01
     | ReadOnly = 0x02
     | ReadWrite = 0x04
     | WriteCopy = 0x08
     | GuardModifierflag = 0x100
     | NoCacheModifierflag = 0x200
     | WriteCombineModifierflag = 0x400


[<DllImport("kernel32.dll", SetLastError = true)>]
extern bool WriteProcessMemory(IntPtr hProcess, IntPtr lpBaseAddress, IntPtr lpBuffer, int nSize, int * lpNumberOfBytesWritten);

[<DllImport("kernel32.dll", SetLastError = true)>]
extern IntPtr VirtualAllocEx(IntPtr hProcess, IntPtr lpAddress, IntPtr dwSize, AllocationType flAllocationType, MemoryProtection flProtect);

[<DllImport("kernel32.dll")>]
extern IntPtr CreateRemoteThread(IntPtr hProcess, IntPtr lpThreadAttributes, UInt32 dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, UInt32 dwCreationFlags, IntPtr * lpThreadId);

[<DllImport("kernel32.dll", SetLastError = true, CallingConvention = CallingConvention.Winapi)>]
extern bool IsWow64Process(IntPtr hProcess, bool * wow64Process);

[<DllImport("kernel32.dll", SetLastError = true, CallingConvention = CallingConvention.Winapi)>]
extern int GetProcessId (IntPtr hProcess);

type LibraryPath = { Path86: string; Path64: string }

let findFunction (processHandle: IntPtr) (library: string) (name: string) =
    let library = ToolHelp.createSnapshot(ToolHelp.SnapshotFlags.Module ||| ToolHelp.SnapshotFlags.Module32) (GetProcessId(processHandle))
                    |> ToolHelp.modules
                    |> Seq.find (fun m -> m.ModuleName.Equals(library, StringComparison.InvariantCultureIgnoreCase))  

    let peFile = PeFile(library.ModulePath)    
    let func = peFile.ExportedFunctions |> Seq.find (fun f -> f.Name.Equals(name))

    library.BaseAddress + (nativeint func.Address)

let injectLibrary (processHandle: IntPtr) (library: LibraryPath) =
    let loadLibrary = findFunction processHandle  "kernel32.dll" "LoadLibraryA"
  
    let mutable isWow = false

    IsWow64Process(processHandle, &&isWow) |> ignore

    let libraryPath = if isWow then library.Path86 else library.Path64
    
    if not (File.Exists libraryPath) then
        failwithf "Library %s not found" libraryPath

    let arg = VirtualAllocEx(processHandle, IntPtr.Zero, nativeint (libraryPath.Length + 1), AllocationType.Commit ||| AllocationType.Reserve, MemoryProtection.ReadWrite)

    if arg = IntPtr.Zero then
        failwithf "Virtual Alloc failed: %d" (Marshal.GetLastWin32Error())

    let argPtr = Marshal.StringToHGlobalAnsi(libraryPath)

    let mutable written = 0

    WriteProcessMemory(processHandle, arg, argPtr, libraryPath.Length + 1, &&written) |> ignore

    let mutable threadId = IntPtr.Zero

    CreateRemoteThread(processHandle, IntPtr.Zero, 0u, loadLibrary, arg, 0u, &&threadId) |> ignore

