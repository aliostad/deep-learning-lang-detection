using System.Collections.Generic;
using Charltone.Domain.Entities;
using System.Linq;

namespace Charltone.UI.Extensions
{
    public static class InstrumentExtensions
    {
        public static ICollection<Product> Sort(this ICollection<Product> products)
        {
            return products
                    .Where(product => product.Instrument != null)
                    .OrderBy(product => product.Instrument.InstrumentType.SortOrder)
                    .ThenBy(product => product.Instrument.Classification.SortOrder)
                    .ThenBy(product => product.Instrument.SubClassification.SortOrder)
                    .ThenBy(product => product.Instrument.Model)
                    .ThenBy(product => product.Instrument.Sn)
                    .ToArray();
        }
    }
}