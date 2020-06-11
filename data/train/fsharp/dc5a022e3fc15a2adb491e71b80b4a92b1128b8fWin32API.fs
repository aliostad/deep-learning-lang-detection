module Win32API

open System
open System.Runtime.InteropServices

// This part of Code I want on C++0x CLI

module HackAPI =

    [<DllImport("kernel32.dll")>]
    extern Int32 WriteProcessMemory(IntPtr hProcess, IntPtr lpBaseAddress, byte[] lpBuffer, int dwsize, [<Out>] int lpNumberOfBytesRead);

    [<DllImport("kernel32.dll")>]
    extern bool VirtualProtectEx(IntPtr hProcess, IntPtr lpAddress, uint32 dwSize, uint32 flNewProtect, [<Out>] uint32 lpflOldProtect)

module GFXAPI =

    [<DllImport(@"User32", CharSet = CharSet.Ansi, SetLastError = false, ExactSpelling = true)>]
    extern void LockWindowUpdate(int hWnd)