using System;

namespace L4p.Common.Concerns
{
    public class SplitToMany<T>
        where T : class
    {
        private readonly T[] _children;
        private readonly T _impl;
    
        protected SplitToMany(T impl, T[] children)
        {
            _impl = impl;
            _children = (T[]) children.Clone();
        }

        protected void dispatch(Action<T> dispatchTo)
        {
            foreach (var child in _children)
                dispatchTo(child);

            dispatchTo(_impl);
        }

        protected R dispatch<R>(Func<T, R> dispatchTo)
        {
            foreach (var child in _children)
                dispatchTo(child);

            return dispatchTo(_impl);
        }
    }
}