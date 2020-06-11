using System.Collections.Generic;
using Microsoft.AspNetCore.Mvc;
using DrxApi.Models;
using AutoMapper;
using DrxApi.Services;

namespace DrxApi.Controllers
{
    [Route("api/[controller]")]
    public class InstrumentsController : Controller
    {
        private readonly IInstrumentService _instrumentService;
        private readonly IMapper _mapper;

        public InstrumentsController(IInstrumentService instrumentService, IMapper mapper)
        {
            _instrumentService = instrumentService;
            _mapper = mapper;
        }  

        // GET api/instruments
        [HttpGet]
        public IActionResult GetAll()
        {
            var instruments = _instrumentService.ListAll();
            var instrumentsDTO = _mapper.Map<IEnumerable<InstrumentDTO>>(instruments);
            return new OkObjectResult(instrumentsDTO);
        }

        // GET api/instruments/{id}
        [HttpGet("{id}", Name = "GetInstrument")]
        public IActionResult GetById(long id)
        {
            var item = _instrumentService.GetById(id);
            if (item == null)
            {
                return NotFound();
            }
            var instrument = _mapper.Map<InstrumentDTO>(item);
            return new OkObjectResult(instrument);
        }

        // POST api/isntruments
        [HttpPost]
        public IActionResult Create([FromBody] InstrumentDTO item)
        {
            if (item == null)
            {
                return BadRequest();
            }

            var instrument = _mapper.Map<Instrument>(item);
            if (instrument == null)
            {
                return BadRequest();
            }

            _instrumentService.Add(instrument);

            return CreatedAtRoute("GetInstrument", new { id = instrument.Id }, item);
        }

        // PUT api/instruments/5
        [HttpPut("{id}")]
        public IActionResult Update(long id, [FromBody] InstrumentDTO item)
        {
            if (item == null || item.Id != id)
            {
                return BadRequest();
            }

            var i = _instrumentService.GetById(id);
            if (i == null)
            {
                return NotFound();
            }

            var instrument = _mapper.Map<Instrument>(item);

            _instrumentService.Update(instrument);

            return new NoContentResult();
        }

        // DELETE api/instruments/5
        [HttpDelete("{id}")]
        public IActionResult Delete(long id)
        {
            
            var item = _instrumentService.GetById(id);
            if (item == null)
            {
                return NotFound();
            }

            _instrumentService.Remove(item);

            return new NoContentResult();
        }
    }
}