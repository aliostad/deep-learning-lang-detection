using CCM.Data.Models;
using System;
using System.Collections.Generic;
using System.Text;
using System.Threading.Tasks;

namespace CCM.Business.Repositories
{
    public class UnitOfWork
    {
        private CCMContext _context;
        private CampRepository _campRepository;
        private SessionRepository _sessionRepository;
        private TagRepository _tagRepository;
        private SponsorRepository _sponsorRepository;
        private SponsorTypeRepository _sponsorTypeRepository;
        private AppSettingsRepository _appSettingsRepository;
        private UsersRepository _usersRepository;

        public UnitOfWork(CCMContext context)
        {
            _context = context;
        }


        public CampRepository CampRepository
        {
            get
            {
                if (_campRepository == null)
                {
                    _campRepository = new CampRepository(_context);
                }
                return _campRepository;
            }
        }

        public SessionRepository SessionRepository
        {
            get
            {
                if (_sessionRepository == null)
                {
                    _sessionRepository = new SessionRepository(_context);
                }
                return _sessionRepository;
            }
        }

        public TagRepository TagRepository
        {
            get
            {
                if (_tagRepository == null)
                {
                    _tagRepository = new TagRepository(_context);
                }
                return _tagRepository;
            }
        }

        public SponsorRepository SponsorRepository
        {
            get
            {
                if (_sponsorRepository == null)
                {
                    _sponsorRepository = new SponsorRepository(_context);
                }
                return _sponsorRepository;
            }
        }

        public SponsorTypeRepository SponsorTypeRepository
        {
            get
            {
                if (_sponsorTypeRepository == null)
                {
                    _sponsorTypeRepository = new SponsorTypeRepository(_context);
                }
                return _sponsorTypeRepository;
            }
        }

        public AppSettingsRepository AppSettingsRepository
        {
            get
            {
                if (_appSettingsRepository == null)
                {
                    _appSettingsRepository = new AppSettingsRepository(_context);
                }
                return _appSettingsRepository;
            }
        }

        public UsersRepository UsersRepository
        {
            get
            {
                if (_usersRepository == null)
                {
                    _usersRepository  = new UsersRepository(_context);
                }
                return _usersRepository;
            }
        }

        public async Task<bool> SaveAsync()
        {
            return (await _context.SaveChangesAsync()) > 0;
        }

    }
}
