using System.Web;
using SharpCMS.Infrastructure;
using SharpCMS.Model;
using SharpCMS.Repository.EF;
using SharpCMS.Repository.EF.Repositories;

namespace SharpCMS.Service.IoC
{
    public static class ServiceFactory
    {
        public static ContentService CreateContentService()
        {
            IUnitOfWork uow = new EFUnitOfWork();
            IArticleRepository articleRepository = new ArticleRepository(uow);
            ISiteNodeRepository siteNodeRepository = new SiteNodeRepository(uow);
            INewsRepository newsRepository = new NewsRepository(uow);
            ICompanyRepository companyRepository = new CompanyRepository(uow);
            IIdeaRepository ideaRepository = new IdeaRepository(uow);
            ICommentRepository commentRepository = new CommentRepository(uow);
            IVacancyRepository vacancyRepository = new VacancyRepository(uow);
            IAnnouncementRepository announcementRepository = new AnnouncementRepository(uow);
            
            return new ContentService(articleRepository, siteNodeRepository, newsRepository, companyRepository, ideaRepository,
                 commentRepository, vacancyRepository, announcementRepository, uow, HttpContext.Current);
        }
    }
}