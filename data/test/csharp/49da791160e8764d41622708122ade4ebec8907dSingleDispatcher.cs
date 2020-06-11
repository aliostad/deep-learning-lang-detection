namespace DoubleDispatch.Dispatch
{
    using System;

    public class SingleDispatcher
    {
        public void Dispatch(Base @base)
        {
            Console.WriteLine($"Method {nameof(Dispatch)}({nameof(Base)}) - type: {@base.GetType()}");
        }

        public void Dispatch(Foo foo)
        {
            Console.WriteLine($"Method {nameof(Dispatch)}({nameof(Foo)}) - type: {foo.GetType()}");

        }

        public void Dispatch(Bar bar)
        {
            Console.WriteLine($"Method {nameof(Dispatch)}({nameof(Bar)}) - type: {bar.GetType()}");
        }

        public void Dispatch(Baz baz)
        {
            Console.WriteLine($"Method {nameof(Dispatch)}({nameof(Baz)}) - type: {baz.GetType()}");
        }
    }
}
