using System;
using SkjaTextar.Models;

namespace SkjaTextar.DAL
{
    public interface IUnitOfWork : IDisposable
    {
        IGenericRepository<Achievement> AchievementRepository { get; }
        IGenericRepository<Category> CategoryRepository { get; }
        IGenericRepository<Media> MediaRepository { get; }
        IGenericRepository<Movie> MovieRepository { get; }
        IGenericRepository<Show> ShowRepository { get; }
        IGenericRepository<Clip> ClipRepository { get; }
        IGenericRepository<Translation> TranslationRepository { get; }
        IGenericRepository<Request> RequestRepository { get; }
        IGenericRepository<User> UserRepository { get; }
        IGenericRepository<Language> LanguageRepository { get; }
        IGenericRepository<Comment> CommentRepository { get; }
		IGenericRepository<Report> ReportRepository { get; }
        IGenericRepository<RequestVote> RequestVoteRepository { get; }
		IGenericRepository<TranslationSegment> TranslationSegmentRepository { get; }

        void Save();
	}
}