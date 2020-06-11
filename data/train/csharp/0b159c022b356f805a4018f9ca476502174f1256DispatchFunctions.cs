using IFVM.Ast;

namespace IFVM.Glulx.Functions
{
    public static class DispatchFunctions
    {
        public const int GestaultId = 1;
        public const int GlkId = 2;
        public const int SetIOSystemId = 3;

        public static readonly DispatchFunction Gestault = new DispatchFunction(GestaultId, "gestault");
        public static readonly DispatchFunction Glk = new DispatchFunction(GlkId, "glk");
        public static readonly DispatchFunction SetIOSystem = new DispatchFunction(SetIOSystemId, "set-io-system");
    }
}
