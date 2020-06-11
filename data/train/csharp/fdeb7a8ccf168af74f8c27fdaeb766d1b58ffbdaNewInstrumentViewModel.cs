using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using WebInstruments.Dto;
using WebInstruments.Models;

namespace WebInstruments.ViewModels
{
    public class NewInstrumentViewModel
    {
        public IEnumerable<MeasurementUnit> MeasurementUnits { get; set; }
        public IEnumerable<Supplier> Suppliers { get; set; }
        public List<Instrument> Instruments { get; set; }
        public IEnumerable<InstrumentType> InstrumentTypes { get; set; }
        public Instrument Instrument { get; set; }
    }
}