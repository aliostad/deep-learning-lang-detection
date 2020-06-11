using System;
using System.Collections.Generic;
using System.Text;
using System.Threading;

namespace Intact.ParallelLib
{
    internal class UnconstantInvokeSynchronisationContainer : SynchronisationContainer
    {
        private ParallelQueue<InvokePart> parallelQueue;

        public ParallelQueue<InvokePart> ParallelQueue
        {
            get { return parallelQueue; }
            set { parallelQueue = value; }
        }
        private ParallelQueue<InvokePart>[] parallelQueues;

        public ParallelQueue<InvokePart>[] ParallelQueues
        {
            get { return parallelQueues; }
            set { parallelQueues = value; }
        }

        internal UnconstantInvokeSynchronisationContainer(ManualResetEvent manualResetEvent,
            ParallelQueue<InvokePart> parallelQueue, ParallelQueue<InvokePart>[] parallelQueues) 
            : base(manualResetEvent)
        {
            this.parallelQueue = parallelQueue;
            this.parallelQueues = parallelQueues;
        }

        internal UnconstantInvokeSynchronisationContainer(ManualResetEvent manualResetEvent)
            : base(manualResetEvent)
        {
        }
    }

    internal class UnconstantInvokeSynchronisationContainer<T> : UnconstantInvokeSynchronisationContainer
    {
        private ParallelQueue<InvokePart<T>> parallelQueue;

        public new ParallelQueue<InvokePart<T>> ParallelQueue
        {
            get { return parallelQueue; }
            set { parallelQueue = value; }
        }

        private ParallelQueue<InvokePart<T>>[] parallelQueues;

        public new ParallelQueue<InvokePart<T>>[] ParallelQueues
        {
            get { return parallelQueues; }
            set { parallelQueues = value; }
        }

        internal UnconstantInvokeSynchronisationContainer(ManualResetEvent manualResetEvent,
            ParallelQueue<InvokePart<T>> parallelQueue, ParallelQueue<InvokePart<T>>[] parallelQueues)
            : base(manualResetEvent)
        {
            this.parallelQueue = parallelQueue;
            this.parallelQueues = parallelQueues;
        }
    }

    internal class UnconstantInvokeSynchronisationContainer<T, T1> : UnconstantInvokeSynchronisationContainer
    {
        private ParallelQueue<InvokePart<T, T1>> parallelQueue;

        public new ParallelQueue<InvokePart<T, T1>> ParallelQueue
        {
            get { return parallelQueue; }
            set { parallelQueue = value; }
        }

        private ParallelQueue<InvokePart<T, T1>>[] parallelQueues;

        public new ParallelQueue<InvokePart<T, T1>>[] ParallelQueues
        {
            get { return parallelQueues; }
            set { parallelQueues = value; }
        }

        internal UnconstantInvokeSynchronisationContainer(ManualResetEvent manualResetEvent,
            ParallelQueue<InvokePart<T, T1>> parallelQueue, ParallelQueue<InvokePart<T, T1>>[] parallelQueues)
            : base(manualResetEvent)
        {
            this.parallelQueue = parallelQueue;
            this.parallelQueues = parallelQueues;
        }
    }
}
