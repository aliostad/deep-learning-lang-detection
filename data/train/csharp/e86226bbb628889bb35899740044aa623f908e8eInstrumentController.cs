using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using PracticeLog.Models;
using musicians_practice_log_api.ViewModels;
using Microsoft.EntityFrameworkCore;

// For more information on enabling Web API for empty projects, visit http://go.microsoft.com/fwlink/?LinkID=397860

namespace musicians_practice_log_api.Controllers
{
    [Route("api/[controller]")]
    public class InstrumentController : Controller
    {
        private PracticeLogContext _context;

        public InstrumentController(PracticeLogContext context)
        {
            _context = context;
        }

        // POST api/instrument/deleteById
        [HttpPost]
        [Route("deleteById")]
        public ResultViewModel DeleteById([FromBody]int instrumentId)
        {
            var instrument = _context.Instruments.SingleOrDefault(s => s.Id == instrumentId);
            if (instrument != null)
            {
                try
                {
                    if (instrument != null)
                    {
                        _context.Remove(instrument);
                        _context.SaveChanges();
                    }
                    return new ResultViewModel(Result.Success, instrument.Name + " was successfully deleted.");
                }
                catch (Exception ex)
                {
                    return new ResultViewModel(Result.Error, "Could not delete " + instrument.Name + ". Try again later.", ex);
                }
            }
            else
            {
                return new ResultViewModel(Result.Error, "Could not find " + instrument.Name + ". Try again later.");
            }
        }

        // POST api/instrument/insert
        [HttpPost]
        [Route("insert")]
        public ResultViewModel Insert([FromBody]Instrument instrument)
        {
            try
            {
                _context.Add(instrument);
                _context.SaveChanges();
                return new ResultViewModel(Result.Success, instrument.Name + " was successfully created.");
            }
            catch (Exception ex)
            {
                return new ResultViewModel(Result.Error, "Could not create " + instrument.Name + ". Try again later.", ex);
            }
        }

        // GET: api/instrument
        [HttpGet]
        [Route("selectAll")]
        public string SelectAll()
        {
            return Helper.ParseToJsonString(_context.Instruments.Include(s => s.Categories));
        }

        // POST api/instrument/selectById
        [HttpPost]
        [Route("selectById")]
        public ResultViewModel SelectById([FromBody]int instrumentId)
        {
            var instrument = _context.Instruments.SingleOrDefault(s => s.Id == instrumentId);
            if (instrument != null)
            {
                return new ResultViewModel(Result.Success, instrument);
            }
            else
            {
                return new ResultViewModel(Result.Error, "Could not find " + instrument.Name + ". Try again later.");
            }
        }

        // POST api/instrument/update
        [HttpPost]
        [Route("update")]
        public ResultViewModel Update([FromBody]Instrument newInstrument)
        {
            var oldInstrument = _context.Instruments.SingleOrDefault(s => s.Id == newInstrument.Id);
            if (oldInstrument != null)
            {
                try
                {
                    oldInstrument.Name = newInstrument.Name;
                    oldInstrument.UserId = newInstrument.UserId;
                    _context.SaveChanges();
                    return new ResultViewModel(Result.Success, newInstrument.Name + " was successfully updated.");
                }
                catch (Exception ex)
                {

                    return new ResultViewModel(Result.Error, "Could not update " + newInstrument.Name + ". Try again later.", ex);
                }
            }
            else
            {
                return new ResultViewModel(Result.Error, "Could not find " + newInstrument.Name + ". Try again later.");
            }

        }
    }
}
