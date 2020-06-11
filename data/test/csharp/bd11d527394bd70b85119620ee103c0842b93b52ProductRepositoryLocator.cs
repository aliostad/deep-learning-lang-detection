using HonestBobs.Business;
using HonestBobs.Core;
using HonestBobs.Data;

namespace HonestBobs.Web.Infrastructure
{
	/// <summary>
	/// The product repository locator has a reference for every product related repository.
	/// </summary>
	public class ProductRepositoryLocator : IProductRepositoryLocator
	{
		private readonly IBookRepository bookRepository;
		private readonly IMovieRepository movieRepository;

		/// <summary>
		/// Initializes a new instance of the <see cref="ProductRepositoryLocator" /> class.
		/// </summary>
		/// <param name="bookRepository">The book repository.</param>
		/// <param name="movieRepository">The movie repository.</param>
		public ProductRepositoryLocator(IBookRepository bookRepository, IMovieRepository movieRepository)
		{
			Guard.ArgumentNotNull(bookRepository, "bookRepository");
			Guard.ArgumentNotNull(movieRepository, "movieRepository");

			this.bookRepository = bookRepository;
			this.movieRepository = movieRepository;
		}

		/// <summary>
		/// Gets the book repository.
		/// </summary>
		public IBookRepository BookRepository
		{
			get { return this.bookRepository; }
		}

		/// <summary>
		/// Gets the movie repository.
		/// </summary>
		public IMovieRepository MovieRepository
		{
			get { return this.movieRepository; }
		}
	}
}