using System;
using System.Runtime.InteropServices;

namespace NDceRpc.Microsoft.Interop
{
    [StructLayout(LayoutKind.Sequential)]
    public struct RPC_DISPATCH_TABLE
    {
        public uint DispatchTableCount;
        /// <summary>
        /// Pointer to first <see cref="RPC_DISPATCH_FUNCTION"/>
        /// </summary>
        public IntPtr DispatchTable;

        public RPC_DISPATCH_FUNCTION FirstDispatchFunction
        {
            get
            {
                return (RPC_DISPATCH_FUNCTION)Marshal.GetDelegateForFunctionPointer(DispatchTable, typeof(RPC_DISPATCH_FUNCTION));
            }
        }

        public IntPtr Reserved;
    }
}