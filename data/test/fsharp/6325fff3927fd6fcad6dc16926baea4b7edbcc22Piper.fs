module Piper

open System
open System.Runtime.InteropServices

open Phoebe

[<DllImport("user32.dll")>]
extern void keybd_event
   ( byte bVk
   , byte bScan
   , UInt32 dwFlags
   , UIntPtr dwExtraInfo)

[<DllImport("user32.dll")>]
extern UInt32 SendInput
    ( UInt32 numberOfInputs
    , INPUT& input
    , int structSize);

[<DllImport("user32.dll")>]
extern IntPtr FindWindow
    ( String lpClassName
    , String lpWindowName)

[<DllImport("user32.dll", SetLastError = true)>]
extern IntPtr GetWindowThreadProcessId
    ( IntPtr hWnd
    , UInt32& lpdwProcessId)
                                      
[<DllImport("kernel32.dll")>]
extern int ReadProcessMemory
    ( IntPtr OpenedHandle
    , IntPtr lpBaseAddress 
    , byte[] lpBuffer
    , UInt32 size
    , IntPtr& lpNumberOfBytesRead)
                                            
[<DllImport("kernel32.dll")>]
extern int CloseHandle(IntPtr hObject)

[<DllImport("kernel32.dll")>]
extern IntPtr OpenProcess
    ( ProcessAccess dwDesiredAccess
    , bool bInheritHandle
    , UInt32 dwProcessId)

[<DllImport("kernel32.dll", SetLastError = true, ExactSpelling = true)>]
extern IntPtr VirtualAllocEx
    ( IntPtr hProcess
    , IntPtr lpAddress
    , UInt32 dwSize
    , AllocationType flAllocationType
    , MemoryProtection flProtect)

[<DllImport("kernel32.dll", SetLastError = true)>]
extern bool WriteProcessMemory
    ( IntPtr hProcess
    , IntPtr lpBaseAddress
    , byte[] lpBuffer
    , UInt32 nSize
    , int& lpNumberOfBytesWritten) 
    
[<DllImport("kernel32")>]
extern IntPtr GetCurrentProcess()

[<DllImport("user32.dll")>]
extern bool ShowWindow(IntPtr hWnd, int nCmdShow)

[<DllImport("advapi32.dll")>]
extern bool OpenProcessToken
    ( IntPtr ProcessHandle
    , Int64 DesiredAccess
    , IntPtr* TokenHandle)

[<DllImport("advapi32.dll")>]
extern bool LookupPrivilegeValue
    ( String lpSystemName
    , String lpName
    , LUID* lpLuid)

[<DllImport("advapi32.dll", ExactSpelling = true, SetLastError = true)>]
extern bool AdjustTokenPrivileges
    ( IntPtr TokenHandle
    , bool DisableAllPrivileges
    , TOKEN_PRIVILEGES* NewState
    , int BufferLength
    , IntPtr PreviousState
    , IntPtr ReturnLength)