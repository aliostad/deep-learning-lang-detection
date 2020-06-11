using DAL.ORM.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace DAL.Interfaces
{
    public interface IAchievementRepository : IEntityRepository<Achievement> { }
    public interface IAchievementUserRepository : IEntityRepository<AchievementUser> { }
    public interface ICommentRepository : IEntityRepository<Comment> { }
    public interface IContentRepository : IEntityRepository<Content> { }
    public interface ILanguageRepository : IEntityRepository<Language> { }
    public interface ILayoutRepository : IEntityRepository<Layout> { }
    public interface IPageRepository : IEntityRepository<Page> { }
    public interface ISiteRepository : IEntityRepository<Site> { }
    public interface IStyleRepository : IEntityRepository<Style> { }
    public interface IStyleMenuRepository : IEntityRepository<StyleMenu> { }
    public interface ITagRepository : IEntityRepository<Tag> { }
    public interface ITagSiteRepository : IEntityRepository<TagSite> { }
}
