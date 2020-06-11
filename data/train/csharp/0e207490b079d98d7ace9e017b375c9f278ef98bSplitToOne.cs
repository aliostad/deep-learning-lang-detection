using System;

namespace L4p.Common.Concerns
{
    public class SplitToOne<T>
        where T: class
    {
        private readonly T _impl;
        private readonly T _child;

        protected SplitToOne(T impl, T child)
        {
            _impl = impl;
            _child = child;
        }

        protected void dispatch(Action<T> dispatchTo)
        {
            dispatchTo(_child);
            dispatchTo(_impl);
        }

        protected R dispatch<R>(Func<T, R> dispatchTo)
        {
            dispatchTo(_child);
            return dispatchTo(_impl);
        }
    }
}