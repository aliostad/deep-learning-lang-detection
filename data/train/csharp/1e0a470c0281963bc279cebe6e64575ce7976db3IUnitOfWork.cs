using System;
using Domain.Models;

namespace Domain.Repository
{
    public interface IUnitOfWork : IDisposable
    {
        Repository<User> UserRepository { get; }
        Repository<Author> AuthorRepository { get; }
        Repository<Book> BookRepository { get; }
        Repository<BorrowInfo> BorrowInfoRepository { get; }
        Repository<Genre> GenreRepository { get; }
        Repository<Language> LanguageRepository { get; }
        Repository<Publisher> PublisherRepository { get; }
        Repository<Reader> ReaderRepository { get; }
        void Save();
    }
}
