namespace MUDT.Diagnostics

  open System.Diagnostics
  open MUDT.Diagnostics

  module CurrentProcessInfo =
    open System.Runtime.InteropServices

    // Caching provides minimal memory impact, it allows for refreshing upon retrieval
    // A non cached back to back call on printProcessMemoryInfo2()
    // produced a memory difference of 729088 bytes
    // Cached back to back call produced 45056 byte diff
    let private currentProcess() : Process =
      let cacheKey = "current-process"
      let cachedProcess = Cache.tryGetCachedItem cacheKey
      let mutable proc = null : Process
      if (cachedProcess.IsNone) then
        proc <- Process.GetCurrentProcess()
        Cache.cacheItem cacheKey proc
      else
        proc <- (cachedProcess.Value :?> Process)
      proc.Refresh() // Process class caches, refresh updates cache
      proc

    let totalUsedPhysicalMemory() =
      (currentProcess()).WorkingSet64

    // On *nix based OSes, Process is very limited as to
    //  memory stats. You can't even get the amount of RAM
    //  a system has. 
    // So, as a workaround, user will need to set a limit
    //  this limit is mostly used by MemoryMappedFile.fs
    let mutable private memoryLimit = 0L

    let setMemoryLimit (limit:int64) =
      if memoryLimit = 0L then memoryLimit <- limit // can only set once

    let getMemoryLimit() = memoryLimit

    let printProcessMemoryInfo() =
      let cp = currentProcess()
      printfn "Process Physical Memory Allocation: %d" cp.WorkingSet64
      printfn "Process Physical Memory Usage: %d" cp.PeakWorkingSet64
      printfn "Process Virtual Memory Allocation: %d" cp.VirtualMemorySize64
      printfn "Process Virtual Memory Usage: %d" cp.PeakVirtualMemorySize64
      printfn "Process Private Memory Allocation: %d" cp.PrivateMemorySize64

    type Platform = | MacOS | Linux | Windows

    let getPlatform() =
      if RuntimeInformation.IsOSPlatform(OSPlatform.OSX) then MacOS
      elif RuntimeInformation.IsOSPlatform(OSPlatform.Linux) then Linux
      else Windows