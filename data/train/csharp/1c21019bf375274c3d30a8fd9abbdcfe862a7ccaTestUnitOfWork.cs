using PlantDataMVC.DAL.Interfaces;

namespace PlantDataMVC.DAL.TestData
{
    public class TestUnitOfWork : IUnitOfWork
    {
        TestGenusRepository _genusRepository;
        TestJournalEntryRepository _journalEntryRepository;
        TestJournalEntryTypeRepository _journalEntryTypeRepository;
        TestPlantStockRepository _plantStockRepository;
        TestProductTypeRepository _productTypeRepository;
        TestSeedBatchRepository _seedBatchRepository;
        TestSeedTrayRepository _seedTrayRepository;
        TestSpeciesRepository _speciesRepository;
        TestSiteRepository _siteRepository;

        public IGenusRepository GenusRepository
        {
            get
            {
                if (_genusRepository == null)
                {
                    _genusRepository = new TestGenusRepository();
                }

                return _genusRepository;
            }
        }

        public IJournalEntryRepository JournalEntryRepository
        {
            get
            {
                if (_journalEntryRepository == null)
                {
                    _journalEntryRepository = new TestJournalEntryRepository();
                }

                return _journalEntryRepository;
            }
        }

        public IJournalEntryTypeRepository JournalEntryTypeRepository
        {
            get
            {
                if (_journalEntryTypeRepository == null)
                {
                    _journalEntryTypeRepository = new TestJournalEntryTypeRepository();
                }

                return _journalEntryTypeRepository;
            }
        }

        public IPlantStockRepository PlantStockRepository
        {
            get
            {
                if (_plantStockRepository == null)
                {
                    _plantStockRepository = new TestPlantStockRepository();
                }

                return _plantStockRepository;
            }
        }

        public IProductTypeRepository ProductTypeRepository
        {
            get
            {
                if (_productTypeRepository == null)
                {
                    _productTypeRepository = new TestProductTypeRepository();
                }

                return _productTypeRepository;
            }
        }

        public ISeedBatchRepository SeedBatchRepository
        {
            get
            {
                if (_seedBatchRepository == null)
                {
                    _seedBatchRepository = new TestSeedBatchRepository();
                }

                return _seedBatchRepository;
            }
        }

        public ISeedTrayRepository SeedTrayRepository
        {
            get
            {
                if (_seedTrayRepository == null)
                {
                    _seedTrayRepository = new TestSeedTrayRepository();
                }

                return _seedTrayRepository;
            }
        }

        public ISpeciesRepository SpeciesRepository
        {
            get
            {
                if (_speciesRepository == null)
                {
                    _speciesRepository = new TestSpeciesRepository();
                }

                return _speciesRepository;
            }
        }

        public ISiteRepository SiteRepository
        {
            get
            {
                if (_siteRepository == null)
                {
                    _siteRepository = new TestSiteRepository();
                }

                return _siteRepository;
            }
        }


        public void Commit()
        {
            // How do we save?
        }

        public void Dispose()
        {
            throw new System.NotImplementedException();
        }
    }
}
