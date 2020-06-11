using Dal.Interfaces;
using Dal.Models;
using InterfacesOfDAL.Interfaces;
using IBookRepository = Dal.Interfaces.IBookRepository;

namespace AbstractFactory
{
    public class EntityFrameworkFactory:IFactory
    {
        public IBookRepository ReturnBookRepository()
        {
            return new BookRepository();
        }

        public ICountryRepository ReturnCountryRepository()
        {
            return new CountryRepository();
        }

        public IEditionRepository ReturnEditionRepository()
        {
            return new EditionRepository();
        }

        public IIntentionRepository ReturnIntentionRepository()
        {
            return new IntentionRepository();
        }

        public ILanguageRepository ReturnLanguageRepository()
        {
            return new LanguageRepository();
        }

        public INameRepository ReturnNameRepository()
        {
            return new NameRepository();
        }

        public IProfileRepository ReturnProfileRepository()
        {
            return new ProfileRepository();
        }

        public IPublishingRepository ReturnPublishingRepository()
        {
            return new PublishingRepository();
        }

        public IReviewRepository ReturnReviewRepository()
        {
            return new ReviewRepository();
        }

        public ISecurityInformationRepository ReturnSecurityInformationRepository()
        {
            return new SecurityInformationRepository();
        }

        public ITownRepository ReturnTownRepository()
        {
            return new TownRepository();
        }

        public IGenreRepository ReturnGenreRepository()
        {
            return new GenreRepository();
        }
    }
}
