using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using RusoCars.Models;

namespace RusoCars.DAL
{
    public class UnitOfWork : IDisposable
    {
        private CarsRusoEntities context = new CarsRusoEntities();


        #region Repositories

        private GenericRepository<Category> categoryRepository;

        public GenericRepository<Category> CategoryRepository
        {
            get
            {

                if (this.categoryRepository == null)
                {
                    this.categoryRepository = new CategoryRepository(context);
                }
                return categoryRepository;
            }
        }

        private GenericRepository<Certification> certificationRepository;

        public GenericRepository<Certification> CertificationRepository
        {
            get
            {

                if (this.certificationRepository == null)
                {
                    this.certificationRepository = new CertificationRepository(context);
                }
                return certificationRepository;
            }
        }

        private GenericRepository<Client> clientRepository;

        public GenericRepository<Client> ClientRepository
        {
            get
            {

                if (this.clientRepository == null)
                {
                    this.clientRepository = new ClientRepository(context);
                }
                return clientRepository;
            }
        }

        private GenericRepository<Image> imageRepository;

        public GenericRepository<Image> ImageRepository
        {
            get
            {

                if (this.imageRepository == null)
                {
                    this.imageRepository = new ImageRepository(context);
                }
                return imageRepository;
            }
        }

        private GenericRepository<LinksCategory> linksCategoryRepository;

        public GenericRepository<LinksCategory> LinksCategoryRepository
        {
            get
            {

                if (this.linksCategoryRepository == null)
                {
                    this.linksCategoryRepository = new LinksCategoryRepository(context);
                }
                return linksCategoryRepository;
            }
        }

        private GenericRepository<Link> linkRepository;

        public GenericRepository<Link> LinkRepository
        {
            get
            {

                if (this.linkRepository == null)
                {
                    this.linkRepository = new LinkRepository(context);
                }
                return linkRepository;
            }
        }

        private GenericRepository<News> newsRepository;

        public GenericRepository<News> NewsRepository
        {
            get
            {

                if (this.newsRepository == null)
                {
                    this.newsRepository = new NewsRepository(context);
                }
                return newsRepository;
            }
        }

        private GenericRepository<Pilot> pilotRepository;

        public GenericRepository<Pilot> PilotRepository
        {
            get
            {

                if (this.pilotRepository == null)
                {
                    this.pilotRepository = new PilotRepository(context);
                }
                return pilotRepository;
            }
        }


        private GenericRepository<Team> teamRepository;

        public GenericRepository<Team> TeamRepository
        {
            get
            {

                if (this.teamRepository == null)
                {
                    this.teamRepository = new TeamRepository(context);
                }
                return teamRepository;
            }
        }

        private GenericRepository<Service> serviceRepository;

        public GenericRepository<Service> ServiceRepository
        {
            get
            {

                if (this.serviceRepository == null)
                {
                    this.serviceRepository = new ServiceRepository(context);
                }
                return serviceRepository;
            }
        }

        private SubcategoryRepository subcategoryRepository;

        public SubcategoryRepository SubcategoryRepository
        {
            get
            {

                if (this.subcategoryRepository == null)
                {
                    this.subcategoryRepository = new SubcategoryRepository(context);
                }
                return subcategoryRepository;
            }
        }
       
        private TextRepository textRepository;

        public TextRepository TextRepository
        {
            get
            {

                if (this.textRepository == null)
                {
                    this.textRepository = new TextRepository(context);
                }
                return textRepository;
            }
        }
      
        #endregion

        public void SaveChanges()
        {
            context.SaveChanges();
        }

        private bool disposed = false;

        protected virtual void Dispose(bool disposing)
        {
            if (!this.disposed)
            {
                if (disposing)
                {
                    context.Dispose();
                }
            }
            this.disposed = true;
        }

        public void Dispose()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
        }
    }
}
