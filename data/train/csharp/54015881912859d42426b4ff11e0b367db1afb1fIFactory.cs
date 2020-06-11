using Dal.Interfaces;
using InterfacesOfDAL.Interfaces;
using INameRepository = Dal.Interfaces.INameRepository;

namespace AbstractFactory
{
    public interface IFactory
    {
        IBookRepository ReturnBookRepository();
        ICountryRepository ReturnCountryRepository();
        IEditionRepository ReturnEditionRepository();
        IIntentionRepository ReturnIntentionRepository();
        ILanguageRepository ReturnLanguageRepository();
        INameRepository ReturnNameRepository();
        IProfileRepository ReturnProfileRepository();
        IPublishingRepository ReturnPublishingRepository();
        IReviewRepository ReturnReviewRepository();
        ISecurityInformationRepository ReturnSecurityInformationRepository();
        ITownRepository ReturnTownRepository();
        IGenreRepository ReturnGenreRepository();
    }
}
