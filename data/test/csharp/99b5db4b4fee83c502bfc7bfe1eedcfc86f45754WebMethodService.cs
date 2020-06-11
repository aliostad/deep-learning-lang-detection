// <copyright>
//   Copyright (c) Microsoft Corporation.  All rights reserved.
// </copyright>

namespace Microsoft.ApplicationServer.Common.Test.Services
{
    using System.ServiceModel;
    using System.ServiceModel.Web;

    [ServiceContract]
    public class WebMethodService
    {
        [OperationContract]
        public void NoAttributeOperation()
        {
        }

        [WebInvoke]
        public void WebInvokeOperation()
        {
        }

        [WebGet]
        public void WebGetOperation()
        {
        }

        [WebInvoke(Method="GET")]
        public void WebInvokeGetOperation()
        {
        }

        [WebInvoke(Method = "Get")]
        public void WebInvokeGetLowerCaseOperation()
        {
        }

        [WebInvoke(Method = "POST")]
        public void WebInvokePostOperation()
        {
        }

        [WebInvoke(Method = "PUT")]
        public void WebInvokePutOperation()
        {
        }

        [WebInvoke(Method = "DELETE")]
        public void WebInvokeDeleteOperation()
        {
        }

        [WebInvoke(Method = "CUSTOM")]
        public void WebInvokeCustomOperation()
        {
        }
    }
}
