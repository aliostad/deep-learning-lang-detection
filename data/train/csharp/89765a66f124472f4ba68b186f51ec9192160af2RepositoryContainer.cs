using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace badpaybad.Scraper.Repository
{
    public sealed class RepositoryContainer
    {
        public static readonly ILinkRepository LinkRepository;
        public static readonly IFileRepository FileRepository;
        public static readonly IDocumentRepository DocumentRepository;
        public static readonly IDataCollectRepository DataCollectRepository;


        static RepositoryContainer()
        {
            LinkRepository = new LinkRepository();
            FileRepository = new FileRepository();
            DocumentRepository = new DocumentRepository();
            DataCollectRepository = new DataCollectRepository();
        }
    }
}
