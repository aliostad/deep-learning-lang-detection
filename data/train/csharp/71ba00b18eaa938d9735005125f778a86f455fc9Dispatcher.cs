#region copyright
// Copyright 2016 Ashley Richmond
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
#endregion

using Flux.Payloads;
using System;
using System.Collections.Generic;

namespace Flux
{
    public class Dispatcher
    {
        protected Dictionary<DispatchToken, Action<IPayload>> callbackRegistry = new Dictionary<DispatchToken, Action<IPayload>>();
        protected IPayload currentPayload = null;
        protected List<DispatchToken> isPending = new List<DispatchToken>();
        protected List<DispatchToken> isHandled = new List<DispatchToken>();

        public bool IsDispatching { get; protected set; }

        public string Version
        {
            get
            {
                return System.Reflection.Assembly.GetExecutingAssembly().GetName().Version.ToString();
            }
        }

        /// <summary>
        /// Registers a callback to receive dispatched messages.
        /// </summary>
        /// <param name="callback"></param>
        /// <returns></returns>
        public DispatchToken Register(Action<IPayload> callback)
        {
            DispatchToken dispatchToken = new DispatchToken();
            callbackRegistry.Add(dispatchToken, callback);
            return dispatchToken;
        }

        /// <summary>
        /// Removes a callback from the registry.
        /// </summary>
        /// <param name="dispatchToken"></param>
        public void Deregister(DispatchToken dispatchToken)
        {
            if (!HasRegistered(dispatchToken))
                throw new DispatcherExceptions.InvalidCallbackException();

            callbackRegistry.Remove(dispatchToken);
        }

        /// <summary>
        /// Checks if the given dispatch token exists in the callback registry.
        /// </summary>
        /// <param name="dispatchToken"></param>
        /// <returns></returns>
        public bool HasRegistered(DispatchToken dispatchToken)
        {
            return dispatchToken != null && callbackRegistry.ContainsKey(dispatchToken);
        }

        /// <summary>
        /// Sends a payload to all registered callbacks.
        /// </summary>
        /// <param name="payload"></param>
        public void Dispatch(IPayload payload)
        {
            if (IsDispatching)
                throw new DispatcherExceptions.AlreadyDispatchingException();

            startDispatching(payload);

            try
            {
                foreach (KeyValuePair<DispatchToken, Action<IPayload>> callback in callbackRegistry)
                {
                    if (isPending.Contains(callback.Key))
                        continue;

                    invokeCallback(callback.Key);
                }
            }
            finally
            {
                stopDispatching();
            }
        }
        /// <summary>
        /// Sends a payload to all registered callbacks.
        /// </summary>
        /// <param name="action"></param>
        /// <param name="data"></param>
        public void Dispatch(string action, object data)
        {
            Dispatch(new Payload(action, data));
        }
        /// <summary>
        /// Sends an empty action to all registered callbacks.
        /// </summary>
        /// <param name="action"></param>
        public void Dispatch(string action)
        {
            Dispatch(new Payload(action, null));
        }

        /// <summary>
        /// Initiates the dispatch process.
        /// </summary>
        /// <param name="payload"></param>
        protected void startDispatching(IPayload payload) {
            isPending = new List<DispatchToken>();
            isHandled = new List<DispatchToken>();
            currentPayload = payload;
            IsDispatching = true;
        }

        /// <summary>
        /// Finalises the dispatch process.
        /// </summary>
        protected void stopDispatching()
        {
            currentPayload = null;
            IsDispatching = false;
        }

        /// <summary>
        /// Allows a callback to wait for another callback to complete.
        /// </summary>
        /// <param name="dispatchTokenList"></param>
        public void WaitFor(List<DispatchToken> dispatchTokenList)
        {
            if (!IsDispatching)
                throw new DispatcherExceptions.NotDispatchingException();

            dispatchTokenList.ForEach((DispatchToken dispatchToken) =>
            {
                if (isPending.Contains(dispatchToken) || isHandled.Contains(dispatchToken))
                    throw new DispatcherExceptions.CircularDependecyException();

                if (!callbackRegistry.ContainsKey(dispatchToken))
                    throw new DispatcherExceptions.InvalidCallbackException();

                invokeCallback(dispatchToken);
            });
        }
        public void WaitFor(DispatchToken dispatchToken)
        {
            WaitFor(new List<DispatchToken>() { dispatchToken });
        }

        /// <summary>
        /// Invokes a given callback by its dispatch token.
        /// </summary>
        /// <param name="dispatchToken"></param>
        protected void invokeCallback(DispatchToken dispatchToken)
        {
            isPending.Add(dispatchToken);
            callbackRegistry[dispatchToken](currentPayload);
            isHandled.Add(dispatchToken);
        }
    }
}
