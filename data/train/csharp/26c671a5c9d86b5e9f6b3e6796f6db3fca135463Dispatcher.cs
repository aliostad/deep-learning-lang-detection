
using System;

namespace DynamicDispatch
{
    public class Dispatcher
    {
        public void Dispatch(A instance)
        {
            instance.Dispatch();
        }
    }

    public class A
    {
        public virtual void Dispatch()
        {
            Console.WriteLine("Dispatching A");
        }
    }

    public class B : A
    {
        public override void Dispatch()
        {
            Console.WriteLine("Dispatching B");
        }
    }

    public class C : B
    {
        public override void Dispatch()
        {
            Console.WriteLine("Dispatching C");
        }
    }
}
