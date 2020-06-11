using System.Linq;
using Microsoft.AspNet.Mvc;

namespace Yavsc.Controllers
{
    using System.Security.Claims;
    using Models;
    using Models.Musical;
    public class InstrumentsController : Controller
    {
        private ApplicationDbContext _context;

        public InstrumentsController(ApplicationDbContext context)
        {
            _context = context;    
        }

        // GET: Instruments
        public IActionResult Index()
        {
            return View(_context.Instrument.ToList());
        }

        // GET: Instruments/Details/5
        public IActionResult Details(long? id)
        {
            if (id == null)
            {
                return HttpNotFound();
            }

            Instrument instrument = _context.Instrument.Single(m => m.Id == id);
            if (instrument == null)
            {
                return HttpNotFound();
            }

            return View(instrument);
        }

        // GET: Instruments/Create
        public IActionResult Create()
        {
            return View();
        }

        // POST: Instruments/Create
        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult Create(Instrument instrument)
        {
            if (ModelState.IsValid)
            {
                _context.Instrument.Add(instrument);
                _context.SaveChanges(User.GetUserId());
                return RedirectToAction("Index");
            }
            return View(instrument);
        }

        // GET: Instruments/Edit/5
        public IActionResult Edit(long? id)
        {
            if (id == null)
            {
                return HttpNotFound();
            }

            Instrument instrument = _context.Instrument.Single(m => m.Id == id);
            if (instrument == null)
            {
                return HttpNotFound();
            }
            return View(instrument);
        }

        // POST: Instruments/Edit/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult Edit(Instrument instrument)
        {
            if (ModelState.IsValid)
            {
                _context.Update(instrument);
                _context.SaveChanges(User.GetUserId());
                return RedirectToAction("Index");
            }
            return View(instrument);
        }

        // GET: Instruments/Delete/5
        [ActionName("Delete")]
        public IActionResult Delete(long? id)
        {
            if (id == null)
            {
                return HttpNotFound();
            }

            Instrument instrument = _context.Instrument.Single(m => m.Id == id);
            if (instrument == null)
            {
                return HttpNotFound();
            }

            return View(instrument);
        }

        // POST: Instruments/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public IActionResult DeleteConfirmed(long id)
        {
            Instrument instrument = _context.Instrument.Single(m => m.Id == id);
            _context.Instrument.Remove(instrument);
            _context.SaveChanges(User.GetUserId());
            return RedirectToAction("Index");
        }
    }
}
