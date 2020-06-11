﻿// Copyright (c) Microsoft Open Technologies, Inc. All rights reserved. See License.txt in the project root for license information.

using System;
using System.Runtime.ExceptionServices;

namespace Microsoft.Owin.Host.SystemWeb.Infrastructure
{
    internal class ErrorState
    {
        private readonly ExceptionDispatchInfo _exceptionDispatchInfo;

        private ErrorState(ExceptionDispatchInfo exceptionDispatchInfo)
        {
            _exceptionDispatchInfo = exceptionDispatchInfo;
        }

        public static ErrorState Capture(Exception exception)
        {
            ExceptionDispatchInfo exceptionDispatchInfo = ExceptionDispatchInfo.Capture(exception);
            return new ErrorState(exceptionDispatchInfo);
        }

        public void Rethrow()
        {
            _exceptionDispatchInfo.Throw();
        }
    }
}