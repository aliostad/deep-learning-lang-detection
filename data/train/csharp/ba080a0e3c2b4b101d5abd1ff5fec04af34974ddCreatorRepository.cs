using Repository;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RepositoryFactory.Creator
{
   public enum RepositoryEnum
    {
        SqlRepository, XmlRepository, CollectionRepository
    }

   public static class CreatorRepository
    {
        public static AbstractRepository Create(RepositoryEnum repository)
        {
            switch (repository)
            {
                case RepositoryEnum.SqlRepository:
                    return new SqlRepository();
                // case RepositoryEnum.CollectionRepository:
               //     return new CollectionRepository();
                // case RepositoryEnum.XmlRepository:
               //     return new XmlRepository();
                 default: return new SqlRepository();
            }
        }
    }
}

