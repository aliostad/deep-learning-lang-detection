using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Data.Entity.Infrastructure;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using VetTrainer.Models;
using VetTrainer.Models.DataTransferObjs;

namespace VetTrainer.Controllers.Apis
{
    public class InstrumentModifyController : ApiController
    {
        VetAppDBContext _context = new VetAppDBContext();

        protected override void Dispose(bool disposing)
        {
            _context.Dispose();
        }

        public IHttpActionResult PostInstrumentModify(InstrumentDto instrument)
        {
            string msg = "";
            if (instrument == null)
            {
                msg = "参数错误";
            }
            var instrumentToUpdate = _context.Instruments.Find(instrument.Id);
            instrumentToUpdate.Name = instrument.Name;
            instrumentToUpdate.Description = instrument.Description;
            instrumentToUpdate.ModelUrl = instrument.ModelUrl;
            try
            {
                _context.Entry(instrumentToUpdate).State = EntityState.Modified;
                _context.SaveChanges();
                msg = "修改成功";
            }
            catch (RetryLimitExceededException)
            {
                msg = "网络故障";
            }
            var str = "{ \"Message\" : \"" + msg + "\" , \"" + "Data\" : \"" + "null" + "\" }";
            return Ok(str);
        }
    }
}
