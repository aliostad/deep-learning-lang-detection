namespace bd.machine.dal.Interfaces
{
	using Repositories;

	public interface IUnitOfWork
	{
		IFragmentRepository FragmentRepository { get; }

		IHostRepository HostRepository { get; }

		IPathRepository PathRepository { get; }

		IPortRepository PortRepository { get; }

		IQueryRepository QueryRepository { get; }

		IRawHtmlRepository RawHtmlRepository { get; }

		ISchemeRepository SchemeRepository { get; }

		IUrlMetadataRepository UrlMetadataRepository { get; }

		IRawHostRepository RawHostRepository { get; }

		IRawUrlRepository RawUrlRepository { get; }

		ICrawlableUrlRepository CrawlableUrlRepository { get; }
	}
}
