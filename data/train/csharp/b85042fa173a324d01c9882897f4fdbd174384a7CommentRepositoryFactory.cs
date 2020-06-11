using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PictureManager
{
    public class CommentRepositoryFactory
    {
        public static Func<ICommentRepository> RepositoryBuilder = CreateDefaultRepositoryBuilder;
        private static ICommentRepository CreateDefaultRepositoryBuilder()
        {
            throw new Exception("No repository builder specified.");
        }
        public ICommentRepository BuildRepository()
        {
            ICommentRepository repository = RepositoryBuilder();
            return repository;
        }
    }
}
