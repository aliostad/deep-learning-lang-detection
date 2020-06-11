using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PhotoSiteEK.Core.Repository
{
    public interface IStorage : IDisposable
    {
        IAlbumRepository GetAlbumRepository();
        IPhotoRepository GetPhotoRepository();
        ITagRepository GetTagRepository();
        IUserRepository GetUserRepository();
        IRatingRepository GetRatingRepository();
        ICommentRepository GetCommentRepository();
        void SaveChanges();
    }
}
