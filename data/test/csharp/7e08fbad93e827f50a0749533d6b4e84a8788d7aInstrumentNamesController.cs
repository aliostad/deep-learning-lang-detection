using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using AutoMapper;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using trading.Controllers.Resources;
using trading.Models;
using trading.Persistence;
using Trading.Persistence.Interfaces;

namespace trading.Controllers
{
    [Route("/api/instrumentnames")]
    public class InstrumentNameController : Controller
    {
        private readonly IUnitOfWork uow;
        private readonly IMapper mapper;

        public InstrumentNameController(IUnitOfWork uow, IMapper mapper)
        {
            this.mapper = mapper;
            this.uow = uow;
        }

        [HttpGet]
        public IEnumerable<InstrumentNameResource> GetInstrumentNames()
        {
            var instrumentnames = uow.InstrumentNames.GetFull();
            return mapper.Map<IEnumerable<InstrumentName>, IEnumerable<InstrumentNameResource>>(instrumentnames);
        }
        
         [HttpGet("find/{name}")]
          public IActionResult FindInstrumentNames(string name){
           var instrumentName = uow.InstrumentNames.GetFull().FirstOrDefault(x => x.Name == name);
            if(instrumentName == null) return NotFound();
            return Ok(mapper.Map<InstrumentName,InstrumentNameResource>(instrumentName));
          }

         [HttpPost]
         public IActionResult CreateInstrumentName([FromBody] InstrumentName instrumentName){
             if(!ModelState.IsValid)
                return BadRequest(ModelState);
             uow.InstrumentNames.Add(instrumentName);
             uow.Complete();
             var result = mapper.Map<InstrumentName,InstrumentNameResource>(instrumentName);
             return Ok(result);
         }

         [HttpPut("{id}")]
         public IActionResult UpdateInstrumentName(int id,[FromBody] InstrumentName instrumentName){
             if(!ModelState.IsValid)
                return BadRequest(ModelState);
             var existingInstrumentName = uow.InstrumentNames.GetFull().FirstOrDefault(x => x.Id == id);
            if(existingInstrumentName == null){
                return NotFound();
            }
            existingInstrumentName.Name = instrumentName.Name;

             uow.Complete();

            var result = mapper.Map<InstrumentName,InstrumentNameResource>(existingInstrumentName);
            return Ok(result);


         }
        //[Route("/api/instrumentnamesall")]
        //[HttpGet]
        //public async IActionResult GetInstrumentAllNames(){
        //    var query = from n in context.InstrumentNames
        //                from bs in n.BrokerSymbols.DefaultIfEmpty()
        //                from bi in bs.BrokerInstruments.DefaultIfEmpty()
        //            select new InstrumentNameAllResource{Id = n.Id, 
        //                        BrokerSymbolId =  bs.Id, 
        //                        BrokerInstrumentId = bi.Id,
        //                        Name = n.Name, 
        //                        BrokerSymbol = bs.Name, 
        //                        Broker = bs.Exchange.Broker.Name, 
        //                        Exchange=bs.Exchange.Name, 
        //                        Currency = bs.Exchange.Currency.Name, 
        //                        Type =  bi.InstrumentType.Name, 
        //                        Expiry = bi.expiry, 
        //                        Multiplicator = bi.multiplicator};   
        //    IEnumerable<InstrumentNameAllResource> result = await query.ToListAsync();     
        //    return Ok(result);          
        //}

    }
}