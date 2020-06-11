using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Web.Data.Entities;
using Web.Data.Repositories;

namespace Web.Controllers.Api
{
    public class InvoiceController : Controller
    {
        private readonly IMonthRepository _monthRepository;
        private readonly IInvoiceRepository _invoiceRepository;
        private readonly IKindRepository _kindRepository;
        private readonly IProviderRepository _providerRepository;

        public InvoiceController(IInvoiceRepository invoiceRepository, IKindRepository kindRepository,
            IProviderRepository providerRepository, IMonthRepository monthRepository)
        {
            _invoiceRepository = invoiceRepository;
            _kindRepository = kindRepository;
            _providerRepository = providerRepository;
            _monthRepository = monthRepository;
        }

        [HttpGet("api/invoices")]
        public IActionResult Get()
        {
            var entity = _invoiceRepository.GetAll();
            return Ok(entity);
        }
    }
}
