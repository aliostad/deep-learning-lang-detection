using System;
using System.Runtime.InteropServices;

namespace IOPriorityGuard.Native
{
    internal enum PROCESS_INFORMATION_CLASS
    {
        ProcessBasicInformation = 0,
        ProcessQuotaLimits,
        ProcessIoCounters,
        ProcessVmCounters,
        ProcessTimes,
        ProcessBasePriority,
        ProcessRaisePriority,
        ProcessDebugPort,
        ProcessExceptionPort,
        ProcessAccessToken,
        ProcessLdtInformation,
        ProcessLdtSize,
        ProcessDefaultHardErrorMode,
        ProcessIoPortHandlers,
        ProcessPooledUsageAndLimits,
        ProcessWorkingSetWatch,
        ProcessUserModeIOPL,
        ProcessEnableAlignmentFaultFixup,
        ProcessPriorityClass,
        ProcessWx86Information,
        ProcessHandleCount,
        ProcessAffinityMask,
        ProcessPriorityBoost,
        ProcessDeviceMap,
        ProcessSessionInformation,
        ProcessForegroundInformation,
        ProcessWow64Information,
        ProcessImageFileName,
        ProcessLUIDDeviceMapsEnabled,
        ProcessBreakOnTermination,
        ProcessDebugObjectHandle,
        ProcessDebugFlags,
        ProcessHandleTracing,
        ProcessIoPriority,
        ProcessExecuteFlags,
        ProcessResourceManagement,
        ProcessCookie,
        ProcessImageInformation,
        ProcessCycleTime,
        ProcessPagePriority,
        ProcessInstrumentationCallback,
        ProcessThreadStackAllocation,
        ProcessWorkingSetWatchEx,
        ProcessImageFileNameWin32,
        ProcessImageFileMapping,
        ProcessAffinityUpdateMode,
        ProcessMemoryAllocationMode,
        MaxProcessInfoClass
    }

    internal enum STANDARD_RIGHTS : uint
    {
        WRITE_OWNER = 524288,
        WRITE_DAC = 262144,
        READ_CONTROL = 131072,
        DELETE = 65536,
        SYNCHRONIZE = 1048576,
        STANDARD_RIGHTS_REQUIRED = 983040,
        STANDARD_RIGHTS_WRITE = READ_CONTROL,
        STANDARD_RIGHTS_EXECUTE = READ_CONTROL,
        STANDARD_RIGHTS_READ = READ_CONTROL,
        STANDARD_RIGHTS_ALL = 2031616,
        SPECIFIC_RIGHTS_ALL = 65535,
        ACCESS_SYSTEM_SECURITY = 16777216,
        MAXIMUM_ALLOWED = 33554432,
        GENERIC_WRITE = 1073741824,
        GENERIC_EXECUTE = 536870912,
        GENERIC_READ = UInt16.MaxValue,
        GENERIC_ALL = 268435456
    }

    internal enum PROCESS_RIGHTS : uint
    {
        PROCESS_TERMINATE = 1,
        PROCESS_CREATE_THREAD = 2,
        PROCESS_SET_SESSIONID = 4,
        PROCESS_VM_OPERATION = 8,
        PROCESS_VM_READ = 16,
        PROCESS_VM_WRITE = 32,
        PROCESS_DUP_HANDLE = 64,
        PROCESS_CREATE_PROCESS = 128,
        PROCESS_SET_QUOTA = 256,
        PROCESS_SET_INFORMATION = 512,
        PROCESS_QUERY_INFORMATION = 1024,
        PROCESS_SUSPEND_RESUME = 2048,
        PROCESS_QUERY_LIMITED_INFORMATION = 4096,
        PROCESS_ALL_ACCESS = STANDARD_RIGHTS.STANDARD_RIGHTS_REQUIRED | STANDARD_RIGHTS.SYNCHRONIZE | 65535
    }

    internal class Win32
    {
        [DllImport("kernel32.dll", CharSet = CharSet.Auto, SetLastError = true)]
        internal static extern SafeProcessHandle OpenProcess(int access, bool inherit, int processId);

        [DllImport("kernel32.dll", SetLastError = true)]
        public static extern bool CloseHandle(IntPtr hObject);

        [DllImport("ntdll.dll", SetLastError = true)]
        public static extern int NtSetInformationProcess(IntPtr processHandle,
            PROCESS_INFORMATION_CLASS processInformationClass, IntPtr processInformation, uint processInformationLength);

        [DllImport("ntdll.dll", SetLastError = true)]
        public static extern int NtQueryInformationProcess(IntPtr processHandle,
            PROCESS_INFORMATION_CLASS processInformationClass, IntPtr processInformation, int processInformationLength,
            ref int returnLength);
    }
}