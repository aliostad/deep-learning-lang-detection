using System;

namespace Biodiversity.DataAccess.SqlDataTier.Repository.Interface
{
    public interface IUnitOfWork : IDisposable
    {
        ILiteratureRepository LiteratureRepository { get; }
        ITaxonRepository TaxonRepository { get; }
        IAuthorRepository AuthorRepository { get; }
        ITaxonAuthorRepository TaxonAuthorRepository { get; }
        ILiteratureAuthorRepository LiteratureAuthorRepository { get; }
        ITaxonLiteratureRepository TaxonLiteratureRepository { get; }
        int Complete();
    }
}