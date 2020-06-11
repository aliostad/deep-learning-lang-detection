using Pathfinder.Domain.Repository;

namespace Pathfinder.Domain
{
    public interface IRepositoryFactory
    {
        /// <summary>
        /// Gets content repository
        /// </summary>
        /// <returns></returns>
        IContentRepository GetContentRepository();

        /// <summary>
        /// Gets Artifact repository
        /// </summary>
        /// <returns></returns>
        IArtifactRepository GetArtifactRepository();

        /// <summary>
        /// Gets Map repository
        /// </summary>
        /// <returns></returns>
        IMapRepository GetMapRepository();

        /// <summary>
        /// Gets user repository
        /// </summary>
        /// <returns></returns>
        IUserRepository GetUserRepository();

        /// <summary>
        /// Gets person repository
        /// </summary>
        /// <returns></returns>
        IPersonRepository GetPersonRepository();

        /// <summary>
        /// Gets bot repository
        /// </summary>
        /// <returns></returns>
        IBotRepository GetBotRepository();
    }
}