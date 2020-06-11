using System;

namespace Perenis.Core.Decoupling.Multimethods
{
    [Flags]
    public enum DispatchStatus
    {
        Success = 1,
        NoMatch = 2,
        AmbiguousMatch = 4,
        DynamicInvoke = 8
    }

    public struct DispatchResult
    {
        private DispatchStatus _status;

        internal DispatchResult(DispatchStatus status)
            : this()
        {
            _status = status;
        }

        public object ReturnValue { get; internal set; }

        public bool Success
        {
            get { return (_status & DispatchStatus.Success) == DispatchStatus.Success; }
        }

        public bool AmbiguousMatch
        {
            get { return (_status & DispatchStatus.AmbiguousMatch) == DispatchStatus.AmbiguousMatch; }
        }

        public bool NoMatch
        {
            get { return (_status & DispatchStatus.NoMatch) == DispatchStatus.NoMatch; }
        }

        public bool IsDynamicInvoke
        {
            get { return (_status & DispatchStatus.DynamicInvoke) == DispatchStatus.DynamicInvoke; }
            internal set { _status |= DispatchStatus.DynamicInvoke; }
        }

        public DispatchResult<R> Typed<R>()
        {
            var result = new DispatchResult<R>(_status);
            if (ReturnValue != null)
            {
                result.ReturnValue = (R) ReturnValue;
            }
            return result;
        }
    }

    public struct DispatchResult<R>
    {
        private readonly DispatchStatus _status;

        internal DispatchResult(DispatchStatus status)
            : this()
        {
            _status = status;
        }

        public R ReturnValue { get; internal set; }

        public bool Success
        {
            get { return (_status & DispatchStatus.Success) == DispatchStatus.Success; }
        }

        public bool AmbiguousMatch
        {
            get { return (_status & DispatchStatus.AmbiguousMatch) == DispatchStatus.AmbiguousMatch; }
        }

        public bool NoMatch
        {
            get { return (_status & DispatchStatus.NoMatch) == DispatchStatus.NoMatch; }
        }

        public bool IsDynamicInvoke
        {
            get { return (_status & DispatchStatus.DynamicInvoke) == DispatchStatus.DynamicInvoke; }
        }
    }
}