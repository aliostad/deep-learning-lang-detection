namespace DoubleDispatch.Dispatch
{
    using System;

    public class DoubleDispatcher
    {
        public void DynamicDispatch(Base x) => Dispatch((dynamic)x);

        private void Dispatch(Base @base)
        {
            Console.WriteLine($"Method {nameof(Dispatch)}({nameof(Base)}) - type: {@base.GetType()}");
        }

        private void Dispatch(Foo foo)
        {
            Console.WriteLine($"Method {nameof(Dispatch)}({nameof(Foo)}) - type: {foo.GetType()}");

        }

        private void Dispatch(Bar bar)
        {
            Console.WriteLine($"Method {nameof(Dispatch)}({nameof(Bar)}) - type: {bar.GetType()}");
        }

        private void Dispatch(Baz baz)
        {
            Console.WriteLine($"Method {nameof(Dispatch)}({nameof(Baz)}) - type: {baz.GetType()}");
        }
    }
}
