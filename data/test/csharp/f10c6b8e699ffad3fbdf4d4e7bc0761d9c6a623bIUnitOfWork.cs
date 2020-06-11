using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Vice.Entity;

namespace Vice.Repository
{
    public interface IUnitOfWork
    {
        Repository<Base_User> UserRepository { get;  }
        Repository<Base_Article> ArticleRepository { get; }
        Repository<Base_SuperStar> StarRepository { get;  }
        Repository<Base_ImageLinks> ImageRepository { get; }
        Repository<Base_Notify> NotifyRepository { get; }
        Repository<Base_Schedule> ScheduleRepository { get; }
        Repository<Base_ScrollImage> ScrollRepository { get; }
        Repository<Base_Category> CategoryRepository { get;  }
        void Save();
    }
}
