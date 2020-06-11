using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Data.Entity.Infrastructure;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Web.Http.Description;
using Application_ARWDA.Model;

namespace Application_ARWDA.Controllers
{
    public class MasterInstrumentsController : ApiController
    {
        private ARWDADatabaseEntities4 db = new ARWDADatabaseEntities4();

        // GET: api/MasterInstruments
        public IQueryable<MasterInstrument> GetMasterInstruments()
        {
            return db.MasterInstruments;
        }

        // GET: api/MasterInstruments/5
        [ResponseType(typeof(MasterInstrument))]
        public IHttpActionResult GetMasterInstrument(int id)
        {
            MasterInstrument masterInstrument = db.MasterInstruments.Find(id);
            if (masterInstrument == null)
            {
                return NotFound();
            }

            return Ok(masterInstrument);
        }

        // PUT: api/MasterInstruments/5
        [ResponseType(typeof(void))]
        public IHttpActionResult PutMasterInstrument(int id, MasterInstrument masterInstrument)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            if (id != masterInstrument.DividendID)
            {
                return BadRequest();
            }

            db.Entry(masterInstrument).State = EntityState.Modified;

            try
            {
                db.SaveChanges();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!MasterInstrumentExists(id))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }

            return StatusCode(HttpStatusCode.NoContent);
        }

        // POST: api/MasterInstruments
        [ResponseType(typeof(MasterInstrument))]
        public IHttpActionResult PostMasterInstrument(MasterInstrument masterInstrument)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            db.MasterInstruments.Add(masterInstrument);

            try
            {
                db.SaveChanges();
            }
            catch (DbUpdateException)
            {
                if (MasterInstrumentExists(masterInstrument.DividendID))
                {
                    return Conflict();
                }
                else
                {
                    throw;
                }
            }

            return CreatedAtRoute("DefaultApi", new { id = masterInstrument.DividendID }, masterInstrument);
        }

        // DELETE: api/MasterInstruments/5
        [ResponseType(typeof(MasterInstrument))]
        public IHttpActionResult DeleteMasterInstrument(int id)
        {
            MasterInstrument masterInstrument = db.MasterInstruments.Find(id);
            if (masterInstrument == null)
            {
                return NotFound();
            }

            db.MasterInstruments.Remove(masterInstrument);
            db.SaveChanges();

            return Ok(masterInstrument);
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                db.Dispose();
            }
            base.Dispose(disposing);
        }

        private bool MasterInstrumentExists(int id)
        {
            return db.MasterInstruments.Count(e => e.DividendID == id) > 0;
        }
    }
}