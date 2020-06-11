using System.Web.Http;
using Exam.Api.Framework;
using Exam.Api.Models;

namespace Exam.Api.Controllers
{
    public class HomeController : BaseApiController
    {
        [HttpGet]
        public ApiResponse Welcome()
        {
            return ApiOk("Welcome to exam");
        }

        [HttpPost]
        public ApiResponse ImportUserTeam([FromBody] object file)
        {
            return ApiOk();
        }

        [HttpPost]
        public ApiResponse Handler(ApiRequestData data)
        {
            return ApiOk();
        }
    }
}