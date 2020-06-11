using PersonRepository.CSV;
using PersonRepository.Interface;
using PersonRepository.Service;
using PersonRepository.SQL;
using System;

namespace PeopleViewer
{
    public static class RepositoryFactory
    {
        public static IPersonRepository GetRepository(string repositoryType)
        {
            IPersonRepository repository = null;

            switch (repositoryType)
            {
                case "Service": repository = new ServiceRepository();
                    break;
                case "CSV": repository = new CSVRepository();
                    break;
                case "SQL": repository = new SQLRepository();
                    break;
                default:
                    throw new ArgumentException("Invalid repository type");
            }

            return repository;
        }
    }
}
