using IL2AsmTranspiler.Interfaces;
using IL2AsmTranspiler.Interfaces.CodeChunks;

namespace IL2AsmTranspiler.Implementations.CodeChunks.Instructions
{
    internal class CallInstructionChunk : ICodeChunk
    {
        private readonly IMethodCodeChunk _methodChunk;

        public CallInstructionChunk(IMethodCodeChunk methodChunk)
        {
            _methodChunk = methodChunk;
            Code = GetCode();
        }
        private IMnemonicsStream GetCode()
        {
            if (!_methodChunk.HasReturnValue)
            {
                return MnemonicStreamFactory.Create($"call {_methodChunk.Label}");
            }

            return MnemonicStreamFactory.Create($"call {_methodChunk.Label}", "push eax");
        }

        public IMnemonicsStream Code { get; }
    }
}
