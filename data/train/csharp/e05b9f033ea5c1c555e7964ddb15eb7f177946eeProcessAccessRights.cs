using System;

namespace TimeZero.Auction.Bot.Classes.MemoryEditor
{
    [Flags]
    internal enum ProcessAccessRights : uint
    {
        PROCESS_TERMINATE           = (0x00000001),
        PROCESS_CREATE_THREAD       = (0x00000002),
        PROCESS_SET_SESSIONID       = (0x00000004),
        PROCESS_VM_OPERATION        = (0x00000008),
        PROCESS_VM_READ             = (0x00000010),
        PROCESS_VM_WRITE            = (0x00000020),
        PROCESS_DUP_HANDLE          = (0x00000040),
        PROCESS_CREATE_PROCESS      = (0x00000080),
        PROCESS_SET_QUOTA           = (0x00000100),
        PROCESS_SET_INFORMATION     = (0x00000200),
        PROCESS_QUERY_INFORMATION   = (0x00000400),
        PROCESS_ALL_ACCESS          = (0x001F0FFF),
    }
}
