#nowarn "9"

open System
open System.Collections.Generic
open System.Diagnostics
open System.IO
open System.Runtime.InteropServices
open System.Threading
open System.Text
open Microsoft.Win32.SafeHandles

[<StructLayout(LayoutKind.Sequential, CharSet = CharSet.Unicode); Struct>]
type STARTUPINFO =
    [<DefaultValue>] val mutable public cb : int
    [<DefaultValue>] val mutable public lpReserved : string
    [<DefaultValue>] val mutable public lpDesktop : string
    [<DefaultValue>] val mutable public lpTitle : string
    [<DefaultValue>] val mutable public dwX : int
    [<DefaultValue>] val mutable public dwY : int
    [<DefaultValue>] val mutable public dwXSize : int
    [<DefaultValue>] val mutable public dwYSize : int
    [<DefaultValue>] val mutable public dwXCountChars : int
    [<DefaultValue>] val mutable public dwYCountChars : int
    [<DefaultValue>] val mutable public dwFillAttribute : int
    [<DefaultValue>] val mutable public dwFlags : int
    [<DefaultValue>] val mutable public wShowWindow : int16
    [<DefaultValue>] val mutable public cbReserved2 : int16
    [<DefaultValue>] val mutable public lpReserved2 : nativeint
    [<DefaultValue>] val mutable public hStdInput : nativeint
    [<DefaultValue>] val mutable public hStdOutput : nativeint
    [<DefaultValue>] val mutable public hStdError : nativeint

[<StructLayout(LayoutKind.Sequential); Struct>]
type PROCESS_INFORMATION  =
   [<DefaultValue>] val mutable public hProcess : nativeint
   [<DefaultValue>] val mutable public hThread : nativeint
   [<DefaultValue>] val mutable public dwProcessId : uint32
   [<DefaultValue>] val mutable public dwThreadId : uint32

type DebugEventType =
    | ExitProcessDebugEvent = 5
    | LoadDllDebugEvent = 6

[<StructLayout(LayoutKind.Sequential); Struct>]
type DEBUG_EVENT =
    [<DefaultValue>] val mutable public dwDebugEventCode : DebugEventType 
    [<DefaultValue>] val mutable public dwProcessId : uint32
    [<DefaultValue>] val mutable public dwThreadId : uint32

[<StructLayout(LayoutKind.Sequential); Struct>]
type LOAD_DLL_DEBUG_INFO =
   [<DefaultValue>] val mutable public DebugEvent : DEBUG_EVENT
   [<DefaultValue>] val mutable public hFile : nativeint
   [<DefaultValue>] val mutable public lpBaseOfDll : nativeint
   [<DefaultValue>] val mutable public dwDebugInfoFileOffset : uint32
   [<DefaultValue>] val mutable public nDebugInfoSize : uint32
   [<DefaultValue>] val mutable public lpImageName : nativeint
   [<DefaultValue>] val mutable public fUnicode : uint16

[<Flags>]
type FileMapProtection =
    | PageReadonly = 0x02
    | PageReadWrite = 0x04
    | PageWriteCopy = 0x08
    | PageExecuteRead = 0x20
    | PageExecuteReadWrite = 0x40
    | SectionCommit = 0x8000000
    | SectionImage = 0x1000000
    | SectionNoCache = 0x10000000
    | SectionReserve = 0x4000000

[<Flags>]
type FileMapAccess =
    | FileMapCopy = 0x0001
    | FileMapWrite = 0x0002
    | FileMapRead = 0x0004
    | FileMapAllAccess = 0x001f
    | FileMapExecute = 0x0020

module NativeMethods =

    [<DllImport("kernel32.dll", SetLastError = true)>]
    extern bool CreateProcess(string lpApplicationName,
       string lpCommandLine, nativeint lpProcessAttributes, 
       nativeint lpThreadAttributes, bool bInheritHandles, 
       uint32 dwCreationFlags, nativeint lpEnvironment, string lpCurrentDirectory,
       [<In>] STARTUPINFO& lpStartupInfo, 
       [<Out>] PROCESS_INFORMATION& lpProcessInformation)
    
    [<DllImport("kernel32.dll", SetLastError = true)>]
    extern bool WaitForDebugEvent(nativeint lpDebugEvent, int dwMilliseconds)

    [<DllImport("kernel32.dll", SetLastError = true)>]
    extern bool ContinueDebugEvent(uint32 dwProcessId, uint32 dwThreadId, uint32 dwContinueStatus)

    [<DllImport("kernel32.dll", SetLastError = true)>]
    extern bool GetExitCodeProcess(nativeint hProcess, [<Out>] int& lpExitCode)

    [<DllImport("kernel32.dll", SetLastError = true)>]
    extern IntPtr CreateFileMapping(
        nativeint hFile,
        nativeint lpFileMappingAttributes,
        FileMapProtection flProtect,
        uint32 dwMaximumSizeHigh,
        uint32 dwMaximumSizeLow,
        string lpName)

    [<DllImport("kernel32.dll", SetLastError = true)>]
    extern nativeint MapViewOfFile(
        nativeint hFileMappingObject,
        FileMapAccess dwDesiredAccess,
        uint32 dwFileOffsetHigh,
        uint32 dwFileOffsetLow,
        uint32 dwNumberOfBytesToMap)

    [<DllImport("kernel32.dll", SetLastError = true)>]
    extern bool UnmapViewOfFile(nativeint lpBaseAddress)

    [<DllImport("psapi.dll", SetLastError = true)>]
    extern int GetMappedFileName(nativeint hProcess, nativeint lpv, [<Out>] StringBuilder lpFilename, int nSize)

    [<DllImport("kernel32.dll", SetLastError = true)>]
    extern int GetLogicalDriveStrings(int nBufferLength, [<Out>] char[] lpBuffer)

    [<DllImport("kernel32.dll", SetLastError = true)>]
    extern int QueryDosDevice(string lpDeviceName, [<Out>] char[] lpTargetPath, int ucchMax)

