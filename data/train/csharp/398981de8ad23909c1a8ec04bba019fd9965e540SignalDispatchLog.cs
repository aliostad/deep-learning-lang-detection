/// <copyright file="SignalDispatchLog.cs">Copyright (c) 2016 All Rights Reserved</copyright>
/// <author>Joris van Leeuwen</author>

namespace IoCPlus.Internal {

    public class SignalDispatchLog : ContextLog {
        public AbstractSignal Signal { get; private set; }

        public static SignalDispatchLog Create(AbstractSignal signal) {
            if (!ShouldLog()) { return null; }
            SignalDispatchLog log = Pool<SignalDispatchLog>.Create();
            log.Signal = signal;
            return log;
        }
        public override void Trigger() {
            if (ContextLogger.OnSignalDispatch == null) { return; }
            ContextLogger.OnSignalDispatch(Signal);
            Pool<SignalDispatchLog>.Retire(this);
        }
    }

}