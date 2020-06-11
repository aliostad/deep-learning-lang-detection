using System;
using FubuMVC.Core.Behaviors;
using NUnit.Framework;

namespace HitThatLine.Tests.Utility
{
    public class MockActionBehavior : IActionBehavior
    {
        private Action _invokeAction = () => { };
        private Action _invokePartialAction = () => { };
        private bool _invoked;
        private bool _partialInvoked;

        public MockActionBehavior()
        {
            _invoked = false;
            _partialInvoked = false;
        }

        public MockActionBehavior OnInvoke(Action invokeAction)
        {
            _invokeAction = invokeAction;
            return this;
        }

        public MockActionBehavior OnInvokePartial(Action invokePartialAction)
        {
            _invokePartialAction = invokePartialAction;
            return this;
        }

        public void Invoke()
        {
            _invoked = true;
            _invokeAction();
        }

        public void InvokePartial()
        {
            _partialInvoked = true;
            _invokePartialAction();
        }

        public void VerifyInvoked()
        {
            if (!_invoked) throw new AssertionException("Behavior not invoked!");
        }

        public void VerifyPartialInvoked()
        {
            if (!_partialInvoked) throw new AssertionException("PartialBehavior not invoked!");
        }
    }
}