using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace AllLifeDataCollector_EXE
{
    class Repository
    {
        private Int32 repositoryID;
        private string repositoryType;
        private string repositoryName;
        private string repositoryServerName;
        private string repositoryUsername;
        private string repositoryPassword;
        private string repositoryDBName;

        public Repository()
        {
        }

        public Repository(Int32 _RepositoryID, string _RepositoryType, string _RepositoryName, string _RepositoryServerName, string _RepositoryUsername, string _RepositoryPassword, string _RepositoryDBName)
        {
            this.repositoryID = _RepositoryID;
            this.repositoryType = _RepositoryType;
            this.repositoryName = _RepositoryDBName;
            this.repositoryServerName = _RepositoryServerName;
            this.repositoryUsername = _RepositoryUsername;
            this.repositoryPassword = _RepositoryPassword;
            this.repositoryDBName = _RepositoryDBName;
        }

        public Int32 RepositoryID
        {
            get { return this.repositoryID; }
            set { this.repositoryID = value; }
        }

        public string RepositoryType
        {
            get { return this.repositoryType; }
            set { this.repositoryType = value; }
        }

        public string RepositoryName
        {
            get { return this.repositoryName; }
            set { this.repositoryName = value; }
        }

        public string RepositoryServerName
        {
            get { return this.repositoryServerName; }
            set { this.repositoryServerName = value; }
        }

        public string RepositoryUsername
        {
            get { return this.repositoryUsername; }
            set { this.repositoryUsername = value; }
        }

        public string RepositoryPassword
        {
            get { return this.repositoryPassword; }
            set { this.repositoryPassword = value; }
        }

        public string RepositoryDBName
        {
            get { return this.repositoryDBName; }
            set { this.repositoryDBName = value; }
        }
    }
}
