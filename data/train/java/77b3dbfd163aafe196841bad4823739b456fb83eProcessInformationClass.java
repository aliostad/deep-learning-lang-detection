package luz.winapi.jna;

/*
 * http://msdn.microsoft.com/en-us/library/ms684280(VS.85).aspx
 * http://undocumented.ntinternals.net/UserMode/Undocumented%20Functions/NT%20Objects/Process/PROCESS_INFORMATION_CLASS.html
 * http://www.codeproject.com/KB/security/AntiReverseEngineering.aspx
 * http://alxr.usatlas.bnl.gov/lxr/source/Gaudi/GaudiKernel/src/Lib/ProcessDescriptor.cpp
 */

public enum ProcessInformationClass{
        ProcessBasicInformation         ( 0),
        ProcessQuotaLimits              ( 1),
        ProcessIoCounters               ( 2),
        ProcessVmCounters               ( 3),
        ProcessTimes                    ( 4),
        ProcessBasePriority             ( 5),
        ProcessRaisePriority            ( 6),
        ProcessDebugPort                ( 7),
        ProcessExceptionPort            ( 8),
        ProcessAccessToken              ( 9),
        ProcessLdtInformation           (10),
        ProcessLdtSize                  (11),
        ProcessDefaultHardErrorMode     (12),
        ProcessIoPortHandlers           (13),
        ProcessPooledUsageAndLimits     (14),
        ProcessWorkingSetWatch          (15),
        ProcessUserModeIOPL             (16),
        ProcessEnableAlignmentFaultFixup(17),
        ProcessPriorityClass            (18),
        ProcessWx86Information          (19),
        ProcessHandleCount              (20),
        ProcessAffinityMask             (21),
        ProcessPriorityBoost            (22),
        MaxProcessInfoClass             (23),
        ProcessEllapsedTime             (24),
       
        ProcessWow64Information         (26),
        ProcessImageFileName            (27),
       
        ProcessDebugObjectHandle        (30),
       
        ProcessExecuteFlags             (34);
       
        private int value;
        ProcessInformationClass(int value) { this.value=value; }
        public int getValue() { return value; }
}
