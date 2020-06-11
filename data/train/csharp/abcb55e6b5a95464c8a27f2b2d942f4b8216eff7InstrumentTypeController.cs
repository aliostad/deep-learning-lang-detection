using System.Collections.Generic;
using System.Web.Http;
using Bd.Icm.Core;

namespace Bd.Icm.Web.Controllers
{
    [AuthorizedRoles(Roles = new[] { RoleType.Administrator, RoleType.Contributor, RoleType.ReadOnly })]
    public class InstrumentTypeController : ApiControllerBase
    {
        [Route("api/instrumentTypes")]
        [HttpGet]
        public IHttpActionResult GetAll()
        {
            var instrumentTypes = new List<Dto.InstrumentType>
            {
                new Dto.InstrumentType {InstrumentTypeId = 0, Name = "N/A"},
                new Dto.InstrumentType {InstrumentTypeId = 1, Name = "FERT"},
            };
            return Ok(instrumentTypes);
        }
    }
}
