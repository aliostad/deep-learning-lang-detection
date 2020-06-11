using System;

namespace SynchronousMessageSystem
{
    public class ActorMatch
    {
        private readonly ReceiveProcess _receiveProcess;
        private readonly string _receiveProcessName;
        public Type MessageType { get; }
        public ReceiveProcess GetReceiveProcess(Actor actor)
        {
            if (_receiveProcess != null)
                return _receiveProcess;
            ReceiveProcess r = null;
            if (!string.IsNullOrEmpty(_receiveProcessName))
                r = actor.TryGetReceiveProcess(_receiveProcessName);
            return r ?? actor.TryGetReceiveProcess(nameof(Actor.Other));
        }
        public ActorMatch(Type messageType, ReceiveProcess receiveProcess)
        {
            MessageType = messageType;
            _receiveProcess = receiveProcess;
        }
        public ActorMatch(ReceiveProcess receiveProcess)
        {
            _receiveProcess = receiveProcess;
        }
        public ActorMatch(Type messageType, string receiveProcess)
        {
            MessageType = messageType;
            _receiveProcessName = receiveProcess;
        }
        public ActorMatch(string receiveProcess)
        {
            _receiveProcessName = receiveProcess;
        }
        public virtual bool IsMatch(object message) => MessageType == message.GetType();
    }
}
