namespace Ditto.Internal
{
    public class CloningMapCommand : IMapCommand
    {
        private readonly IMapCommand inner;
        private readonly IInvoke invoke;

        public CloningMapCommand(IInvoke invoke, IMapCommand inner)
        {
            this.inner = inner;
            this.invoke = invoke;
        }

        public TDest Map<TDest>(object source)
        {
            return inner.Map<TDest>(invoke.Copy(source));
        }

        public TDest Map<TDest>(object source, TDest dest)
        {
            return inner.Map(invoke.Copy(source), dest);
        }
    }
}