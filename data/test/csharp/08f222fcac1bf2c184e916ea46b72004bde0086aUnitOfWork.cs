using System;
using Pixel.Aruba.Web.DataContexts;

namespace Pixel.Aruba.Web.DataLayer
{
    public interface IUnitOfWork : IDisposable
    {
        IAgentRepository AgentRepository { get; }
        ITemplateMetadataRepository TemplateMetadataRepository { get; }
        ITemplateContentRepository TemplateContentRepository { get; }
        IPageThumbnailRepository PageThumbnailRepository { get; }
        IPagePdfRepository PagePdfRepository { get; }
        IPrintPdfRepository PrintPdfRepository { get; }
        IVitecObjectRepository VitecObjectRepository { get; }
        IVitecValueMappingsRepository VitecValueMappingsRepository { get; }
        IPrintRepository PrintRepository { get; }
        IPageRepository PageRepository { get; }
        IFieldValueRepository FieldValueRepository { get; }
        void Save();
    }

    public class UnitOfWork : IUnitOfWork
    {
        private readonly ApplicationDb _db = new ApplicationDb();
        private IAgentRepository _agentRepository;
        private ITemplateMetadataRepository _templateMetadataRepository;
        private ITemplateContentRepository _templateContentRepository;
        private IPageThumbnailRepository _pageThumbnailRepository;
        private IPagePdfRepository _pagePdfRepository;
        private IPrintPdfRepository _printPdfRepository;
        private IVitecObjectRepository _vitecObjectRepository;
        private IVitecValueMappingsRepository _vitecValueMappingsRepository;
        private IPrintRepository _printRepository;
        private IPageRepository _pageRepository;
        private IFieldValueRepository _fieldValueRepository;

        public IAgentRepository AgentRepository { get { return _agentRepository ?? (_agentRepository = new AgentRepository(_db)); } }
        public ITemplateMetadataRepository TemplateMetadataRepository { get { return _templateMetadataRepository ?? (_templateMetadataRepository = new TemplateMetadataRepository()); } }
        public ITemplateContentRepository TemplateContentRepository { get { return _templateContentRepository ?? (_templateContentRepository = new TemplateContentRepository()); } }
        public IPageThumbnailRepository PageThumbnailRepository { get { return _pageThumbnailRepository ?? (_pageThumbnailRepository = new PageThumbnailRepository()); } }
        public IPagePdfRepository PagePdfRepository { get { return _pagePdfRepository ?? (_pagePdfRepository = new PagePdfRepository()); } }
        public IPrintPdfRepository PrintPdfRepository { get { return _printPdfRepository ?? (_printPdfRepository = new PrintPdfRepository()); } }
        public IVitecObjectRepository VitecObjectRepository { get { return _vitecObjectRepository ?? (_vitecObjectRepository = new VitecObjectRepository()); } }
        public IVitecValueMappingsRepository VitecValueMappingsRepository { get { return _vitecValueMappingsRepository ?? (_vitecValueMappingsRepository = new VitecValueMappingsRepository(_db)); } }
        public IPrintRepository PrintRepository { get { return _printRepository ?? (_printRepository = new PrintRepository(_db)); } }
        public IPageRepository PageRepository { get { return _pageRepository ?? (_pageRepository = new PageRepository(_db)); } }
        public IFieldValueRepository FieldValueRepository { get { return _fieldValueRepository ?? (_fieldValueRepository = new FieldValueRepository(_db)); } }

        public void Save()
        {
            _db.SaveChanges();
        }



        private bool _disposed = false;

        protected virtual void Dispose(bool disposing)
        {
            if (!_disposed)
            {
                if (disposing)
                {
                    _db.Dispose();
                }
            }
            _disposed = true;
        }
        public void Dispose()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
        }
    }
}