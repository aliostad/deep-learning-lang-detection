using Microsoft.Restier.WebApi;
using ClassroomWebService.Models;

namespace ClassroomWebService.Controllers
{
    public class ClassroomController : RestierController
    {
        private ClassroomApi api;

        private ClassroomApi Api
        {
            get
            {
                if (api == null)
                {
                    api = new ClassroomApi();
                }

                return api;
            }
        }

        private ClassroomContext DbContext
        {
            get
            {
                return Api.Context;
            }
        }
    }
}