using System;

/// ******************************************************************************************************************
/// * Copyright (c) 2011 Dialect Software LLC                                                                        *
/// * This software is distributed under the terms of the Apache License http://www.apache.org/licenses/LICENSE-2.0  *
/// *                                                                                                                *
/// ******************************************************************************************************************

namespace DialectSoftware.Composition
{
    public interface IRuntimeContext<T>
    {
        object Target { get; }
        event BeginInvokeEventHandler<T> OnBeginInvokeEvent;
        event InvokeEventHandler<T> OnInvokeEvent;
        event EndInvokeEventHandler<T> OnEndInvokeEvent;
        event InvokeErrorEventHandler<T> OnInvokeErrorEvent;
    }
}
