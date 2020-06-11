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
using CalcWebApi.Models;

namespace CalcWebApi.Controllers
{
    public class Api_DataController : ApiController
    {
        private CalcWebApiContext db = new CalcWebApiContext();

        // GET: api/Api_Data
        public IQueryable<Api_Data> GetApi_Data()
        {
            return db.Api_Data;
        }

        // GET: api/Api_Data/5
        [ResponseType(typeof(Api_Data))]
        public IHttpActionResult GetApi_Data(int id)
        {
            Api_Data api_Data = db.Api_Data.Find(id);
            if (api_Data == null)
            {
                return NotFound();
            }

            return Ok(api_Data);
        }

        // PUT: api/Api_Data/5
        [ResponseType(typeof(void))]
        public IHttpActionResult PutApi_Data(int id, Api_Data api_Data)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            if (id != api_Data.id)
            {
                return BadRequest();
            }

            db.Entry(api_Data).State = EntityState.Modified;

            try
            {
                db.SaveChanges();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!Api_DataExists(id))
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

        // POST: api/Api_Data
        [ResponseType(typeof(Api_Data))]
        public IHttpActionResult PostApi_Data(Api_Data api_Data)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            db.Api_Data.Add(api_Data);
            db.SaveChanges();

            return CreatedAtRoute("DefaultApi", new { id = api_Data.id }, api_Data);
        }

        // DELETE: api/Api_Data/5
        [ResponseType(typeof(Api_Data))]
        public IHttpActionResult DeleteApi_Data(int id)
        {
            Api_Data api_Data = db.Api_Data.Find(id);
            if (api_Data == null)
            {
                return NotFound();
            }

            db.Api_Data.Remove(api_Data);
            db.SaveChanges();

            return Ok(api_Data);
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                db.Dispose();
            }
            base.Dispose(disposing);
        }

        private bool Api_DataExists(int id)
        {
            return db.Api_Data.Count(e => e.id == id) > 0;
        }
    }
}