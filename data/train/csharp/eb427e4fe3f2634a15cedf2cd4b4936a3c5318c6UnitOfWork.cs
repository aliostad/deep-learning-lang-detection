using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ImobiliariaModel.Models;
using ImobiliariaModel.DAL.RepositoryInterfaces;
using ImobiliariaModel.DAL.Repositories;
using ImobiliariaModel.Authorization;

namespace ImobiliariaModel.DAL
{
    public class UnitOfWork : IDisposable
    {
        private ApplicationDbContext context = new ApplicationDbContext();
        private IAnuncioRepository anuncioRepository;
        private ITipoImovelRepository tipoImovelRepository;
        private IAlertaRepository alertaRepository;
        private IUserRepository userRepository;
        private IImovelRepository imovelRepository;
        private ITipoAnuncioRepository tipoAnuncioRepository;
        private ILocalRepository localRepository;
        private IImagemRepository imagemRepository;
        private IConfigurationRepository configurationRepository;
        private ISugestaoRepository sugestaoRepository;
        private INotificacaoRepository notificacaoRepository;
        private IAgendaRepository agendaRepository;
        private IPreferenciasRepository preferenciasRepository;

        private Auth auth;

        public IAnuncioRepository AnuncioRepository
        {
            get
            {

                if (this.anuncioRepository == null)
                {
                    this.anuncioRepository = new AnuncioRepository(context);
                }
                return anuncioRepository;
            }
        }

        public IAlertaRepository AlertaRepository
        {
            get
            {

                if (this.alertaRepository == null)
                {
                    this.alertaRepository = new AlertaRepository(context);
                }
                return alertaRepository;
            }
        }

        public ITipoImovelRepository TipoImovelRepository
        {
            get
            {

                if (this.tipoImovelRepository == null)
                {
                    this.tipoImovelRepository = new TipoImovelRepository(context);
                }
                return tipoImovelRepository;
            }
        }

        public IUserRepository UserRepository
        {
            get
            {

                if (this.userRepository == null)
                {
                    this.userRepository = new UserRepository(context);
                }
                return userRepository;
            }
        }

        public IImovelRepository ImovelRepository
        {
            get
            {

                if (this.imovelRepository == null)
                {
                    this.imovelRepository = new ImovelRepository(context);
                }
                return imovelRepository;
            }
        }

        public ITipoAnuncioRepository TipoAnuncioRepository
        {
            get
            {

                if (this.tipoAnuncioRepository == null)
                {
                    this.tipoAnuncioRepository = new TipoAnuncioRepository(context);
                }
                return tipoAnuncioRepository;
            }
        }

        public ILocalRepository LocalRepository
        {
            get
            {

                if (this.localRepository == null)
                {
                    this.localRepository = new LocalRepository(context);
                }
                return localRepository;
            }
        }

        public IImagemRepository ImagemRepository
        {
            get
            {

                if (this.imagemRepository == null)
                {
                    this.imagemRepository = new ImagemRepository(context);
                }
                return imagemRepository;
            }
        }

        public IConfigurationRepository ConfigurationRepository
        {
            get
            {
                if (configurationRepository == null)
                {
                    configurationRepository = new ConfigurationRepository();
                }
                return configurationRepository;
            }
        }

        public ISugestaoRepository SugestaoRepository
        {
            get
            {
                if (sugestaoRepository == null)
                {
                    sugestaoRepository = new SugestaoRepository(context);
                }
                return sugestaoRepository;
            }
        }

        public INotificacaoRepository NotificacaoRepository
        {
            get
            {
                if (notificacaoRepository == null)
                {
                    notificacaoRepository = new NotificacaoRepository(context);
                }
                return notificacaoRepository;
            }
        }

        public IAgendaRepository AgendaRepository
        {
            get
            {
                if (agendaRepository == null)
                {
                    agendaRepository = new AgendaRepository(context);
                }
                return agendaRepository;
            }
        }

        public IPreferenciasRepository PreferenciasRepository
        {
            get
            {
                if (preferenciasRepository == null)
                {
                    preferenciasRepository = new PreferenciasRepository(context);
                }

                return preferenciasRepository;
            }
        }

        public void Save()
        {
            context.SaveChanges();
        }

        public Task<int> SaveChangesAsync()
        {
            return context.SaveChangesAsync();
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
