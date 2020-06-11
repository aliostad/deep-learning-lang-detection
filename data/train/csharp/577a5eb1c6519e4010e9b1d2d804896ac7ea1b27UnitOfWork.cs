using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace UurFac.Models.Repo
{
    public class UnitOfWork : IUnitOfWork
    {
        private UurFacContext context;

        private IDepartementKlantRepository departementKlantRepository;
        private IDepartementRepository departementRepository;
        private IFactuurRepository factuurRepository;
        private IGebruikerKlantRepository gebruikerKlantRepository;
        private IGebruikerRepository gebruikerRepository;
        private IKlantRepository klantRepository;
        private TariefRepository tariefRepository;
        private IUurRegistratieRepository uurRegistratieRepository;
        private IGebruikerDepartementRepository gebruikerDepartementRepository;
        private IUurRegistratieDetailRepository uurRegistratieDetailRepository;

        private IdentityManager identityManager;

        public UnitOfWork()
        {
            context = new UurFacContext();
        }

        public IdentityManager IdentityManager
        {
            get
            {
                if (identityManager == null)
                {
                    identityManager = new IdentityManager(context);
                }
                return identityManager;
            }
        }

        public IDepartementKlantRepository DepartementKlantRepository
        {
            get
            {
                if (departementKlantRepository == null)
                {
                    departementKlantRepository = new DepartementKlantRepository(context);
                }
                return departementKlantRepository;
            }
        }

        public IDepartementRepository DepartementRepository
        {
            get
            {
                if (departementRepository == null)
                {
                    departementRepository = new DepartementRepository(context);
                }
                return departementRepository;
            }
        }

        public IFactuurRepository FactuurRepository
        {
            get
            {
                if (factuurRepository == null)
                {
                    factuurRepository = new FactuurRepository(context);
                }
                return factuurRepository;
            }
        }

        public IGebruikerKlantRepository GebruikerKlantRepository
        {
            get
            {
                if (gebruikerKlantRepository == null)
                {
                    gebruikerKlantRepository = new GebruikerKlantRepository(context);
                }
                return gebruikerKlantRepository;
            }
        }

        public IGebruikerRepository GebruikerRepository
        {
            get
            {
                if (gebruikerRepository == null)
                {
                    gebruikerRepository = new GebruikerRepository(context);
                }
                return gebruikerRepository;
            }
        }

        public IKlantRepository KlantRepository
        {
            get
            {
                if (klantRepository == null)
                {
                    klantRepository = new KlantRepository(context);
                }
                return klantRepository;
            }
        }

        public ITariefRepository TariefRepository
        {
            get
            {
                if (tariefRepository == null)
                {
                    tariefRepository = new TariefRepository(context);
                }
                return tariefRepository;
            }
        }

        public IUurRegistratieRepository UurRegistratieRepository
        {
            get
            {
                if (uurRegistratieRepository == null)
                {
                    uurRegistratieRepository = new UurRegistratieRepository(context);
                }
                return uurRegistratieRepository;
            }
        }

        public IUurRegistratieDetailRepository UurRegistratieDetailRepository
        {
            get
            {
                if (uurRegistratieDetailRepository == null)
                {
                    uurRegistratieDetailRepository = new UurRegistratieDetailRepository(context);
                }
                return uurRegistratieDetailRepository;
            }
        }

        public IGebruikerDepartementRepository GebruikerDepartementRepository
        {
            get
            {
                if (gebruikerDepartementRepository == null)
                {
                    gebruikerDepartementRepository = new GebruikerDepartementRepository(context);
                }
                return gebruikerDepartementRepository;
            }
        }

        public UurFacContext Context
        {
            get
            {
                return context;
            }            
        }

        public void saveChanges()
        {
            context.SaveChanges();
        }

        public void Dispose()
        {
            context.Dispose();            
        }
    }

    public interface IUnitOfWork : IDisposable
    {
        void saveChanges();
        IDepartementKlantRepository DepartementKlantRepository { get; }
        IDepartementRepository DepartementRepository { get; }
        IFactuurRepository FactuurRepository { get; }
        IGebruikerKlantRepository GebruikerKlantRepository { get; }
        IGebruikerRepository GebruikerRepository { get; }
        IKlantRepository KlantRepository { get; }
        ITariefRepository TariefRepository { get; }
        IUurRegistratieRepository UurRegistratieRepository { get; }
        IUurRegistratieDetailRepository UurRegistratieDetailRepository { get; }
        IGebruikerDepartementRepository GebruikerDepartementRepository { get; }
        IdentityManager IdentityManager { get; }
        UurFacContext Context { get; }
    }
}