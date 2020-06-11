
namespace FileSystemDAL.Tests
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using FileSystemDAL.Helper;
    using FileSystemDAL.Manage;
    using FileSystemDAL.Models;
    using NHibernate;
    using NUnit.Framework;

    /// <summary>
    /// The person test.
    /// </summary>
    [TestFixture]
    public class AdminTest
    {
        /// <summary>
        /// The repository name list.
        /// </summary>
        private List<string> repositoryNameList;

        /// <summary>
        /// The admin.
        /// </summary>
        private Admin admin;

        /// <summary>
        /// The init.
        /// </summary>
        [SetUp]
        public void Init()
        {
            this.repositoryNameList = new List<string>() { "Anonymus", "Anonymus2", "Anonymus3" };
            this.admin = new Admin();
        }

        /// <summary>
        /// The delete repository test.
        /// </summary>
        [Test]
        public void DeleteRepositoryTest()
        {
            var addedRepository = new List<Repository>();
            
            foreach (var repositoryName in this.repositoryNameList)
            {
                addedRepository.Add(this.AddRepository(new Repository { RepositoryName = repositoryName, DateAttach = DateTime.Now, IsActive = false }));
            }

            var listRepository = this.admin.GetListRepository();

            foreach (var repository in addedRepository)
            {
                Assert.AreEqual(true, listRepository.Any(x => x.RepositoryName == repository.RepositoryName));
            }

            foreach (var repository in addedRepository)
            {
                this.admin.DeleteRepository(repository.RepositoryId);
            }

            listRepository = this.admin.GetListRepository();

            foreach (var repository in addedRepository)
            {
                Assert.AreEqual(false, listRepository.Any(x => x.RepositoryName == repository.RepositoryName));
            }
        }

        /// <summary>
        /// The active repository test.
        /// </summary>
        [Test]
        public void ActiveRepositoryTest()
        {
            this.AddRepository(new Repository { RepositoryName = this.repositoryNameList[0], DateAttach = DateTime.Now, IsActive = false });

            var listRepository = this.admin.GetListRepository();

            var repository = listRepository.Single(x => x.RepositoryName == this.repositoryNameList[0]);

            Assert.AreEqual(repository.IsActive, false);

            this.admin.ActiveRepository(repository.RepositoryId);
            listRepository = this.admin.GetListRepository();

            repository = listRepository.Single(x => x.RepositoryName == this.repositoryNameList[0]);

            Assert.AreEqual(repository.IsActive, true);

            this.admin.DeleteRepository(repository.RepositoryId);
        }

        /// <summary>
        /// The deactive repository test.
        /// </summary>
        [Test]
        public void DeactiveRepositoryTest()
        {
            this.AddRepository(new Repository { RepositoryName = this.repositoryNameList[0], DateAttach = DateTime.Now, IsActive = true });

            var listRepository = this.admin.GetListRepository();

            var repository = listRepository.Single(x => x.RepositoryName == this.repositoryNameList[0]);

            Assert.AreEqual(repository.IsActive, true);

            this.admin.DeactiveRepository(repository.RepositoryId);
            listRepository = this.admin.GetListRepository();

            repository = listRepository.Single(x => x.RepositoryName == this.repositoryNameList[0]);

            Assert.AreEqual(repository.IsActive, false);

            this.admin.DeleteRepository(repository.RepositoryId);
        }

        /// <summary>
        /// The add repository.
        /// </summary>
        /// <param name="repository">
        /// The repository.
        /// </param>
        private Repository AddRepository(Repository repository)
        {

            using (var session = NHibernateHelper.OpenSession())
            {
                using (ITransaction transaction = session.BeginTransaction())
                {
                    repository.RepositoryId = (int)session.Save(repository);
                    transaction.Commit();
                }
            }
            return repository;
        }
    }
}
