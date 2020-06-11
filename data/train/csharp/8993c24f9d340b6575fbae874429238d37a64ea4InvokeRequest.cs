using System;
using Nuxleus.Command;

namespace Nuxleus.Core {

    public delegate void AsyncRequest (IRequest request);

    public struct InvokeRequest : ICommand {
        IRequest m_request;
        AsyncRequest m_invokeRequest;

        public InvokeRequest (Agent agent, IRequest request) {
            m_request = request;
            m_invokeRequest = new AsyncRequest(agent.BeginRequest);
        }

        public void Execute () {
            m_invokeRequest.BeginInvoke(m_request, this.Callback, null);
        }

        private void Callback (IAsyncResult ar) {
            m_invokeRequest.EndInvoke(ar);

            ///TODO: Process and serialize result.
            ///TODO: Add result to Result Hashtable
        }

    }
}
