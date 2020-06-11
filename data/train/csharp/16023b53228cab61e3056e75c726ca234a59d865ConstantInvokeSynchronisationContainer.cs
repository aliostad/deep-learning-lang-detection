using System;
using System.Collections.Generic;
using System.Text;
using System.Threading;

namespace Intact.ParallelLib
{
    internal class ConstantInvokeSynchronisationContainer : SynchronisationContainer
    {
        private InvokePart invokePart_;

        public InvokePart InvokePart_
        {
            get { return invokePart_; }
            set { invokePart_ = value; }
        }

        #region public ForSynchronisationContainer()

        public ConstantInvokeSynchronisationContainer(ManualResetEvent manualResetEvent)
            : base(manualResetEvent)
        {            
        }

        public ConstantInvokeSynchronisationContainer(ManualResetEvent manualResetEvent, InvokePart invokePart_)
            : base(manualResetEvent)
        {
            this.invokePart_ = invokePart_;
        }

        #endregion
    }

    internal class ConstantInvokeSynchronisationContainer<T> : ConstantInvokeSynchronisationContainer
    {
        private InvokePart<T> invokePart_;

        public new InvokePart<T> InvokePart_
        {
            get { return invokePart_; }
            set { invokePart_ = value; }
        }
      
        public ConstantInvokeSynchronisationContainer(ManualResetEvent manualResetEvent, InvokePart<T> invokePart)
            : base(manualResetEvent)
        {
            this.invokePart_ = invokePart;
        }
    }

    internal class ConstantInvokeSynchronisationContainer<T1, T2> : ConstantInvokeSynchronisationContainer
    {
        private InvokePart<T1, T2> invokePart_;

        public new InvokePart<T1, T2> InvokePart_
        {
            get { return invokePart_; }
            set { invokePart_ = value; }
        }        

        public ConstantInvokeSynchronisationContainer(ManualResetEvent manualResetEvent, InvokePart<T1, T2> invokePart)
            : base(manualResetEvent)
        {
            this.invokePart_ = invokePart;
        }        
    }
}
