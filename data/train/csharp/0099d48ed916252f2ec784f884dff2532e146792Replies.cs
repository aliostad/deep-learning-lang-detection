using System;

namespace Rivet.Broker.Impl
{
    public class Replies : IReply
    {
        public Replies()
        {
            _dispatchQueue = new DispatchQueue();
            _dispatcher = new Dispatcher();
        }

        private readonly DispatchQueue _dispatchQueue;
        private readonly Dispatcher _dispatcher;

        public bool Wait(int milliseconds)
        {
            return _dispatchQueue.WaitOne(milliseconds);
        }

        public bool Dequeue(out object message)
        {
            return _dispatchQueue.Dequeue(out message);
        }

        public void Dispatch(object message)
        {
            _dispatcher.Dispatch(message);
        }

        public void AddAction<T>(Action<T> action)
        {
            _dispatcher.AddAction(action);
        }

        public void Send<T>(T message)
        {
            _dispatchQueue.Enqueue(message);
        }
    }
}