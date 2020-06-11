using System;
using Biocontext.Web.DataAccess.Entity;
using Biodiversity.Web.DataAccess.Entity;
using Biodiversity.Web.DataAccess.Repository.Concrete;

namespace Biodiversity.Web.DataAccess.Repository.UnitOfWork
{
    public class UnitOfWork : IDisposable
    {
        private readonly Biocontext _context;
        private Repository<Author> _authorRepository;
        private Repository<LiteratureAuthor> _literatureAuthorRepository;
        private Repository<Literature> _literatureRepository;
        private Repository<TaxonAuthor> _taxonAuthorRepository;
        private Repository<TaxonLiterature> _taxonLiteratureRepository;
        private Repository<Taxon> _taxonRepository;

        public UnitOfWork()
        {
            _context = new Biocontext();
        }

        public Repository<Author> AuthorRepository
        {
            get
            {
                if (_authorRepository == null)
                {
                    _authorRepository = new Repository<Author>(_context);
                }
                return _authorRepository;
            }
        }

        public Repository<Literature> LiteratureRepository
        {
            get
            {
                if (_literatureRepository == null)
                {
                    _literatureRepository = new Repository<Literature>(_context);
                }
                return _literatureRepository;
            }
        }

        public Repository<Taxon> TaxonRepository
        {
            get
            {
                if (_taxonRepository == null)
                {
                    _taxonRepository = new Repository<Taxon>(_context);
                }
                return _taxonRepository;
            }
        }

        public Repository<LiteratureAuthor> ReferenceAuthorRepository
        {
            get
            {
                if (_literatureAuthorRepository == null)
                {
                    _literatureAuthorRepository = new Repository<LiteratureAuthor>(_context);
                }
                return _literatureAuthorRepository;
            }
        }

        public Repository<TaxonAuthor> TaxonAuthorRepository
        {
            get
            {
                if (_taxonAuthorRepository == null)
                {
                    _taxonAuthorRepository = new Repository<TaxonAuthor>(_context);
                }
                return _taxonAuthorRepository;
            }
        }

        public Repository<TaxonLiterature> TaxonLiteratureRepository
        {
            get
            {
                if (_taxonLiteratureRepository == null)
                {
                    _taxonLiteratureRepository = new Repository<TaxonLiterature>(_context);
                }
                return _taxonLiteratureRepository;
            }
        }

        public void Dispose()
        {
            _context.Dispose();
        }

        public void SaveChanges()
        {
            _context.SaveChanges();
        }
    }
}