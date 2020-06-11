using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Bin.Helpers
{
    internal class FunctionHelpers
    {

        #region members

        private Repository.ArizaSetiRespository _arizaSetiRepositoryInsatnce;
        private Repository.FirmaRepository _firmaRepositoryInstance;
        private Repository.KullaniciRespository _kullaniciRepositoryInstance;
        private Repository.MailAdresiRepository _mailAdresRepositoryInstance;
        private Repository.MailGorevRepository _mailGorevRepositoryInstance;
        private Repository.MailSablonRepository _mailSablonRepositoryInstance;
        private Repository.MarkaRespository _markaRepositoryInstance;
        private Repository.MusteriRepository _musteriRepositoryInstance;
        private Repository.ServisDurumuRespository _servisDurumuRepositoryInstance;
        private Repository.ServisRepository _servisRepositoryInstance;
        private Repository.StokRepository _stokRepositoryInstance;
        private Repository.UcretRepository _ucretRepositoryInstance;
        private Repository.UrunRepository _urunRepositoryInstance;
        private Repository.UrunTipiRepository _urunTipiRepositoryInstance;
        

        #endregion

        #region properties

        public Repository.ArizaSetiRespository ArizaSetiRespository 
        {
            get { return _arizaSetiRepositoryInsatnce; }
        }
        public Repository.FirmaRepository FirmaRepository
        {
            get { return _firmaRepositoryInstance; }
        }
        public Repository.KullaniciRespository KullaniciRespository
        {
            get { return _kullaniciRepositoryInstance; }
        }
        public Repository.MailAdresiRepository MailAdresiRepository
        {
            get { return _mailAdresRepositoryInstance; }
        }
        public Repository.MailGorevRepository MailGorevRepository
        {
            get { return _mailGorevRepositoryInstance; }
        }
        public Repository.MailSablonRepository MailSablonRepository
        {
            get { return _mailSablonRepositoryInstance; }
        }

        public Repository.MarkaRespository MarkaRespository
        {
            get { return _markaRepositoryInstance; }
        }
        public Repository.MusteriRepository MusteriRepository
        {
            get { return _musteriRepositoryInstance; }
        }
        public Repository.ServisDurumuRespository ServisDurumuRespository
        {
            get { return _servisDurumuRepositoryInstance; }
        }
        public Repository.ServisRepository ServisRepository
        {
            get { return _servisRepositoryInstance; }
        }
        public Repository.StokRepository StokRepository
        {
            get { return _stokRepositoryInstance; }
        }
        public Repository.UcretRepository UcretRepository
        {
            get { return _ucretRepositoryInstance; }
        }
        public Repository.UrunRepository UrunRepository
        {
            get { return _urunRepositoryInstance; }
        }
        public Repository.UrunTipiRepository UrunTipiRepository
        {
            get { return _urunTipiRepositoryInstance; }
        }

        #endregion

        #region singelton

        private static FunctionHelpers _instance;

        public static FunctionHelpers Instance 
        {
            get
            {
                if(_instance==null)
                {
                    _instance = new FunctionHelpers();
                }
                return _instance;
            }
        }

        private FunctionHelpers()
        {
            _arizaSetiRepositoryInsatnce = new Repository.ArizaSetiRespository();
            _firmaRepositoryInstance = new Repository.FirmaRepository();
            _kullaniciRepositoryInstance = new Repository.KullaniciRespository();
            _mailAdresRepositoryInstance = new Repository.MailAdresiRepository();
            _mailGorevRepositoryInstance = new Repository.MailGorevRepository();
            _mailSablonRepositoryInstance = new Repository.MailSablonRepository();
            _markaRepositoryInstance = new Repository.MarkaRespository();
            _musteriRepositoryInstance = new Repository.MusteriRepository();
            _servisDurumuRepositoryInstance = new Repository.ServisDurumuRespository();
            _servisRepositoryInstance = new Repository.ServisRepository();
            _ucretRepositoryInstance = new Repository.UcretRepository();
            _urunRepositoryInstance = new Repository.UrunRepository();
            _urunTipiRepositoryInstance = new Repository.UrunTipiRepository();


        }

        #endregion

    }
}
