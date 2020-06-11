namespace WebCourse.Models.Repositories{
    public interface ICertificateRepository : IDbRepository<Certificate>{}
    public interface ICompanyRepository : IDbRepository<Company>{}
    public interface IContactRepository : IDbRepository<Contact>{}
    public interface IFileRepository : IDbRepository<File>{}
    public interface IInnovativeProductRepository : IDbRepository<InnovativeProduct>{}
    public interface ILicenseRepository : IDbRepository<License>{}
    public interface INewsRepository : IDbRepository<News>{}
}