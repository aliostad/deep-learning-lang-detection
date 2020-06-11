namespace Allors.Web
{
    using System;
    using System.Linq;

    using Allors.Domain;
    using Allors.Meta;
    using Allors.Web.Workspace;

    public class InvokeResponseBuilder
    {
        private readonly ISession session;
        private readonly InvokeRequest invokeRequest;
        private string @group;
        private User user;

        public InvokeResponseBuilder(ISession session, User user, InvokeRequest invokeRequest, string @group)
        {
            this.session = session;
            this.user = user;
            this.invokeRequest = invokeRequest;
            this.group = group;
        }

        public InvokeResponse Build()
        {
            if (this.invokeRequest.M == null || this.invokeRequest.I == null || this.invokeRequest.V == null)
            {
                throw new ArgumentException();
            }

            var obj = this.session.Instantiate(this.invokeRequest.I);
            var composite = (Composite)obj.Strategy.Class;
            var methodTypes = composite.MethodTypesByGroup[@group];
            var methodType = methodTypes.FirstOrDefault(x => x.Name.Equals(this.invokeRequest.M));

            if (methodType == null)
            {
                throw new Exception("Method " + this.invokeRequest.M + " not found.");   
            }
            
            var invokeResponse = new InvokeResponse();

            if (!this.invokeRequest.V.Equals(obj.Strategy.ObjectVersion.ToString()))
            {
                invokeResponse.AddVersionError(obj);
            }
            else
            {
                var acl = new AccessControlList(obj, this.user);
                if (acl.CanExecute(methodType))
                {
                    var method = obj.GetType().GetMethod(methodType.Name, new Type[] { });
                    method.Invoke(obj, null);

                    var derivationLog = this.session.Derive();
                    if (!derivationLog.HasErrors)
                    {
                        this.session.Commit();
                    }
                    else
                    {
                        invokeResponse.AddDerivationErrors(derivationLog);
                    }
                }
                else
                {
                    invokeResponse.AddAccessError(obj);
                }
            }

            return invokeResponse;
        }
    }
}