module Program =

    let rawFileNameFromHandle (handle : SafeHandle) : string =
        use hm = new SafeWaitHandle(NativeMethods.CreateFileMapping(handle.DangerousGetHandle(), IntPtr.Zero, FileMapProtection.PageReadonly, 0u, 1u, null), true)
        use proc = Process.GetCurrentProcess()
        let ptr = NativeMethods.MapViewOfFile(hm.DangerousGetHandle(), FileMapAccess.FileMapRead, 0u, 0u, 1u)
        try
            let sb = StringBuilder(260)
            match NativeMethods.GetMappedFileName(proc.Handle, ptr, sb, sb.Capacity) with
            | 0 ->
                Marshal.ThrowExceptionForHR(Marshal.GetHRForLastWin32Error())
                failwith "unreachable"

            | n ->
                sb.Length <- n
                string sb

        finally
            ignore (NativeMethods.UnmapViewOfFile(ptr))

    let fileNameFromHandle (handle : SafeHandle) : string =
        let rawName = rawFileNameFromHandle handle
        let a = Array.zeroCreate 260

        let driveLetters =
            match NativeMethods.GetLogicalDriveStrings(Array.length a - 1, a) with
            | 0 ->
                Marshal.ThrowExceptionForHR(Marshal.GetHRForLastWin32Error())
                failwith "unreachable"

            | n ->
                String(a, 0, n - 1).Split('\000')

        let picker (driveLetter : string) =
            let driveLetter = driveLetter.TrimEnd('\\')

            let parts =
                match NativeMethods.QueryDosDevice(driveLetter, a, Array.length a) with
                | 0 ->
                    Marshal.ThrowExceptionForHR(Marshal.GetHRForLastWin32Error())
                    failwith "unreachable"

                | n ->
                    String(a, 0, n).Split('\000')

            match List.ofArray parts with
            | prefix :: _ when rawName.StartsWith(prefix) ->
                Some (driveLetter + rawName.Substring(prefix.Length))
            | _ -> None

        defaultArg (Array.tryPick picker driveLetters) rawName

    [<EntryPoint>]
    let main args =
        let filename, processName, rest =
            match List.ofArray args with
            | filename :: processName :: rest -> filename, processName, rest
            | _ -> failwithf "Usage: logdlls filename command [args...]"

        use textWriter = File.CreateText(filename)
        use mailbox =
            let seen = HashSet()

            let rec writer (mailbox : MailboxProcessor<_>) =
                async {
                    let! message = mailbox.Receive()
                    match message with
                    | Choice1Of2 fileHandle ->
                        let filename =
                            try
                                fileNameFromHandle fileHandle
                            finally
                                fileHandle.Close()

                        if not (seen.Add(filename)) then
                            textWriter.WriteLine(filename)
                            textWriter.Flush()

                        return! writer mailbox

                    | Choice2Of2 (reply : AsyncReplyChannel<_>) ->
                        reply.Reply()
                }

            new MailboxProcessor<_>(writer)

        mailbox.Start()

        let mutable si = STARTUPINFO(cb = Marshal.SizeOf(typeof<STARTUPINFO>), dwFlags = 1, wShowWindow = 5s)
        let mutable pi = PROCESS_INFORMATION()
        if not (NativeMethods.CreateProcess(processName, String.concat " " rest, IntPtr.Zero, IntPtr.Zero, false, 1u, IntPtr.Zero, null, &si, &pi)) then
            Marshal.ThrowExceptionForHR(Marshal.GetHRForLastWin32Error())

        use hp = new SafeWaitHandle(pi.hProcess, true)
        use ht = new SafeWaitHandle(pi.hThread, true)
        let buffer = Marshal.AllocHGlobal(256)
        let processId = pi.dwProcessId

        let rec run () =
            if not (NativeMethods.WaitForDebugEvent(buffer, Timeout.Infinite)) then
                Marshal.ThrowExceptionForHR(Marshal.GetHRForLastWin32Error())

            let e : DEBUG_EVENT = unbox (Marshal.PtrToStructure(buffer, typeof<DEBUG_EVENT>))
            
            let go =
                match e.dwDebugEventCode with
                | DebugEventType.ExitProcessDebugEvent when e.dwProcessId = processId ->
                    false

                | DebugEventType.LoadDllDebugEvent ->
                    let e : LOAD_DLL_DEBUG_INFO = unbox (Marshal.PtrToStructure(buffer, typeof<LOAD_DLL_DEBUG_INFO>))
                    mailbox.Post(Choice1Of2 (new SafeWaitHandle(e.hFile, true)))
                    true

                | _ ->
                    true

            if go then
                ignore (NativeMethods.ContinueDebugEvent(e.dwProcessId, e.dwThreadId, 0x80010001u))
                run ()
            else
                ()

        try
            run ()
        finally
            Marshal.FreeHGlobal(buffer)

        let mutable exitCode = 0
        if not (NativeMethods.GetExitCodeProcess(pi.hProcess, &exitCode)) then
            Marshal.ThrowExceptionForHR(Marshal.GetHRForLastWin32Error())

        mailbox.PostAndReply(Choice2Of2)
        exitCode
