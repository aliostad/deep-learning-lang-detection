using NPoco;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace KinsailMVC.Models
{
    // Repository factory
    public class RepositoryFactory
    {
        private readonly IDatabase _database;
        private SiteRepository _siteRepository;
        private LocationRepository _locationRepository;

        public RepositoryFactory(IDatabase database)
        {
            _database = database;
        }

        public SiteRepository siteRepository
        {
            get { return _siteRepository ?? (_siteRepository = new SiteRepository(_database)); }
        }

        public LocationRepository locationRepository
        {
            get { return _locationRepository ?? (_locationRepository = new LocationRepository(_database)); }
        }
    }
}