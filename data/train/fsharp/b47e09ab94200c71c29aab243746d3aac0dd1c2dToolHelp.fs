module Pather.ToolHelp

open System
open System.Runtime.InteropServices
open Microsoft.Win32.SafeHandles

[<DllImport("kernel32.dll", SetLastError = true)>]
extern bool CloseHandle(IntPtr hObject)

type SnapshotFlags = 
    | HeapList = 0x00000001
    | Process  = 0x00000002
    | Thread   = 0x00000004
    | Module   = 0x00000008
    | Module32 = 0x00000010
    | Inherit  = 0x80000000
    | NoHeaps = 0x40000000

type SnapshotHandle() = 
    class
        inherit SafeHandleZeroOrMinusOneIsInvalid(true)
        override this.ReleaseHandle() = CloseHandle(this.handle)
    end

[<StructLayout(LayoutKind.Sequential, CharSet = System.Runtime.InteropServices.CharSet.Unicode)>]
type ModuleEntry = 
    struct
        val mutable EntrySize : int
        val mutable ModuleId : int
        val mutable ProcessId : int
        val mutable Reserved0 : int
        val mutable Reserved1 : int
        val mutable BaseAddress : IntPtr
        val mutable ModuleSize : int
        val mutable ModuleHandle : IntPtr
        [<MarshalAs(UnmanagedType.ByValTStr, SizeConst = 256)>]
        val mutable ModuleName : string
        [<MarshalAs(UnmanagedType.ByValTStr, SizeConst = 260)>]
        val mutable ModulePath : string
    end

[<StructLayout(LayoutKind.Sequential, CharSet = System.Runtime.InteropServices.CharSet.Unicode)>]
type ProcessEntry =
    struct
        val mutable EntrySize: int 
        val mutable Unused0: int 
        val mutable ProcessId: int
        val mutable Unused1: IntPtr; 
        val mutable Unused2: int
        val mutable NumberOfThreads : int
        val mutable ParentProcessId: int
        val mutable BasePriority: int
        val mutable Unused3: int
        [<MarshalAs(UnmanagedType.ByValTStr, SizeConst=260)>] 
        val mutable ExePath: string; 
    end

[<DllImport("kernel32.dll", SetLastError = true)>]
extern SnapshotHandle CreateToolhelp32Snapshot(SnapshotFlags dwFlags, int th32ProcessID)

[<DllImport("kernel32.dll", EntryPoint = "Module32FirstW")>]
extern bool Module32First(SnapshotHandle hSnapshot, ModuleEntry& lpme)

[<DllImport("kernel32.dll", EntryPoint = "Module32NextW")>]
extern bool Module32Next(SnapshotHandle hSnapshot, ModuleEntry& lpme)

[<DllImport("kernel32.dll", EntryPoint = "Process32FirstW")>]
extern bool Process32First(SnapshotHandle hSnapshot, ProcessEntry& lpme)

[<DllImport("kernel32.dll", EntryPoint = "Process32NextW")>]
extern bool Process32Next(SnapshotHandle hSnapshot, ProcessEntry& lpme)

let createSnapshot (flags : SnapshotFlags) (processId : int) = CreateToolhelp32Snapshot(flags, processId)

let modules (snapshot : SnapshotHandle) = 
    seq {         
        let mutable entry = new ModuleEntry()
        entry.EntrySize <- Marshal.SizeOf<ModuleEntry>()        

        Module32First(snapshot, &entry) |> ignore
        
        yield entry

        while Module32Next(snapshot, &entry) do
            yield entry
    }

let processes (snapshot: SnapshotHandle) =
    seq {
        let mutable entry = new ProcessEntry()
        entry.EntrySize <- Marshal.SizeOf<ProcessEntry>()        

        Process32First(snapshot, &entry) |> ignore
        
        yield entry

        while Process32Next(snapshot, &entry) do
            yield entry
    }