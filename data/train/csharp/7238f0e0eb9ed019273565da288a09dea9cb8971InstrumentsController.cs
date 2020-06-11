using System.Collections.Generic;
using System.Web.Http;
using Musicfy.Bll.Contracts;
using Musicfy.Bll.Models;
using MusicfyApi.Attributes;

namespace MusicfyApi.Controllers
{
    public class InstrumentsController : ApiController
    {
        private readonly IInstrumentService _instrumentService;

        public InstrumentsController(IInstrumentService instrumentService)
        {
            _instrumentService = instrumentService;
        }

        [HttpGet]
        [CustomAuthorize]
        public IEnumerable<InstrumentModel> Get()
        {
            return _instrumentService.GetAll();
        }

        [HttpGet]
        [CustomAuthorize]
        public InstrumentModel Get([FromUri] string id)
        {
            return _instrumentService.GetById(id);
        }

        [HttpPost]
        [CustomAuthorize(true)]
        public void Post([FromBody] InstrumentModel instrumentModel)
        {
            _instrumentService.Add(instrumentModel);
        }

        [HttpPut]
        [CustomAuthorize(true)]
        public void Put([FromUri] string id, [FromBody] InstrumentModel instrumentModel)
        {
            _instrumentService.Update(id, instrumentModel);
        }

        [HttpDelete]
        [CustomAuthorize(true)]
        public void Delete([FromUri] string id)
        {
            _instrumentService.Delete(id);
        }
    }
}