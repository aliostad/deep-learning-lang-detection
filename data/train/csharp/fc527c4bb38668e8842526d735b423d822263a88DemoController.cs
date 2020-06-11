using System.Web.OData;
using %s.Api;

namespace %s.Controllers
{
    public class DemoController : ODataController
    {
        private DemoApi api;

        private DemoApi Api
        {
            get
            {
                if (api == null)
                {
                    api = new DemoApi();
                }

                return api;
            }
        }

        private DemoContext DbContext
        {
            get
            {
                return Api.Context;
            }
        }

        // Add operation routers here.

        /// <summary>
        /// Disposes the API and the controller.
        /// </summary>
        /// <param name="disposing">Indicates whether disposing is happening.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                if (this.api != null)
                {
                    this.api.Dispose();
                }
            }

            base.Dispose(disposing);
        }
    }
}