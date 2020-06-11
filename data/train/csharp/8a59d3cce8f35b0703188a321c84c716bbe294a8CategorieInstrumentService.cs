using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using TP3_A.Models;

namespace TP3_A.DAL.impl
{
    public class CategorieInstrumentService : GenericService<CategorieInstrument>
    {
        public CategorieInstrumentService(IRepository<CategorieInstrument> repo) : base(repo) { }

        public Dictionary<CategorieInstrument, int> GetStatLocationPerCategorie()
        {
            Dictionary<CategorieInstrument, int> entries = new Dictionary<CategorieInstrument, int>();

            foreach (CategorieInstrument categorie in Get())
            {
                int sum = categorie.Instruments.Sum(x => x.Locations.Count());

                entries[categorie] = sum;
            }

            return entries;
        }
    }
}