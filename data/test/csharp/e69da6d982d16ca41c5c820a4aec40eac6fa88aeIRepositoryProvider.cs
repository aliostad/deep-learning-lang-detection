﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Kooboo.CMS.Content.Models;
using System.IO;

namespace Kooboo.CMS.Content.Persistence
{
    public interface IRepositoryProvider : IProvider<Repository>
    {
        IQueryable<Repository> All();

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
