using System.IO;
using Bsc.Dmtds.Content.Models;
using Bsc.Dmtds.Core;
using Bsc.Dmtds.Core.Persistence.Non_Relational;
using Bsc.Dmtds.Core.Persistence.Relational;

namespace Bsc.Dmtds.Content.Persistence
{
    public interface IRepositoryProvider : IProvider<Repository>
    {
        void Offline(Repository repository);

        void Online(Repository repository);

        bool IsOnline(Repository repository);

        Repository Create(string repositoryName, Stream templateStream);
        Repository Copy(Repository sourceRepository, string destRepositoryName);

        void Initialize(Repository repository);

        void Export(Repository repository, Stream outputStream);

        bool TestDbConnection();

    }
}